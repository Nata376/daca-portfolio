# automaatika.py — Täielik ja automatiseeritud andmetöötluse skript
import os
from datetime import datetime
import pandas as pd
from dotenv import load_dotenv
from supabase import create_client, Client
import plotly.express as px

# 1. Laadime keskkonnamuutujad (.env failist Supabase andmed)
load_dotenv()
SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_KEY")

if not SUPABASE_URL or not SUPABASE_KEY:
    raise ValueError("⚠️ SUPABASE_URL või SUPABASE_KEY puudub .env failist!")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

def fetch_all_sales() -> pd.DataFrame:
    """Pärib Supabase'ist KÕIK müügiandmed (ületab 1000-realise API limiidi)."""
    all_data = []
    limit = 1000
    offset = 0
    
    print("⏳ Pärin andmeid Supabase'ist (lehehaaval)...")
    while True:
        response = supabase.table('sales').select("*").range(offset, offset + limit - 1).execute()
        chunk = response.data
        if not chunk:
            break
        all_data.extend(chunk)
        if len(chunk) < limit:
            break
        offset += limit
        
    return pd.DataFrame(all_data)

def run_automation_pipeline():
    print("🚀 Alustan automatiseeritud andmetöötlust...")

    # A. PÄRIMINE (Extract)
    try:
        df_sales = fetch_all_sales()
        
        res_cust = supabase.table('customers').select("*").execute()
        df_customers = pd.DataFrame(res_cust.data)
    except Exception as e:
        print(f"❌ Viga andmete pärimisel: {e}")
        return

    if df_sales.empty:
        print("⚠️ Müügiandmeid ei leitud!")
        return

    print(f"✓ Kokku laaditi {len(df_sales)} müügireas.")

    # B. TÖÖTLEMINE JA LIIDAMINE (Transform)
    # Liidame kliendid ja müügid
    df_merged = pd.merge(df_sales, df_customers, on='customer_id', how='left')
    
    # Puhastamine (nagu 7. nädalal)
    df_clean = df_merged.drop_duplicates().dropna(subset=['customer_id', 'sale_date', 'total_price']).copy()
    df_clean['sale_date'] = pd.to_datetime(df_clean['sale_date'])
    df_clean = df_clean[df_clean['total_price'] > 0]

    # Nädalane koond (aggregeerimine)
    df_temp = df_clean.set_index('sale_date')
    weekly_agg = df_temp.resample('W').agg({
        'total_price': 'sum',
        'invoice_id': 'nunique'
    }).rename(columns={'total_price': 'revenue', 'invoice_id': 'orders_count'}).reset_index()

    # KPI-d
    total_revenue = round(df_clean['total_price'].sum(), 2)
    unique_cust = df_clean['customer_id'].nunique()
    avg_order = round(df_clean['total_price'].mean(), 2)

    print(f"\n📊 --- KPI KOKKUVÕTE ---")
    print(f"Kogutulu: {total_revenue:,.2f} €")
    print(f"Unikaalseid kliente: {unique_cust}")
    print(f"Keskmine tellimus: {avg_order:,.2f} €\n")

    # C. VISUALISEERIMINE JA SALVESTAMINE (Load / Export)
    output_dir = "output"
    os.makedirs(output_dir, exist_ok=True)
    date_str = datetime.now().strftime('%Y%m%d')

    # Salvestame CSV
    csv_path = os.path.join(output_dir, f"results_{date_str}.csv")
    df_clean.to_csv(csv_path, index=False)
    print(f"✓ CSV salvestatud: {csv_path}")

    # Loome graafiku ja salvestame HTML-ina
    fig = px.line(
        weekly_agg, 
        x='sale_date', 
        y='revenue',
        title='Nädalane tulu liikumine',
        labels={'sale_date': 'Kuupäev (Nädal)', 'revenue': 'Tulu (€)'}
    )
    html_path = os.path.join(output_dir, f"weekly_revenue_{date_str}.html")
    fig.write_html(html_path)
    print(f"✓ Graafik salvestatud: {html_path}")
    
    print("🎉 Automatiseerimine edukalt lõpetatud!")

if __name__ == "__main__":
    run_automation_pipeline()
import os
import pandas as pd
from dotenv import load_dotenv
from supabase import create_client

# 1. Laeme keskkonnamuutujad .env failist
load_dotenv()

url = os.getenv("SUPABASE_URL")
key = os.getenv("SUPABASE_KEY")

# 2. Loome Supabase kliendi (PEAB OLEMA ENNE PÄRINGUT)
supabase = create_client(url, key)

# 3. Teeme päringu
response = supabase.table('sales').select('*').execute()
df = pd.DataFrame(response.data)
print(f"Laaditud {len(df)} tellimust")
print(df.head())

#1B - Too andmed teise linna (Tartu VÕI Pärnu) kohta ja arvuta: tellimuste arv, kogukäive, keskmine tellimus.
# 1. Päring Supabase'i
response = supabase.table('sales') \
    .select('*') \
    .eq('store_location', 'Tartu') \
    .order('total_price', desc=True) \
    .execute()

df_tartu = pd.DataFrame(response.data)

# 2. Arvutused ja tulemused
print(f"--- HARJUTUS 1B TULEMUSED (TARTU) ---")
print(f"Tellimuste arv: {len(df_tartu)}")
print(f"Kogukäive: {df_tartu['total_price'].sum():.2f} EUR")
print(f"Keskmine tellimus: {df_tartu['total_price'].mean():.2f} EUR")

#1C - Tiina Pärn ostuajaloo leidmine

# 1. Otsime kliendi ID nime järgi 
cust_response = supabase.table('customers') \
    .select('customer_id, first_name, last_name, email') \
    .ilike('first_name', 'Tiina') \
    .ilike('last_name', 'Pärn') \
    .execute()

if cust_response.data:
    customer = cust_response.data[0]
    c_id = customer['customer_id']
    print(f"Leiti klient: {customer['first_name']} {customer['last_name']} (ID: {c_id}, E-mail: {customer['email']})\n")

    # 2. Päring tema ostuajaloo kohta sales tabelist
    sales_response = supabase.table('sales') \
        .select('*') \
        .eq('customer_id', c_id) \
        .order('sale_date', desc=True) \
        .execute()

    df_tiina = pd.DataFrame(sales_response.data)

    # 3. Kuvame ostuajaloo
    if not df_tiina.empty:
        print(f"--- TIINA PÄRNA OSTUAJALUGU ---")
        print(f"Ostude arv: {len(df_tiina)}")
        print(f"Kogukäive: {df_tiina['total_price'].sum():.2f} EUR")
        print(f"Keskmine ost: {df_tiina['total_price'].mean():.2f} EUR\n")
        print(df_tiina[['sale_id', 'sale_date', 'total_price', 'store_location', 'payment_method']])
    else:
        print("Tiina Pärnal ei ole veel ühtegi registreeritud ostu.")
else:
    print("Klienti nimega 'Tiina Pärn' ei leitud andmebaasist.")



 #2A - kood, mis sisaldab parameetritega raportifunktsiooni.
from datetime import datetime

def weekly_sales_report(df, report_date=None):
    """Genereeri iganädalane müügiraport.

    Args:
        df: DataFrame müügitellimustega
        report_date: Raporti kuupäev (vaikimisi täna)
    Returns:
        dict: Raporti kokkuvõte
    """
    if report_date is None:
        report_date = datetime.now().strftime('%Y-%m-%d')
    return {
        'report_date': report_date,
        'total_orders': len(df),
        'total_revenue': round(df['total_price'].sum(), 2),
        'avg_order': round(df['total_price'].mean(), 2),
    }

# Käivitame funktsiooni olemasoleva DataFrame'iga (df)
result = weekly_sales_report(df)

# Kuvame tulemused
for key, value in result.items():
    print(f"  {key}: {value}")

#2B Automatiserri RFM arvutamine
import pandas as pd

def calculate_rfm(df, reference_date=None):
    """Arvuta RFM skoorid ja segmendid.

    Args:
        df: DataFrame tellimustega (veerud: customer_id, sale_date, total_price)
        reference_date: Viitekuupäev Recency arvutamiseks

    Returns:
        DataFrame: RFM skoorid ja segmendid iga kliendi kohta
    """
    if reference_date is None:
        reference_date = pd.to_datetime('today')
    else:
        reference_date = pd.to_datetime(reference_date)

    df['sale_date'] = pd.to_datetime(df['sale_date'])

    # Recency: päevi viimasest ostust
    recency = df.groupby('customer_id')['sale_date'].max().reset_index()
    recency.columns = ['customer_id', 'last_purchase']
    recency['recency_days'] = (reference_date - recency['last_purchase']).dt.days

    # Frequency: ostude arv
    frequency = df.groupby('customer_id').size().reset_index(name='frequency')

    # Monetary: kogukulutus (Täidetud lünk: 'total_price')
    monetary = df.groupby('customer_id')['total_price'].sum().reset_index()
    monetary.columns = ['customer_id', 'monetary']

    # Liida kokku
    rfm = recency[['customer_id', 'recency_days']].merge(
        frequency, on='customer_id'
    ).merge(
        monetary, on='customer_id'
    )

    # Skooride määramine
    rfm['R_score'] = pd.qcut(rfm['recency_days'], q=3, labels=[3, 2, 1]).astype(int)
    rfm['F_score'] = pd.qcut(
        rfm['frequency'].rank(method='first'), q=3, labels=[1, 2, 3]
    ).astype(int)
    rfm['M_score'] = pd.qcut(rfm['monetary'], q=3, labels=[1, 2, 3]).astype(int)
    rfm['RFM_score'] = rfm['R_score'] + rfm['F_score'] + rfm['M_score']

    # Segmenteerimine (Täidetud lüngad)
    def assign_segment(score):
        if score >= 8:
            return 'VIP Champions'
        elif score >= 6:
            return 'Loyal Customers'
        elif score >= 4:
            return 'Potential Loyalists'
        else:
            return 'At Risk'

    rfm['segment'] = rfm['RFM_score'].apply(assign_segment)
    return rfm

# Testime funktsiooni olemasoleva DataFrame'iga (df)
rfm_result = calculate_rfm(df, reference_date='2024-08-01')

print("--- RFM TULEMUSED (TOP 5) ---")
print(rfm_result.sort_values('RFM_score', ascending=False).head())

print(f"\n--- SEGMENTIDE JAOTUS ---")
print(rfm_result['segment'].value_counts())

# 2C: Riskikate klientide hoiatusfunktsioon
import pandas as pd

def churn_risk_alert(df, days_threshold=60, reference_date=None):
    """Tuvastab kliendid, kes pole määratud päevade jooksul ühtegi ostu teinud.

    Args:
        df (pd.DataFrame): Müügiandmete DataFrame (peab sisaldama 'customer_id' ja 'sale_date').
        days_threshold (int): Päevade arv, millest kauem inaktiivne olnud klient loetakse riskikaks. Vaikimisi 60.
        reference_date (str/datetime, optional): Viitekuupäev inaktiivsuse arvutamiseks. Vaikimisi täna.

    Returns:
        pd.DataFrame: Riskikate klientide nimekiri koos nende viimase ostu kuupäeva ja inaktiivsuse päevadega.
    """
    df = df.copy()
    df['sale_date'] = pd.to_datetime(df['sale_date'])

    if reference_date is None:
        reference_date = pd.to_datetime('today')
    else:
        reference_date = pd.to_datetime(reference_date)

    # Arvutame iga kliendi viimase ostu
    last_purchases = df.groupby('customer_id')['sale_date'].max().reset_index()
    last_purchases.columns = ['customer_id', 'last_purchase_date']

    # Arvutame inaktiivsuse päevad
    last_purchases['days_inactive'] = (reference_date - last_purchases['last_purchase_date']).dt.days

    # Filtreerime välja kliendid, kelle inaktiivsus ületab künnise
    risk_clients = last_purchases[last_purchases['days_inactive'] >= days_threshold]
    
    return risk_clients.sort_values('days_inactive', ascending=False).reset_index(drop=True)


# ==========================================
# TESTIMINE 2 ERINEVA SISENDIGA
# ==========================================

# Test 1: Vaikimisi piirmääraga (60 päeva)
risk_60 = churn_risk_alert(df, days_threshold=60, reference_date='2024-08-01')
print(f"--- TEST 1 (Hoiatus: >60 päeva ostuta) ---")
print(f"Riskis kliente: {len(risk_60)}")
print(risk_60.head(3))

print("\n" + "="*40 + "\n")

# Test 2: Rangema piirmääraga (30 päeva)
risk_30 = churn_risk_alert(df, days_threshold=30, reference_date='2024-08-01')
print(f"--- TEST 2 (Hoiatus: >30 päeva ostuta) ---")
print(f"Riskis kliente: {len(risk_30)}")
print(risk_30.head(3))

# 3A - ehita mini-pipeline
import pandas as pd
import plotly.express as px
from datetime import datetime

# === EXTRACT ===
def extract_orders():
    """Simuleeri andmete toomist API-st."""
    print("[EXTRACT] Laadin...")
    data = {'customer_id': [1001,1002,1003,1001,1002,1004,1003,1001,1005,1004,
                            1002,1003,1005,1001,1006,1004,1002,1007,1003,1005],
            'sale_date': pd.date_range('2024-01-15', periods=20, freq='10D'),
            'total_price': [89.99,45.50,120.00,67.30,55.00,210.00,33.50,145.00,
                            78.00,92.00,160.00,44.00,88.50,230.00,37.00,175.00,
                            110.00,65.00,95.00,125.00],
            'store_location': ['Tallinn','Tartu','Tallinn','Tallinn','Tartu','Parnu','Tallinn',
                     'Tallinn','Tartu','Parnu','Tartu','Tallinn','Tartu','Tallinn',
                     'Parnu','Parnu','Tartu','Tallinn','Tallinn','Tartu']}
    df = pd.DataFrame(data)
    print(f"[EXTRACT] {len(df)} tellimust laaditud")
    return df

# === TRANSFORM ===
def transform_monthly(df):
    """Arvuta kuuraport."""
    print("[TRANSFORM] Arvutan...")
    monthly = df.groupby(df['sale_date'].dt.to_period('M')).agg(
        tellimusi=('sale_date', 'count'), kaive=('total_price', 'sum')
    ).reset_index()
    monthly['sale_date'] = monthly['sale_date'].astype(str)
    monthly['kaive'] = monthly['kaive'].round(2)
    print(f"[TRANSFORM] {len(monthly)} kuud")
    return monthly

# === LOAD ===
def load_report(monthly):
    """Salvesta CSV ja graafik."""
    monthly.to_csv('kuukayve_raport.csv', index=False)
    px.bar(monthly, x='sale_date', y='kaive',
           title='UrbanStyle kuukäive',
           labels={'sale_date': 'Kuu', 'kaive': 'Käive (EUR)'}
    ).write_html('kuukayve_graafik.html')
    print("[LOAD] CSV + HTML salvestatud")

# === RUN ===
print("PIPELINE START")
df = extract_orders()
monthly = transform_monthly(df)
load_report(monthly)
print("PIPELINE COMPLETE")
print(monthly.to_string(index=False))


#3B - lisa pipeline'ile RFM
import pandas as pd
import plotly.express as px
from datetime import datetime

# === EXTRACT ===
def extract_orders():
    print("[EXTRACT] Laadin...")
    data = {'customer_id': [1001,1002,1003,1001,1002,1004,1003,1001,1005,1004,
                            1002,1003,1005,1001,1006,1004,1002,1007,1003,1005],
            'sale_date': pd.date_range('2024-01-15', periods=20, freq='10D'),
            'total_price': [89.99,45.50,120.00,67.30,55.00,210.00,33.50,145.00,
                            78.00,92.00,160.00,44.00,88.50,230.00,37.00,175.00,
                            110.00,65.00,95.00,125.00],
            'store_location': ['Tallinn','Tartu','Tallinn','Tallinn','Tartu','Parnu','Tallinn',
                               'Tallinn','Tartu','Parnu','Tartu','Tallinn','Tartu','Tallinn',
                               'Parnu','Parnu','Tartu','Tallinn','Tallinn','Tartu']}
    return pd.DataFrame(data)

# === TRANSFORM (RFM) ===
def transform_rfm(df, reference_date='2024-08-01'):
    """Arvuta RFM segmendid."""
    print("[TRANSFORM-RFM] Arvutan...")
    ref = pd.to_datetime(reference_date)
    rfm = df.groupby('customer_id').agg(
        last_purchase=('sale_date', 'max'),
        frequency=('sale_date', 'count'),
        monetary=('total_price', 'sum')  # TÄIDETUD LÜNK
    ).reset_index()
    
    rfm['recency_days'] = (ref - rfm['last_purchase']).dt.days
    rfm['segment'] = rfm.apply(
        lambda row: 'VIP' if row['monetary'] > 200 and row['frequency'] >= 3
                    else 'Loyal' if row['frequency'] >= 3
                    else 'At Risk' if row['recency_days'] > 120
                    else 'Regular', axis=1)
    return rfm

# === LOAD (RFM) ===
def load_rfm(rfm):
    """Salvesta RFM CSV ja Plotly scatter-graafik."""
    rfm.to_csv('rfm_raport.csv', index=False)
    
    fig = px.scatter(rfm, x='recency_days', y='monetary', color='segment',
                     size='frequency', hover_data=['customer_id'],
                     title='RFM Segmendid',
                     labels={'recency_days': 'Päevi viimasest ostust', 'monetary': 'Kogukäive (EUR)'})
    fig.write_html('rfm_graafik.html')
    print("[LOAD-RFM] CSV + HTML salvestatud")

# === RUN ===
df = extract_orders()
rfm = transform_rfm(df)
load_rfm(rfm)

print("\n--- RFM TULEMUSED ---")
print(rfm.to_string(index=False))

#3C Linnade käiberaport

import pandas as pd
import plotly.express as px
from datetime import datetime

# ==========================================
# 1. EXTRACT
# ==========================================
def extract_data(df):
    """Võtab olemasoleva DataFrame'i."""
    print("[EXTRACT] Kasutan müügiandmeid...")
    print(f"[EXTRACT] Kokku {len(df)} rida.")
    return df

# ==========================================
# 2. VALIDEERIMINE
# ==========================================
def validate_data(df):
    """Kontrolli andmete kvaliteeti."""
    print("[VALIDEERIMINE] Kontrollin andmeid...")
    
    assert len(df) > 0, "Viga: Müügiandmed on tühjad!"
    assert df['total_price'].isnull().sum() == 0, "Viga: Mõnel real puudub hind!"
    assert (df['total_price'] >= 0).all(), "Viga: Leiti negatiivne hind!"
    
    print("[VALIDEERIMINE] Kõik kontrollid läbitud!")
    return True

# ==========================================
# 3. TRANSFORM
# ==========================================
def transform_city_performance(df):
    """Arvuta linnade kaupa käive ja tehingute arv."""
    print("[TRANSFORM] Arvutan linnade näitajaid...")
    
    city_summary = df.groupby('store_location').agg(
        tehingute_arv=('total_price', 'count'),
        kogukaive=('total_price', 'sum'),
        keskmine_ost=('total_price', 'mean')
    ).reset_index()
    
    # Ümardame rahalised väärtused
    city_summary['kogukaive'] = city_summary['kogukaive'].round(2)
    city_summary['keskmine_ost'] = city_summary['keskmine_ost'].round(2)
    
    return city_summary.sort_values('kogukaive', ascending=False)

# ==========================================
# 4. LOAD
# ==========================================
def load_outputs(city_summary):
    """Salvesta linnade CSV ja HTML graafik."""
    csv_file = 'linnade_raport.csv'
    city_summary.to_csv(csv_file, index=False)
    
    fig = px.bar(
        city_summary, 
        x='store_location', 
        y='kogukaive',
        text='kogukaive',
        title='Linnade kaupluste käive',
        labels={'store_location': 'Linn', 'kogukaive': 'Käive (EUR)'}
    )
    html_file = 'linnade_graafik.html'
    fig.write_html(html_file)
    
    print(f"[LOAD] Salvestatud CSV: {csv_file}")
    print(f"[LOAD] Salvestatud HTML graafik: {html_file}")
# ==========================================
# 5. EXECUTION (Käivitamine)
# ==========================================
print("=== PIPELINE KÄIVITUS ===")

# Kasutame Harjutus 3A df-i või Supabase df-i:
df_raw = df 

if validate_data(df_raw):
    df_transformed = transform_city_performance(df_raw)
    load_outputs(df_transformed)
    
    print("\n--- RAPORTI KOKKUVÕTE ---")
    print(df_transformed.to_string(index=False))

print("=== PIPELINE VALMIS ===")

#Integreeriv harjutus
import pandas as pd
import plotly.express as px
from datetime import datetime

# ============================================================
# MARKO IGANÄDALANE RFM PIPELINE
# ============================================================

# --- EXTRACT ---
def extract():
    """Too andmed (asenda Supabase API-ga, kui ühendus olemas)."""
    print("[EXTRACT] Alustan...")
    orders = pd.DataFrame({
        'customer_id': [1001,1002,1003,1001,1002,1004,1003,1001,1005,1004,
                        1002,1003,1005,1001,1006,1004,1002,1007,1003,1005],
        'sale_date': pd.date_range('2024-01-15', periods=20, freq='10D'),
        'total_price': [89.99,45.50,120.00,67.30,55.00,210.00,33.50,145.00,
                        78.00,92.00,160.00,44.00,88.50,230.00,37.00,175.00,
                        110.00,65.00,95.00,125.00],
        'store_location': ['Tallinn','Tartu','Tallinn','Tallinn','Tartu','Parnu',
                           'Tallinn','Tallinn','Tartu','Parnu','Tartu','Tallinn',
                           'Tartu','Tallinn','Parnu','Parnu','Tartu','Tallinn',
                           'Tallinn','Tartu']
    })
    customers = pd.DataFrame({
        'customer_id': [1001,1002,1003,1004,1005,1006,1007],
        'first_name': ['Juri','Kati','Maris','Peeter','Liina','Andres','Tiina'],
        'last_name': ['Tamm','Kask','Sepp','Rebane','Ots','Puu','Kuusk']
    })
    print(f"[EXTRACT] {len(orders)} tellimust, {len(customers)} klienti")
    return orders, customers

# --- TRANSFORM ---
def transform(orders, customers, reference_date='2024-08-01'):
    """Puhasta, arvuta RFM, loo kuuraport."""
    print("[TRANSFORM] Alustan...")
    ref = pd.to_datetime(reference_date)
    df = pd.merge(orders, customers, on='customer_id', how='left')

    # Kuuraport
    monthly = df.groupby(df['sale_date'].dt.to_period('M')).agg(
        tellimusi=('sale_date', 'count'), kaive=('total_price', 'sum')
    ).reset_index()
    monthly['sale_date'] = monthly['sale_date'].astype(str)

    # RFM
    rfm = df.groupby('customer_id').agg(
        last_purchase=('sale_date', 'max'), frequency=('sale_date', 'count'),
        monetary=('total_price', 'sum'), nimi=('first_name', 'first')
    ).reset_index()
    rfm['recency_days'] = (ref - rfm['last_purchase']).dt.days
    rfm['segment'] = rfm.apply(
        lambda r: 'VIP' if r['monetary'] > 300 and r['frequency'] >= 3
                  else 'Loyal' if r['frequency'] >= 3
                  else 'At Risk' if r['recency_days'] > 120
                  else 'Regular', axis=1)

    print(f"[TRANSFORM] {len(rfm)} klienti segmenteeritud")
    return {'monthly': monthly, 'rfm': rfm}

# --- VALIDATE ---
def validate(results):
    """Kontrolli andmete kvaliteeti."""
    ok = len(results['rfm']) > 0 and results['monthly']['kaive'].sum() > 0
    print(f"[VALIDATE] {'OK' if ok else 'PROBLEEM!'}")
    return ok

# --- LOAD ---
def load(results):
    """Salvesta CSV ja graafikud selgete nimedega."""
    results['rfm'].to_csv('rfm_raport.csv', index=False)
    
    px.scatter(
        results['rfm'], x='recency_days', y='monetary', color='segment',
        size='frequency', hover_data=['nimi'],
        title='UrbanStyle RFM Segmendid',
        labels={'recency_days': 'Paevi viimasest ostust', 'monetary': 'Kogukulutus (EUR)'}
    ).write_html('rfm_graafik.html')
    
    px.bar(
        results['monthly'], x='sale_date', y='kaive',
        title='UrbanStyle Kuukäive', 
        labels={'sale_date': 'Kuu', 'kaive': 'EUR'}
    ).write_html('kuukayve_graafik.html')
    
    print("[LOAD] 1 CSV + 2 HTML salvestatud")

# --- RUN ---
print("=" * 50)
print("  MARKO IGANADALANE RFM PIPELINE")
print("=" * 50)
start = datetime.now()
orders, customers = extract()
results = transform(orders, customers)
if validate(results):
    load(results)
print(f"  VALMIS ({(datetime.now() - start).total_seconds():.1f}s)")
print("=" * 50)

# Kokkuvõte
print("\n--- SEGMENDID ---")
print(results['rfm'][['nimi', 'frequency', 'monetary', 'segment']]
      .sort_values('monetary', ascending=False).to_string(index=False))
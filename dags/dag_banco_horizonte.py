import sys
from pathlib import Path
from datetime import datetime
from airflow import DAG
from airflow.operators.python import PythonOperator

PROYECTO_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(PROYECTO_DIR))


def ejecutar_pipeline():
    from pipeline import main

    main()


with DAG(
    dag_id="etl_banco_horizonte",
    start_date=datetime(2026, 1, 1),
    schedule="0 2 * * *",
    catchup=False,
) as dag:

    ejecutar_etl = PythonOperator(
        task_id="ejecutar_pipeline_banco",
        python_callable=ejecutar_pipeline,
    )

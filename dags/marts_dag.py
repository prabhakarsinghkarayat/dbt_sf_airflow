""" 
    This DAG runs hourly and only executes models 
    inside your models/staging/ directory:
"""

from datetime import datetime
from pathlib import Path

from airflow import DAG
from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig, RenderConfig
from cosmos.profiles import SnowflakeUserPasswordProfileMapping

# Internal Docker paths
DBT_PROJECT_PATH = Path("/usr/local/airflow/capstone_ecommerce_analytics")
DBT_EXECUTABLE_PATH = Path("/usr/local/airflow/dbt_venv/bin/dbt")

profile_config = ProfileConfig(
    profile_name="capstone_ecommerce_analytics",
    target_name="dev",
    profile_mapping=SnowflakeUserPasswordProfileMapping(
        conn_id="snowflake_default",
        profile_args={"schema": "DEV"},
    ),
)

marts_dag = DbtDag(
    project_config=ProjectConfig(
        dbt_project_path=DBT_PROJECT_PATH,
    ),
    profile_config=profile_config,
    execution_config=ExecutionConfig(
        dbt_executable_path=str(DBT_EXECUTABLE_PATH),
    ),
    render_config=RenderConfig(
        select=["path:models/Intermediate", "path:models/marts"],
    ),
    schedule_interval="@daily",  # Runs once a day
    start_date=datetime(2026, 1, 1),
    catchup=False,
    dag_id="dbt_marts_daily_dag",
)
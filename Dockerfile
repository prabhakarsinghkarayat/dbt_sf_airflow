FROM quay.io/astronomer/astro-runtime:12.7.0

# Create a dedicated virtual environment for dbt inside Docker
RUN python -m venv /usr/local/airflow/dbt_venv && \
    /usr/local/airflow/dbt_venv/bin/pip install --no-cache-dir dbt-snowflake
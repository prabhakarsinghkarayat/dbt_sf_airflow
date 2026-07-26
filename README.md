# 🚀 dbt + Snowflake Orchestration with Airflow & Astronomer Cosmos

An enterprise-grade data engineering project orchestrating a **dbt (Data Build Tool)** analytics pipeline on **Snowflake** using **Apache Airflow** and **Astronomer Cosmos**, containerized with Docker via the **Astro CLI**.

---

## 🏗️ Project Architecture & Directory Structure

```text
DBT_SF_AIRFLOW/                             <-- Main workspace root
├── capstone_ecommerce_analytics/           <-- Core dbt project
│   ├── models/                             <-- staging, intermediate, and marts
│   ├── macros/
│   ├── tests/
│   ├── dbt_project.yml                     <-- dbt project configuration
│   └── profiles.yml
├── dags/                                   <-- Airflow DAG definitions
│   ├── staging_dag.py                      <-- Hourly Micro-DAG (Staging layer)
│   ├── marts_dag.py                        <-- Daily Micro-DAG (Marts layer)
│   └── dbt_cosmos_ecommerce_dag.py         <-- Full pipeline DAG
├── Dockerfile                              <-- Custom Astro runtime image with dbt_venv
├── requirements.txt                        <-- Python dependencies for Docker
└── README.md                               <-- Project documentation
```

---

## ✨ Features & Highlights

* **Dynamic Graph Rendering:** Powered by [Astronomer Cosmos](https://github.com/astronomer/astronomer-cosmos), dynamically translating dbt `ref()` dependencies directly into Airflow task DAGs without manual task mapping.
* **Micro-DAG Decoupling Strategy:** Separates raw data staging ingestion (`@hourly`) from heavy analytics marts aggregation (`@daily`) to balance data freshness, lower Snowflake compute credit usage, and ensure failure isolation.
* **Isolated Virtual Environment (`dbt_venv`):** Uses a dedicated virtual environment inside Docker for `dbt-snowflake` execution to avoid library dependency conflicts with core Airflow runtime modules.

---

## 🛠️ Prerequisites & Local Requirements

* **Docker Desktop:** Ensure Docker Desktop is installed and active on your machine.
* **Astro CLI:** Installed on macOS using the official script:
  ```bash
  curl -sSL https://install.astronomer.io | sudo bash -s
  ```

---

## ⚙️ Environment Configuration

### 1. `requirements.txt`
Located at the workspace root:
```text
astronomer-cosmos
apache-airflow-providers-snowflake
dbt-snowflake
```

### 2. `Dockerfile`
Located at the workspace root:
```dockerfile
FROM quay.io/astronomer/astro-runtime:12.7.0

# Create a dedicated virtual environment for dbt execution inside Docker
RUN python -m venv /usr/local/airflow/dbt_venv && \
    /usr/local/airflow/dbt_venv/bin/pip install --no-cache-dir dbt-snowflake
```

---

## 🚀 Step-by-Step Setup & Execution

### Step 1: Clone the Repository
```bash
git clone https://github.com/YOUR_GITHUB_USERNAME/dbt_sf_airflow.git
cd dbt_sf_airflow
```

### Step 2: Start Airflow Containers
Make sure Docker Desktop is running, then execute:
```bash
astro dev start
```
*(Note: Use `astro dev restart` if you modify `requirements.txt` or `Dockerfile` in the future).*

### Step 3: Configure Snowflake Connection in Airflow
1. Open **`http://localhost:8081`** in your browser.
2. Log in with default credentials: **`admin` / `admin`**.
3. Navigate to **Admin > Connections** and click the blue **`+`** button.
4. Set up the connection:

| Parameter | Value |
| :--- | :--- |
| **Connection Id** | `snowflake_default` |
| **Connection Type** | `Snowflake` |
| **Account** | `<your_snowflake_account_identifier>` |
| **Login** | `<your_snowflake_username>` |
| **Password** | `<your_snowflake_password>` |
| **Database** | `CAPSTONE_ECOMMERCE_DB` |
| **Schema** | `DEV` |
| **Warehouse** | `COMPUTE_WH` |
| **Role** | `ACCOUNTADMIN` |

5. Click **Save**.

---

## 📊 Airflow DAG Workflow Overview

| DAG File | Schedule | Models Included | Purpose |
| :--- | :--- | :--- | :--- |
| **`staging_dag.py`** | `@hourly` | `path:models/staging` | Ingests and cleans raw transactional data frequently with low compute impact. |
| **`marts_dag.py`** | `@daily` | `path:models/Intermediate`, `path:models/marts` | Performs heavy aggregations and business logic for reporting overnight. |
| **`dbt_cosmos_ecommerce_dag.py`** | `@daily` | All models | Complete end-to-end dbt project execution. |

---

## 🔒 Security & Branch Protection

Direct pushes to the `main` branch are restricted to maintain code quality and prevent unintended production changes.

### Contribution Workflow:
1. Create a feature branch locally:
   ```bash
   git checkout -b feature/your-feature-name
   ```
2. Commit and push your changes to GitHub:
   ```bash
   git add .
   git commit -m "Add new staging model"
   git push origin feature/your-feature-name
   ```
3. Open a **Pull Request (PR)** against `main` on GitHub for review and approval.
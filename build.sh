#!/usr/bin/env bash

set -e
set -x

python3.9 -m venv env
source env/bin/activate
[ -z "$APP_HOME" ] && export APP_HOME=$(pwd)
[ -z "$AIRFLOW_HOME" ] && export AIRFLOW_HOME="${APP_HOME}/home"
[ -z "$AIRFLOW_DAGS" ] && export AIRFLOW_DAGS="${APP_HOME}/dags"
[ -z "$AIRFLOW_PLUGINS" ] && export AIRFLOW_PLUGINS="${APP_HOME}/plugins"
[ -z "$AIRFLOW_VERSION" ] && export AIRFLOW_VERSION="2.7.2"
[ -z "$AIRFLOW_EXECUTOR" ] && export AIRFLOW_EXECUTOR="SequentialExecutor"
[ -z "$POSTGRESQL_ADDON_URI" ] && export POSTGRESQL_ADDON_URI="sqlite:///${AIRFLOW_HOME}/airflow.db"
[ -z "$SQL_ALCHEMY_POOL_SIZE" ] && export SQL_ALCHEMY_POOL_SIZE=2
[ -z "$BROKER_URL" ] && export BROKER_URL="redis://redis:6379/0"
[ -z "$REMOTE_BASE_LOG_FOLDER" ] && export REMOTE_BASE_LOG_FOLDER="s3://airflow-logs?endpoint_url=https://cellar-c2.services.clever-cloud.com"
[ -z "$REMOTE_LOG_CONN_ID" ] && export REMOTE_LOG_CONN_ID="s3_logs_conn"

PYTHON_VERSION="$(python --version | cut -d " " -f 2 | cut -d "." -f 1-2)"
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"
pip install "apache-airflow[postgres,celery,elasticsearch,redis,amazon]==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

#!/usr/bin/env bash


set -e
set -x

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
[ -z "$FERNET_KEY" ] && export FERNET_KEY=""

mkdir -p ${AIRFLOW_HOME}
envsubst < config/airflow.cfg > ${AIRFLOW_HOME}/airflow.cfg
airflow "${@:1}"

#!/usr/bin/env bash


set -e
set -x

source env.sh

airflow standalone

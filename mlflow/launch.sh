#!/bin/sh
# launch.sh

set -e

postgres_host="$1"
sftp_host="$2"
shift
shift
cmd="$@"

until PGPASSWORD=$POSTGRES_PASSWORD psql -h "$postgres_host" -U "postgres" -c '\q'; do
  >&2 echo "Postgres $postgres_host is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres $postgres_host is up - executing command"

>&2 echo "Adding hostkey to ssh known_hosts"
ssh-keyscan -H "$sftp_host" >> /etc/ssh/ssh_known_hosts
ssh-keyscan "$sftp_host" >> ~/.ssh/known_hosts

>&2 echo "Launching mlflow tracking server"
exec $cmd


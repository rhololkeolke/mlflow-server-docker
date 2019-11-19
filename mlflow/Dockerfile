FROM python:3.7-alpine

EXPOSE 5000

ENV POSTGRES_USERNAME=postgres
ENV POSTGRES_HOSTNAME=postgres
ENV MLFLOW_DEFAULT_ARTIFACT_ROOT=/var/mlflow/artifacts

RUN apk add --no-cache alpine-sdk postgresql-dev

RUN pip install mlflow==1.4.0 psycopg2-binary

RUN apk add --no-cache postgresql-client

ADD wait-for-postgres.sh wait-for-postgres.sh

CMD ./wait-for-postgres.sh postgres mlflow server --backend-store-uri postgresql://${POSTGRES_USERNAME}:${POSTGRES_PASSWORD}@${POSTGRES_HOSTNAME}:5432 --default-artifact-root ${MLFLOW_DEFAULT_ARTIFACT_ROOT} --host 0.0.0.0

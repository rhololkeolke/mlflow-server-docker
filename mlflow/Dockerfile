FROM python:3.7-alpine

EXPOSE 5000

ENV POSTGRES_USERNAME=postgres
ENV POSTGRES_HOSTNAME=postgres
ENV MLFLOW_DEFAULT_ARTIFACT_ROOT=/var/mlflow/artifacts

# python c deps
RUN apk add --no-cache alpine-sdk \
	postgresql-dev \
	postgresql-client \
	openssh \
	openssl-dev \
	libffi-dev

# mlflow python packages
RUN pip install mlflow==1.4.0 psycopg2-binary pysftp

# SSH setup
RUN mkdir -p $HOME/.ssh
COPY ssh/id_rsa.pub ssh/id_rsa ssh/config /root/.ssh/
RUN chmod 700 /root/.ssh && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 644 /root/.ssh/id_rsa.pub

# script that starts up container processes
COPY launch.sh launch.sh

CMD ./launch.sh postgres sftp mlflow server --backend-store-uri postgresql://${POSTGRES_USERNAME}:${POSTGRES_PASSWORD}@${POSTGRES_HOSTNAME}:5432 --default-artifact-root ${MLFLOW_DEFAULT_ARTIFACT_ROOT} --host 0.0.0.0

# mlflow-server-docker
docker container and compose file for running mlflow tracking server

Launch via:

``` shell
sudo env SFTP_PASS=(pass ls mlflow/sftp) POSTGRES_PASSWORD=(pass ls mlflow/postgresql) MLFLOW_DIR=/var/mlflow docker-compose up
```

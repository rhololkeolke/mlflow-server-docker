# mlflow-server-docker
docker container and compose file for running mlflow tracking server

## Key Generation

Both the mlflow container and the users of the server need to have
keyfiles. For the server generate the key via:

``` shell
ssh-keygen -t rsa -f $PWD/mlflow/ssh/id_rsa
```

This key cannot have a password or the server will not be able to use
the key. Then copy the public key to the pub key folder:

``` shell
cp $PWD/mlflow/ssh/id_rsa.pub pub_keys/
```

You will also need to generate keypairs for the users. Unfortunately
the way pysftp is used by mlflow, it appears that you either need to
specify a password in the URL (insecure) or have an identity file. And
you cannot specify a smartcard publickey as the identity file.

Generate the key via the standard keygen command:

``` shell
ssh-keygen -t rsa -f ~/.ssh/mlflow
```

Copy the public key to the pub_keys folder so that you will be
authorized to access the server.

## SSH Config

You will need to create an ssh config entry for the SFTP hostname you
wish to use. For example, using hostname `mlflow`, and port 2222. You
will add the following ssh config entry:

``` text
Host mlflow
     Hostname <server ip or hostname>
	 Port 2222
	 User mlflow
	 IdentityFile ~/.ssh/mlflow
```

## HTTPS

The server assumes a letsencrypt ssl cert. Generate the cert using
certbot on the command line (see the letsencrypt docs).

You will need to modify the nginx conf to match your hostname. This
will setup a server with http on the standard mlflow port 5000 which
has a 301 redirect to the https proxied version on port 5001. If you
have already been runnning mlflow manually on port 5000 you may need
to force a hard refresh in the browser so that the cached homepage is
not used. (Generally done by shift-clicking on the browser refresh
button or clearing cache in the settings.)

## Launching

You must provide the following environment variables when launching:

- SFTP_PASS: Password for the mlflow user in the sftp container
- POSTGRES_PASSWORD: Password for the postgres database user
- MLFLOW_DIR: Host location where database and artifacts should be
  stored.
- SFTP_HOST: Hostname of the artifacts backend. This is the host you
  used in the ssh config.

You can also optionally provide different host keys for the sftp
container. By default the system ssh server keys are used. Specify the
following environment variables:

- SFTP_ED25519_KEY
- SFTP_RSA_KEY
- SFTP_ECDSA_KEY

For example to launch with fish shell using passwords stored via pass:

``` shell
sudo env SFTP_HOST=mlflow.bluetang SFTP_PASS=(pass ls mlflow/sftp) POSTGRES_PASSWORD=(pass ls mlflow/postgresql) MLFLOW_DIR=/var/mlflow docker-compose up
```

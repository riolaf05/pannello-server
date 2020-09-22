## API Server

RESTful server which exposes host functionalities

It publish metrics about cluster from HTTPS endpoint.

## TLDR
The general idea behind **HTTPS** is that when the client establishes a connection with the server and requests an encrypted connection, the server responds with its **SSL Certificate**. The certificate acts as identification for the server, as it includes the server name and domain. To ensure that the information provided by the server is correct, the certificate is cryptographically signed by a **certificate authority**, or CA. If the client knows and trusts the CA, it can confirm that the certificate signature indeed comes from this entity, and with this the client can be certain that the server it connected to is legitimate.

After the client verifies the certificate, it creates an encryption key to use for the communication with the server. To make sure that this key is sent securely to the server, it encrypts it using a public key that is included with the server certificate. The server is in possession of the private key that goes with that public key in the certificate, so it is the only party that is able to decrypt the package. From the point when the server receives the encryption key all traffic is encrypted with this key that only the client and server know.

### installation

1. Launch `install.sh` script 

1. ~~Set enviroments variables (e.g. `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID`)~~

2. ~~Copy this folder into `$HOME/Scripts/`~~

3. ~~Launch `install.sh` script~~

## References

* (HTTPS with Flask)[https://blog.miguelgrinberg.com/post/running-your-flask-application-over-https]
* (Flask basic HTTP authentication)[https://flask-httpauth.readthedocs.io/en/latest/]
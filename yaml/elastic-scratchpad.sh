sudo certbot --manual --preferred-challenges=http certonly -d honestbank.com

kubectl create secret generic my-cert --from-file=ca.crt=tls.crt --from-file=tls.crt=tls.crt --from-file=tls.key=tls.key
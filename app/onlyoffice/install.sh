echo "📦 Installing SSL..."
sudo apt install certbot python3-certbot-nginx -y

echo "🔑 Applying SSL to office.sdnpengasinan7.sch.id..."
sudo certbot --nginx -d office.sdnpengasinan7.sch.id

echo "📦 Installing OnlyOffice..."

sudo docker run -i -t -d -p 8080:80 \
  --name onlyoffice \
  -e JWT_ENABLED=true \
  -e JWT_SECRET=supersecret \
  -e JWT_HEADER=AuthorizationJwt \
  onlyoffice/documentserver
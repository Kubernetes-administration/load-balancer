#!/bin/bash -xe

apt-get update
apt-get install -y apache2 libapache2-mod-php
cat > /var/www/html/index.php <<'EOF'

<!doctype html>
<html>
    <head>
        <title>LoadBalancer</title>
    </head>
    <body>
        <p>It works!.</p>
    </body>
</html>
EOF
sudo mv /var/www/html/index.html /var/www/html/index.html.old

[[ -n "${PROXY_PATH}" ]] && mkdir -p /var/www/html/${PROXY_PATH} && cp /var/www/html/index.php /var/www/html/${PROXY_PATH}/index.php

systemctl enable apache2
systemctl restart apache2
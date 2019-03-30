#!/bin/bash

APACHE_LOG_DIR=/var/log/apache2

read -p 'Websitenizin adı:' domain

mkdir /var/www/$domain/public_html


chown www-data /var/www/$domain/public_html
chgrp www-data /var/www/$domain/public_html



read -p 'Veritabanı ismi:' database_name
read -p 'Veritabanı kullanıcı adı:' database_user
read -sp 'Veritabanı kullanıcı şifre:' database_pass

touch /etc/apache2/sites-available/$domain.conf

chown /etc/apache2/sites-available/$domain.conf
chgrp /etc/apache2/sites-available/$domain.conf

mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$database_user'@'localhost' IDENTIFIED BY '$database_pass';"


echo "UseCanonicalName On
<VirtualHost *:80>
        ServerAdmin webmaster@localhost

        ServerName $domain
        ServerAlias www.$domain

        DocumentRoot /var/www/$domain/public_html

        <Directory /var/www/$domain/public_html>
            Options FollowSymLinks
            AllowOverride All
            Require all granted
        </Directory>

        ErrorLog $APACHE_LOG_DIR/$domain/error.log
        CustomLog $APACHE_LOG_DIR/$domain/access.log combined
</VirtualHost>" > /etc/apache2/sites-available/$domain.conf

a2ensite $domain.conf

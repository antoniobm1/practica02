#!/bin/bash
# Actualizamos los repositorios.
apt-get update

#Instalamos apache
apt-get install apache2 -y

#Instalamos paquetes para apache
apt-get install php libapache2-mod-php php-mysql -y

#Instalamos adminer buscar en internet descargar el 2 y wget y copiamos la ruta
cd /var/www/html
mkdir adminer
cd adminer
wget https://github.com/vrana/adminer/releases/download/v4.7.3/adminer-4.7.3-mysql.php
mv adminer-4.7.3-mysql.php index.php

#en el terminal de la máquina de AWS cd/home/ubuntu
#nano lamp.sh y ponemos ahi el script
#sudo chmod +x lamp.sh
#sudo ./lamp.sh

#Instalamos las debconf-utils
apt-get install debconf-utils -y

#Configuramos la contraseña del root para MySQL
DB_ROOT_PASSWD=root
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_ROOT_PASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_ROOT_PASSWD"

#Instalamos MySQL
apt-get install mysql-server -y

#Instalamos git
apt-get install git -y

#Instalamos la aplicacion web
cd /var/www/html
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git
#Cambio permisos
chown www-data:www-data * -R

#Configuramos la aplicacion web
DB_NAME=lamp_db
DB_USER=lamp_user
DB_PASSWD=lamp_user
mysql -u root -p$DB_ROOT_PASSWD <<< "DROP DATABASE IF EXISTS $DB_NAME;"
mysql -u root -p$DB_ROOT_PASSWD <<< "CREATE DATABASE $DB_NAME;"
mysql -u root -p$DB_ROOT_PASSWD <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%' IDENTIFIED BY '$DB_PASSWD';"
mysql -u root -p$DB_ROOT_PASSWD <<< "FLUSH PRIVILEGES;"
# Importamos base de datos
mysql -u root -p$DB_ROOT_PASSWD < /var/www/html/iaw-practica-lamp/db/database.sql

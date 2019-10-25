# practica02

La url de la practica 2 es la siguiente : https://github.com/antoniobm1/practica02.git

Script a utilizar para instalar:

#!/bin/bash
set -x
# Actualizamos los repositorios
apt-get update

# Instalamos apache
apt-get install apache2 -y

# Instalamos paquetes para apache
apt-get install php libapache2-mod-php php-mysql -y

# Instalamos adminer
cd /var/www/html
mkdir adminer
cd adminer
wget https://github.com/vrana/adminer/releases/download/v4.3.1/adminer-4.3.1-mysql.php 
mv adminer-4.3.1-mysql.php index.php

# Instalamos git
apt-get install git -y

# Instalamos la aplicación web
cd /var/www/html
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git 
chown www-data:www-data * -R

# Configuramos la red
cd /var/www/html/iaw-practica-lamp/src
sed -i 's/localhost/100.24.39.108/' config.php

# En nuestra maquina de amazon cd /home/ubuntu/ 
# nano lamp.sh y pegamos nuestro script
# sudo chmod +x lamp.sh
# sudo ./lamp.sh


# instalamos las debconf-utils
apt-get install debconf-utils -y

#C onfiguramos la contraseña del root para Mysql
DB_ROOT_PASSWD=root
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_ROOT_PASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_ROOT_PASSWD"

# Instalamos MYSQL Server
apt-get install mysql-server -y

# Comprobamos que tiene bien la pass de Mysql con: mysql -u root -p






# Configuramos la base de datos de la aplicación web
DB_NAME=lamp_db
DB_USER=lamp_user
DB_PASSWD=lamp_user
mysql -u root -p$DB_ROOT_PASSWD <<< "DROP DATABASE IF EXISTS $DB_NAME;"
mysql -u root -p$DB_ROOT_PASSWD <<< "CREATE DATABASE $DB_NAME;"
mysql -u root -p$DB_ROOT_PASSWD <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%' IDENTIFIED BY '$DB_PASSWD';"
mysql -u root -p$DB_ROOT_PASSWD <<< "FLUSH PRIVILEGES;"

# Importamos la base de datos
mysql -u root -p$DB_ROOT_PASSWD < /var/www/html/iaw-practica-lamp/db/database.sql

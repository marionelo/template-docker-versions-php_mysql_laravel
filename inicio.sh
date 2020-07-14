#!/bin/bash

echo -e "############################################"
echo -e "#                                          #"
echo -e "#          VERSIONES DE LENGUAJES          #"
echo -e "#                                          #"
echo -e "############################################\n"

#
#   RECEPCION DE VARIABLES POR MEDIO DE AL TERMIMAL
#

# RECPCION DE VERSION DE PHP
phpVersion=7.4

if [ !$version ]; then 
    while true; do
        read -p "Desea tomar la version de PHP $phpVersion (y/n)? " yn
        case $yn in
            [Yy]* ) versionFinalPHP=$phpVersion; break;;
            [Nn]* ) read -p "Especifique la version: " versionFinalPHP; break;;
            *) echo "Por favor seleccione 'y' o 'n'";;
        esac
    done
fi

echo -e "La version para PHP es: $versionFinalPHP\n\n"


#
# RECEPCION DE VERSION DE LARAVEL
#
laravelVersion=7

if [ !$version ]; then 
    while true; do
        read -p "Desea tomar la versión de Laravel $laravelVersion (y/n)? " yn
        case $yn in
            [Yy]* ) versionFinalLaravel=$laravelVersion; break;;
            [Nn]* ) read -p "Especifique la version: " versionFinalLaravel; break;;
            *) echo "Por favor seleccione 'y' o 'n'";;
        esac
    done
fi

echo -e "La version para Laravel es: $versionFinalLaravel\n\n"


#
# RECEPCION DE VERSION DE MYSQL
#
mysqlVersion=8

if [ !$version ]; then 
    while true; do
        read -p "Desea tomar la versión de MySQL $mysqlVersion (y/n)? " yn
        case $yn in
            [Yy]* ) mysqlFinalVersion=$mysqlVersion; break;;
            [Nn]* ) read -p "Especifique la version: " mysqlFinalVersion; break;;
            *) echo "Por favor seleccione 'y' o 'n'";;
        esac
    done
fi

echo -e "La version para MySQL es: $mysqlFinalVersion\n\n"


echo -e "############################################"
echo -e "#                                          #"
echo -e "#           VARIABLES DE ENTORNO           #"
echo -e "#                                          #"
echo -e "############################################\n"

read -p "Nombre del proyecto docker: " dockerName

echo ""

while true; do
    read -p "Puerto HTTP (entre 3000 - 65000): " portHTTP

    result=$( sudo lsof -i -P -n | grep LISTEN | grep $portHTTP )

    if [ "$result" ]; then
        echo -e "El puerto \e[31m$portHTTP \e[39mesta ocupado \n"
    else 
        echo -e "\e[39mPuerto \e[32m$portHTTP \e[39masignado \n"
        break;
    fi  
done

while true; do
    read -p "Puerto SSL (default 443): " portSSL

    result=$( sudo lsof -i -P -n | grep LISTEN | grep $portSSL )

    if [ "$result" ]; then
        echo -e "El puerto \e[31m$portSSL \e[39mesta ocupado \n"
    else 
        echo -e "\e[39mPuerto \e[32m$portSSL \e[39masignado \n"
        break;
    fi  
done


while true; do
    read -p "Puerto Database (default 3306): " portDB

    result=$( sudo lsof -i -P -n | grep LISTEN | grep $portDB )

    if [ "$result" ]; then
        echo -e "El puerto \e[31m$portDB \e[39mesta ocupado \n"
    else 
        echo -e "\e[39mPuerto \e[32m$portDB \e[39masignado \n"
        break;
    fi  
done


read -p "Password DB user ROOT: " dbPassROOT
echo ""
read -p "Nombre de la base de datos: " dbName
echo ""


#Es hora de poner las varaibles en accion
sed -e "s/project_name/$dockerName/" \
-e "s/port_http/$portHTTP/" \
-e "s/port_ssl/$portSSL/" \
-e "s/port_mysql/$portDB/" \
-e "s/pass_user_root_mysql/$dbPassROOT/" \
-e "s/Database_name/$dbName/" \
".env.example" > .env


echo -e "Se ha creado al archivo .env !!!\n"

#whoami
whoami="project"

#
# creación de carpeta del proyecto
# =====     html    ======
#
DIRP="html/"
if [ -d "$DIRP" ]; then
    rm -rf $DIRP
fi
mkdir $DIRP

#
# creación de carpeta del DB
# =====     db    ======
#
DIRDB="db/"
if [ -d "$DIRDB" ]; then
    rm -rf $DIRDB
fi
mkdir $DIRDB
touch $DIRDB/.empty

#
# creación de carpeta del DB
# =====     db    ======
#
DIRDOCS="docs/"
if [ -d "$DIRDOCS" ]; then
    rm -rf $DIRDOCS
fi
mkdir $DIRDOCS
touch $DIRDOCS/.empty

#
# creación de carpeta del DB
# =====     db    ======
#
DIRSC="scripts/"
if [ -d "$DIRSC" ]; then
    rm -rf $DIRSC
fi
mkdir $DIRSC
touch $DIRSC/.empty




base_dir='.docker'

#
#   CREATE DIRECTORY TO PHP SERVICE
#
DIRPHP="$base_dir/php"
if [ -d "$DIRP" ]; then
    rm -rf $DIRPHP
fi
mkdir $DIRPHP


#
#   CREATE DIRECTORY TO MYSQL SERVICE
#
DIRPMSQL="$base_dir/mysql"
if [ -d "$DIRPMSQL" ]; then
    rm -rf $DIRPMSQL
fi
mkdir $DIRPMSQL


# Copiado de archivo docker-compose-inicio.yml
sed "s/__laravel_version__/$versionFinalLaravel/" "$base_dir/elements/docker-compose-inicio.yml" > docker-compose_pre.yml
sed "s/__mysql_version__/$mysqlFinalVersion/" docker-compose_pre.yml > docker-compose_pre_final.yml
# Compiando la version que se necesita dentro del proyecto a generar 
sed "s/__php_version__/$versionFinalPHP/" "$base_dir/elements/php_dockerfile.yml" > "$base_dir/php/Dockerfile"
# Create Dockerfile to run correct composer
sed "s/__myuser__/$whoami/" "$base_dir/elements/composer_dockerfile" > "$base_dir/composer/Dockerfile"
# modify docker-compose.yml to add home user
sed "s/__myuser__/$whoami/" docker-compose_pre_final.yml > docker-compose.yml
#Modificaciones para el archivo de fin
sed "s/__my_user__/$whoami/" fin.sh > fin1.sh
sed "s/__mysql_version__/$mysqlFinalVersion/" fin1.sh > final.sh


rm docker-compose_pre.yml
rm docker-compose_pre_final.yml
rm fin1.sh

#copia del .env para docker
cp .env.example .env


#
# En caso de existir se elimina el .git 
#
# DIR=".git"
# if [ -d "$DIR" ]; then
#     rm -rf .git
# fi


# #Se inicia proyecto git vacio
# git init
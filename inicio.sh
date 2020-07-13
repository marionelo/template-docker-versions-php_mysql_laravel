#!/bin/bash

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


#whoami
whoami="project"

#
# En caso de existir se elimina el .git 
#
DIR=".git"
if [ -d "$DIR" ]; then
    rm -rf .git
fi

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


git init
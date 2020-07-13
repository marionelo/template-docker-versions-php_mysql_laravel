#!/bin/bash

#verificamos si la carpeta de vendor existe si no se instala con composer
cd /home/project

DIR="vendor"
if [ -d "$DIR" ]; then #el directorio exists
    composer update -q 
else 
    composer install -q #directory doesn't exists
fi


#
# Verifica que el archivo .env exista si no lo crea
#
file=".env"
if [ ! -f "$file" ]; then
	cp .env.example .env 
    php artisan key:generate 
fi


chmod -R 777 storage
chmod -R 777 bootstrap
tail -f /dev/null
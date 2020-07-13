#!/bin/bash

VERSION=$1


echo "Solo se instala el proyuecto desde 0\n\n\n"
composer create-project --prefer-dist laravel/laravel "" "$VERSION"


#CAMBIO DE PERMISOS DENTRO DE LAS CARPETAS PARA PODER HACER LO QUE NECESITEMOS
chmod -R 777 ./storage
chmod -R 777 ./bootstrap
tail -f /dev/null

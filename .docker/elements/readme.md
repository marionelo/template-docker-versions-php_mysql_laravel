# Proyecto Laravel


Este proyecto esta hecho con docker, PHP (Laravel), MySQL y NGINX, a continuación se muestran las configuraciones previas:



### Copiando el .env

```
    $ cp .env.example .env
```

Para poder indicar puertos de nginx, base de datos con su password, existe un .env en el cual se puede configurar
```
    PROJECT_NAME=nombre_del_proyecto

    HTTP_PORT=puerto_para_http
    SSL_PORT=puerto_para_https

    DB_PORT_EXT=puerto_para_mysql(33061)
    DB_ROOT_PASS=password_para_user_root_mysql
    DB_NAME=name_to_our_database
```


### Ejecutando el proyecto

```
        $ docker-compose up --build -d

    Ejecutar para ver que los 3 servicios esten corriendo

        $ docker ps 
```

### Correr composer install
```
        $ docker exec -ti PROJECT_NAME_composer bash

    Una vez dentro ejecutar los siguientes comandos

        $ composer install && \
        cp .env.example .env && \
        chmod -R 777 storage && \
        chmod -R 777 bootstrap
```

### Revisando el resultado

Para poder ver el resultado final, hay que verlo en el navegador con el puerto que fue asignado dentro del .env en HTTP_PORT, por ejemplo si asignamos HTTP_PORT=8080, revisaremos con la siguiente url

```
    http://localhost:puerto_para_http
```


### Migraciones dentro de laravel

Importante para poder correr las migraciones modificar el .env que esta dentro de 
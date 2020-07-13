## Docker Laravel y PHP


Este proyecto esta hecho para poder hacer un template de PHP con laravel con las versiones que necesitemos usar con una instrucción simple

```
    $ bash inicio.sh 
```

La instrucción anterior nos creará la estructura de carpetas, archivos, nombres y versiones indicados

### Modificando .env

Para poder indicar puertos de nginx, base de datos con su password, existe un .env en el cual se puede configurar
```
    PROJECT_NAME=nombre_del_proyecto

    HTTP_PORT=puerto_para_http
    SSL_PORT=puerto_para_https

    DB_PORT_EXT=puerto_para_mysql(33061)
    DB_ROOT_PASS=password_para_user_root_mysql
    DB_NAME=name_to_our_database
```

### Corriendo nuestro docker

Una vez habiendo ejecutado el comando necesitamos ahora ejecutar propiamente docker-compose como se indica a continuación

```
    $ docker-compose up -d --build
```


### Revisando la instalcion de laravel

Para poder saber que la ejecución terminó con éxito podemos ver el docker creado de composer que instala la version solicitada, esto se hace con:

```
    $ docker logs -f nombre_del_proyecto_composer
```

Con el cual pueden ver en tiempo real la instalación que esta ocurriendo dentro del contenedor.


### Comprobando instalación

Una vez termianda la instalación nos queda poder revisar en el navegador que todo esta corriendo de manera correcta
```
    http://localhost:puerto_para_http
```

### Acomodando git

Si todo corrió correctamente, nos queda ejecutar una última instrucción para dejar nuestro repositio de git correcto y listo para github
```
    $ bash fin.sh
```
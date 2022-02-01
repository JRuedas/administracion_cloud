#!/bin/bash
set -e

logger "Arrancando instalacion y configuracion de MongoDB"

USO="Uso : install.sh [opciones]
    Opciones:
    -f fichero de configuracion
    -a muestra esta ayuda

Ejemplo:
install.sh -f fichero.ini
    Formato del fichero ini:
        user=usuario
        password=password
        port=numero de puerto (opcional)
"

function ayuda() {
    echo "${USO}"
    if [[ ${1} ]]
    then
        echo ${1}
    fi
}

if [ $# -eq 0 ];
then
    ayuda
    exit 0
fi

# Gestionar los argumentos
while getopts ":f:a" OPCION
do
    case ${OPCION} in
    f ) CONFIG=$OPTARG
        echo "Parametro CONFIG establecido con '${CONFIG}'";;
    a ) ayuda; exit 0;;
    : ) ayuda "Falta el parametro para -$OPTARG"; exit 1;; \?) ayuda "La opcion no existe : $OPTARG"; exit 1;;
    esac
done

if [ ! -f "${CONFIG}" ]
then
    ayuda "El fichero (-f) especificado no existe"
    exit 1
fi

while IFS= read -r line
do
    IFS='='
    read -a strarr <<< "$line"
    case "${strarr[0]}" in 
    *user*) 
        USUARIO=${strarr[1]}
        ;;
    *password*) 
        PASSWORD=${strarr[1]}
        ;;
    *port*) 
        PUERTO_MONGOD=${strarr[1]}
        ;;
    esac
done < "${CONFIG}"

if [ -z ${USUARIO} ]
then
    ayuda "El usuario (-u) debe ser especificado"; exit 1
fi

if [ -z ${PASSWORD} ]
then
    ayuda "La password (-p) debe ser especificada"; exit 1
fi

if [ -z ${PUERTO_MONGOD} ]
then
    PUERTO_MONGOD=27017
fi

# # Preparar el repositorio (apt-get) de mongodb añadir su clave apt
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 4B7C549A058F8B6B
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb.list

if [[ -z "$(mongo --version 2> /dev/null | grep '4.2.1')" ]]
then
    # Instalar paquetes comunes, servidor, shell, balanceador de shards y herramientas
    apt-get -y update \
    && apt-get install -y \
        mongodb-org=4.2.1 \
        mongodb-org-server=4.2.1 \
        mongodb-org-shell=4.2.1 \
        mongodb-org-mongos=4.2.1 \
        mongodb-org-tools=4.2.1 \
    && rm -rf /var/lib/apt/lists/* \
    && pkill -u mongodb || true \
    && pkill -f mongod || true \
    && rm -rf /var/lib/mongodb
fi

# # Crear las carpetas de logs y datos con sus permisos
[[ -d "/datos/bd" ]] || mkdir -p -m 755 "/datos/bd"
[[ -d "/datos/log" ]] || mkdir -p -m 755 "/datos/log"

# # Establecer el dueño y el grupo de las carpetas db y log
chown mongodb /datos/log /datos/bd
chgrp mongodb /datos/log /datos/bd

# # Crear el archivo de configuración de mongodb con el puerto solicitado
mv /etc/mongod.conf /etc/mongod.conf.orig
(
cat <<MONGOD_CONF
# /etc/mongod.conf
systemLog:
    destination: file
    path: /datos/log/mongod.log
    logAppend: true
storage:
    dbPath: /datos/bd
    engine: wiredTiger
    journal:
        enabled: true
net:
    port: ${PUERTO_MONGOD}
security:
    authorization: enabled
MONGOD_CONF
) > /etc/mongod.conf

# # Reiniciar el servicio de mongod para aplicar la nueva configuracion
systemctl restart mongod

# logger "Esperando a que mongod responda..."
COUNTER=0
while !(nc -z localhost ${PUERTO_MONGOD}) && [[ $COUNTER -lt 10 ]] ; do
    sleep 2
    let COUNTER+=2
    echo "Esperando que mongo se incialice. $COUNTER segundos esperados"
done

# # Crear usuario con la password proporcionada como parametro
mongo admin << CREACION_DE_USUARIO
db.createUser({
    user: "${USUARIO}",
    pwd: "${PASSWORD}",
    roles:[{
        role: "root",
        db: "admin"
    },{
        role: "restore",
        db: "admin"
}] })
CREACION_DE_USUARIO

logger "El usuario ${USUARIO} ha sido creado con exito!"

exit 0
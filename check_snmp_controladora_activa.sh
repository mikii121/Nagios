#!/bin/bash

# check_snmp_controladora_activa.sh
# Descripcion: carga el estado de la controladora en ese momento
# @autor: MIGUEL ANDRES CABALLERO

PROGNAME="check_snmp_controladora_activa.sh"
COMMUNITY=$1
HOST=$2
OID=$3
EXPECTED_ARGS=3

if [ $# -ne $EXPECTED_ARGS ]
        then
                echo "Numero de argumentos incorrecto: Usage: check_snmp_controladora_activa [COMMUNITY] [HOST] [OID]"
        exit 3
fi

ERROR=0

OUTPUT=$( /usr/bin/snmpwalk -v2c -Ovq -c $1 $2 $3 )


if [[ $OUTPUT =~ .*1.* ]];
then
        ERROR=3
        echo "Estado de la controladora desconocido (Unknown)"
elif [[ $OUTPUT =~ .*2.* ]];
then
        ERROR=0
        echo "La controladora esta funcionando (Running)"
elif [[ $OUTPUT =~ .*3.* ]];
then
        ERROR=1
        echo "La controladora esta preparada (Ready)"
elif [[ $OUTPUT =~ .*4.* ]];
then
        ERROR=1
        echo "La controladora esta reiniciando (Reset)"
elif [[ $OUTPUT =~ .*5.* ]];
then
        ERROR=0
        echo "La controladora esta funcionando a maxima velocidad (runningAtFullSpeed)"
elif [[ $OUTPUT =~ .*6.* ]];
then
        ERROR=2
        echo "La controladora se ha caido (Down)"
elif [[ $OUTPUT =~ .*7.* ]];
then
        ERROR=0
        echo "La controladora esta en standby (standby)"
else
        ERROR=3
        echo "No se puede calcular el estado de la controladora"
fi

exit $ERROR

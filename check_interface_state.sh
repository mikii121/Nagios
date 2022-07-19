#!/bin/bash

# check_snmp_interface_state.sh
# Descripcion: carga los datos de estado de las interfaces deseadas
# @autor: miguel andres caballero

PROGNAME="check_snmp_interface_state.sh"
COMMUNITY=$1
HOST=$2
OIDALIAS=".1.3.6.1.2.1.31.1.1.1.18"
OIDADSTATE=".1.3.6.1.2.1.2.2.1.7"
OIDOPSTATE=".1.3.6.1.2.1.2.2.1.8"
NUM_INTERFAZ=$3
EXPECTED_ARGS=3

if [ $# -ne $EXPECTED_ARGS ]
        then
                echo "Numero de argumentos incorrecto: Usage: check_snmp_interface_state.sh  [COMMUNITY] [HOST] [NUM_INTERFAZ]"
        exit 3
fi


OUTPUT_ALIAS=$(/usr/bin/snmpwalk -v2c -Ovq -c $1 $2 $OIDALIAS.$3)
OUTPUT_AD=$(/usr/bin/snmpwalk -v2c -Ovq -c $1 $2 $OIDADSTATE.$3)
OUTPUT_OP=$(/usr/bin/snmpwalk -v2c -Ovq -c $1 $2 $OIDOPSTATE.$3)

SALIDA_AD=""
SALIDA_OP=""
WARNING=0
CRITICAL=0
ESTADOOK=0
UNKNOWN=0

if [ $OUTPUT_AD == "2" ] || [ $OUTPUT_AD == "7" ]; then
        SALIDA_AD="DOWN"
        CRITICAL=1
elif [ $OUTPUT_AD == "3" ];then
        SALIDA_AD="UP"
        WARNING=1
elif [ $OUTPUT_AD == "1" ];then
        SALIDA_AD="UP"
        ESTADOOK=1
else
        SALIDA_AD="UNKNOWN"
        UNKNOWN=1
fi


if [ $OUTPUT_OP == "2" ] || [ $OUTPUT_OP == "7" ]; then
        SALIDA_OP="DOWN"
        CRITICAL=1
elif [ $OUTPUT_OP == "3" ];then
        SALIDA_OP="UP"
        WARNING=1
elif [ $OUTPUT_OP == "1" ];then
        SALIDA_OP="UP"
        ESTADOOK=1
else
        SALIDA_OP="UNKNOWN"
        UNKNOWN=1
fi


if [ $CRITICAL == 1 ];then
        echo "El estado de $OUTPUT_ALIAS por el puerto $3 es:\nAdmin state es $SALIDA_AD\nOperational state es $SALIDA_OP"
        exit 2
elif [ $WARNING == 1 ];then
        echo "El estado de $OUTPUT_ALIAS por el puerto $3 es:\nAdmin state es $SALIDA_AD\nOperational state es $SALIDA_OP"
        exit 1
elif [ $UNKNOWN == 1 ];then
        echo "El estado de $OUTPUT_ALIAS por el puerto $3 es:\nAdmin state es $SALIDA_AD\nOperational state es $SALIDA_OP"
        exit 3
elif [ $ESTADOOK == 1 ];then
        echo "El estado de $OUTPUT_ALIAS por el puerto $3 es:\nAdmin state es $SALIDA_AD\nOperational state es $SALIDA_OP"
        exit 0
else
        echo "El estado de $3 no puede ser calculado o es desconocido"
        exit 3
fi
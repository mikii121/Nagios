#!/bin/bash

# Descripcion: Chequea estado de las interfaces deseadas en equipos Juniper
# Author: Miguel Andres Caballero


PROGNAME="check_snmp_juniper_port_state.sh"
COMMUNITY=$1
HOST=$2
OIDALIAS=".1.3.6.1.2.1.31.1.1.1.18"
OIDADSTATE=".1.3.6.1.2.1.2.2.1.7"
OIDOPSTATE=".1.3.6.1.2.1.2.2.1.8"
NUM_INTERFAZ=$3
EXPECTED_ARGS=3

if [ $# -ne $EXPECTED_ARGS ]
        then
                echo "Numero de argumentos incorrecto: Usage: check_snmp_juniper_port_state.sh [COMMUNITY] [HOST] [NUM_INTERFAZ]"
        exit 3
fi

ERROR=2

OUTPUT_ALIAS=$(/usr/bin/snmpwalk -v2c -Ovq -c $1 $2 $OIDALIAS.$3)
OUTPUT_AD=$(/usr/bin/snmpwalk -v2c -Ovq -c $1 $2 $OIDADSTATE.$3)
OUTPUT_OP=$(/usr/bin/snmpwalk -v2c -Ovq -c $1 $2 $OIDOPSTATE.$3)

if [[ $OUTPUT_AD -eq 1 ]] && [[ $OUTPUT_OP -eq 1 ]];
then
        ERROR=0
fi
if [[ $OUTPUT_AD =~ up ]] && [[ $OUTPUT_OP =~ up ]];
then
        ERROR=0
fi
if [[ $OUTPUT_AD -eq 1 ]]; then
        OUTPUT_AD="UP"
else
        OUTPUT_AD="DOWN"
fi
if [[ $OUTPUT_OP -eq 1 ]]; then
        OUTPUT_OP="UP"
else
        OUTPUT_OP="DOWN"
fi
#echo ">>> "$OUTPUT_AD $OUTPUT_OP $ERROR
echo "Interfaz $OUTPUT_ALIAS: Admin State es: $OUTPUT_AD\nInterfaz $OUTPUT_ALIAS OperationalState es $OUTPUT_OP"
exit $ERROR

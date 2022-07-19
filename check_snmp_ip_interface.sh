#!/bin/bash

# check_snmp_ip_interface.sh
# Descripcion: carga las ip de las interfaces deseadas
# @autor: miguel andres caballero

PROGNAME="check_snmp_ip_interface.sh"
COMMUNITY=$1
HOST=$2
OID_INTERF=".1.3.6.1.2.1.4.20.1.2"
OID_IP=".1.3.6.1.2.1.4.20.1.1"
NUM_INTERFAZ=$3
EXPECTED_ARGS=3

if [ $# -ne $EXPECTED_ARGS ]
        then
                echo "Numero de argumentos incorrecto: Usage: check_snmp_ip_interface.sh [COMMUNITY] [HOST] [NUM_INTERFAZ]"
        exit 3
fi

ERROR=0

/usr/bin/snmpwalk -v2c -Ovq -c $1 $2 $OID_INTERF > check_snmp_ip_interface_interfaces
/usr/bin/snmpwalk -v2c -Ovq -c $1 $2 $OID_IP > check_snmp_ip_interface_IP
OUTPUT=$( paste check_snmp_ip_interface_interfaces check_snmp_ip_interface_IP | egrep ^$3 | awk '/\t/ { print $2 }' | paste -s -d"\t\n" |  paste -s -d"\t\n" )


if [ -z "$OUTPUT" ];
then
        ERROR=1
        echo "No se encuetra la ip de la interfaz $3"
else
        ERROR=0
        echo "$OUTPUT"
fi

exit $ERROR

#!/bin/bash

# check_ipmi.sh
# Descripcion: comprueba el estado de un sistema de gestión mediante IPMI, debes cambiar usuario y contraseña y pasarle como argumento la ip a comprobar
# @Autor: Miguel Andrés Caballero mac_121@hotmail.com


USUARIO=[[USER]]
PASSWORD=[[PASS]]
HOST=$1

COMANDO="ipmitool -H $HOST -U $USUARIO -P $PASSWORD"

CPU1_STATUS=$($COMANDO sdr | grep "CPU1 Temp" | cut -d "|" -f 3 | sed 's/[[:space:]]*$//' | sed 's/^[[:space:]]*//')
CPU2_STATUS=$($COMANDO sdr | grep "CPU2 Temp" | cut -d "|" -f 3 | sed 's/[[:space:]]*$//' | sed 's/^[[:space:]]*//')
CPU1_TEMP=$($COMANDO sdr | grep "CPU1 Temp" | cut -d "|" -f 2 | sed 's/[[:space:]]*$//' | sed 's/^[[:space:]]*//')
CPU2_TEMP=$($COMANDO sdr | grep "CPU2 Temp" | cut -d "|" -f 2 | sed 's/[[:space:]]*$//' | sed 's/^[[:space:]]*//')

FAN1_STATUS=$($COMANDO sdr | grep FAN1 | cut -d "|" -f 3 | sed 's/[[:space:]]*$//' | sed 's/^[[:space:]]*//')
FAN2_STATUS=$($COMANDO sdr | grep FAN2 | cut -d "|" -f 3 | sed 's/[[:space:]]*$//' | sed 's/^[[:space:]]*//')
FAN1_RPM=$($COMANDO sdr | grep FAN1 | cut -d "|" -f 2 | sed 's/[[:space:]]*$//' | sed 's/^[[:space:]]*//')
FAN2_RPM=$($COMANDO sdr | grep FAN2 | cut -d "|" -f 2 | sed 's/[[:space:]]*$//' | sed 's/^[[:space:]]*//')

SYSTEM_TEMP=$($COMANDO sdr | grep "System Temp" | cut -d "|" -f 2 | sed 's/[[:space:]]*$//' | sed 's/^[[:space:]]*//')
SYSTEM_TEMP_STATUS=$($COMANDO sdr | grep "System Temp" | cut -d "|" -f 3 | sed 's/[[:space:]]*$//' | sed 's/^[[:space:]]*//')

SYSTEM_POWER=$($COMANDO chassis status | grep "System Power" | cut -d ":" -f 2 | sed 's/[[:space:]]*$//' | sed 's/^[[:space:]]*//')


SALIDA=""
CRITICAL=0
WARNING=0
UNKNOWN=0

if [[ $SYSTEM_POWER =~ on ]]; then
	SALIDA="SISTEMA ENCENDIDO"

	if [[ $CPU1_STATUS =~ ok ]]; then
		SALIDA="$SALIDA \nCPU1 Temp OK ( $CPU1_TEMP )"
	else
		SALIDA="$SALIDA \nCPU1 Temp CRITICAL ( $CPU1_TEMP )"
		CRITICAL=1
	fi

	if [[ $CPU2_STATUS =~ ok ]]; then
		SALIDA="$SALIDA \nCPU2 Temp OK ( $CPU2_TEMP )"
	else
		SALIDA="$SALIDA \nCPU2 Temp CRITICAL ( $CPU2_TEMP )"
		CRITICAL=1
	fi

	if [[ $FAN1_STATUS =~ ok ]]; then
		SALIDA="$SALIDA \nFAN1 OK ( $FAN1_RPM )"
	else
		SALIDA="$SALIDA \nFAN1 WARNING ( $FAN1_RPM )"
		WARNING=1
	fi

	if [[ $FAN2_STATUS =~ ok ]]; then
		SALIDA="$SALIDA \nFAN2 OK ( $FAN2_RPM )"
	else
		SALIDA="$SALIDA \nFAN2 WARNING ( $FAN2_RPM )"
		WARNING=1
	fi

	if [[ $SYSTEM_TEMP_STATUS =~ ok ]]; then
		SALIDA="$SALIDA \nSystem Temp OK ( $SYSTEM_TEMP )"
	else
		SALIDA="$SALIDA \nSystem Temp CRITICAL ( $SYSTEM_TEMP )"
		CRITICAL=1
	fi


else
	SALIDA="SISTEMA APAGADO"
	CRITICAL=1
fi




if [[ $CRITICAL == 1 ]]; then
        echo "CRITICAL \n$SALIDA"
        exit 2
fi
if [[ $WARNING == 1 ]]; then
        echo "WARNING \n$SALIDA"
        exit 1
fi
if [[ $UNKNOWN == 1 ]]; then
        echo "UNKNOWN \n$SALIDA"
        exit 3
fi

echo "OK \n$SALIDA"
exit 0

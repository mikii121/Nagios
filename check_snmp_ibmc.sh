
#!/bin/bash



#comprobacion de parametros de entrada

EXPECTED_ARGS=2

if [ $# -ne $EXPECTED_ARGS ]
   then
         echo "Numero de parametros incorrecto:  <command> ip comunity"
         exit
fi

HOSTNAME=$1
COMUNITY=$2
OID_NAME=.1.3.6.1.4.1.2011.2.235.1.1.1.6.0
OID_HEALTH=.1.3.6.1.4.1.2011.2.235.1.1.1.1.0
OID_POWER=.1.3.6.1.4.1.2011.2.235.1.1.6.1.0
OID_FANSTATUS=.1.3.6.1.4.1.2011.2.235.1.1.8.3.0
OID_MEMORYSTATUS=.1.3.6.1.4.1.2011.2.235.1.1.16.1.0
OID_CPUSTATUS=.1.3.6.1.4.1.2011.2.235.1.1.15.1.0
OID_TEMPERATURA=.1.3.6.1.4.1.2011.2.235.1.1.26.50.1.3
OID_TEMPERATURANAME=.1.3.6.1.4.1.2011.2.235.1.1.26.50.1.2


NAME=$(snmpget -v2c -Ovq -c $COMUNITY $HOSTNAME $OID_NAME)

#  INTEGER {ok(1),minor(2),major(3),critical(4)}
HEALTH=$(snmpget -v2c -Ovq -c $COMUNITY $HOSTNAME $OID_HEALTH)

#  INTEGER {ok(1),minor(2),major(3),critical(4),absence(5),unknown(6)}
POWER=$(snmpget -v2c -Ovq -c $COMUNITY $HOSTNAME $OID_POWER)

# INTEGER {ok(1),minor(2),major(3),critical(4),absence(5),unknown(6)}
FANSTATUS=$(snmpwalk -v2c -Ovq -c $COMUNITY $HOSTNAME $OID_FANSTATUS)

# INTEGER {ok(1),minor(2),major(3),critical(4),absence(5),unknown(6)}
MEMORYSTATUS=$(snmpwalk -v2c -Ovq -c $COMUNITY $HOSTNAME $OID_MEMORYSTATUS)

# INTEGER {ok(1),minor(2),major(3),critical(4),absence(5),unknown(6)}
CPUSTATUS=$(snmpwalk -v2c -Ovq -c $COMUNITY $HOSTNAME $OID_CPUSTATUS)


if [[ -z $NAME ]]; then
        echo "CRITICAL - No se puede conectar con el dispositivo"
        exit 2
fi

SALIDA=""
CRITICAL=0
UNKNOWN=0
WARNING=0

case "$HEALTH" in
        1)
            SALIDA="$SALIDA HEALTH:OK"
            ;;
        2)
            SALIDA="$SALIDA HEALTH:MINOR"
            WARNING=1
            ;;
        3)
            SALIDA="$SALIDA HEALTH:MAJOR"
            WARNING=1
            ;;
        4)
            SALIDA="$SALIDA HEALTH:CRITICAL"
            CRITICAL=1
            ;;
        *)
            SALIDA="$SALIDA HEALTH:UNKNOWN"
            UNKNOWN=1
esac

case "$POWER" in
        1)
            SALIDA="$SALIDA \nPOWER:OK"
            ;;
        2)
            SALIDA="$SALIDA \nPOWER:MINOR"
            WARNING=1
            ;;
        3)
            SALIDA="$SALIDA \nPOWER:MAJOR"
            WARNING=1
            ;;
        4)
            SALIDA="$SALIDA \nPOWER:CRITICAL"
            CRITICAL=1
            ;;
        5)
            SALIDA="$SALIDA \nPOWER:ABSENCE"
            CRITICAL=1
            ;;
        6)
            SALIDA="$SALIDA \nPOWER:UNKNOWN"
            UNKNOWN=1
            ;;
        *)
            SALIDA="$SALIDA \nPOWER:UNKNOWN"
            UNKNOWN=1
esac

case "$FANSTATUS" in
        1)
            SALIDA="$SALIDA \nFANSTATUS:OK"
            ;;
        2)
            SALIDA="$SALIDA \nFANSTATUS:MINOR"
            WARNING=1
            ;;
        3)
            SALIDA="$SALIDA \nFANSTATUS:MAJOR"
            WARNING=1
            ;;
        4)
            SALIDA="$SALIDA \nFANSTATUS:CRITICAL"
            CRITICAL=1
            ;;
        5)
            SALIDA="$SALIDA \nFANSTATUS:ABSENCE"
            CRITICAL=1
            ;;
        6)
            SALIDA="$SALIDA \nFANSTATUS:UNKNOWN"
            UNKNOWN=1
            ;;
        *)
            SALIDA="$SALIDA \nFANSTATUS:UNKNOWN"
            UNKNOWN=1
esac

case "$MEMORYSTATUS" in
        1)
            SALIDA="$SALIDA \nMEMORYSTATUS:OK"
            ;;
        2)
            SALIDA="$SALIDA \nMEMORYSTATUS:MINOR"
            WARNING=1
            ;;
        3)
            SALIDA="$SALIDA \nMEMORYSTATUS:MAJOR"
            WARNING=1
            ;;
        4)
            SALIDA="$SALIDA \nMEMORYSTATUS:CRITICAL"
            CRITICAL=1
            ;;
        5)
            SALIDA="$SALIDA \nMEMORYSTATUS:ABSENCE"
            CRITICAL=1
            ;;
        6)
            SALIDA="$SALIDA \nMEMORYSTATUS:UNKNOWN"
            UNKNOWN=1
            ;;
        *)
            SALIDA="$SALIDA \nMEMORYSTATUS:UNKNOWN"
            UNKNOWN=1
esac

case "$CPUSTATUS" in
        1)
            SALIDA="$SALIDA \nCPUSTATUS:OK"
            ;;
        2)
            SALIDA="$SALIDA \nCPUSTATUS:MINOR"
            WARNING=1
            ;;
        3)
            SALIDA="$SALIDA \nCPUSTATUS:MAJOR"
            WARNING=1
            ;;
        4)
            SALIDA="$SALIDA \nCPUSTATUS:CRITICAL"
            CRITICAL=1
            ;;
        5)
            SALIDA="$SALIDA \nCPUSTATUS:ABSENCE"
            CRITICAL=1
            ;;
        6)
            SALIDA="$SALIDA \nCPUSTATUS:UNKNOWN"
            UNKNOWN=1
            ;;
        *)
            SALIDA="$SALIDA \nCPUSTATUS:UNKNOWN"
            UNKNOWN=1
esac


TEMPERATURA=$(snmpwalk -v2c -Ovq -c $COMUNITY $HOSTNAME $OID_TEMPERATURA.1)
TEMPERATURANAME=$(snmpwalk -v2c -Ovq -c $COMUNITY $HOSTNAME $OID_TEMPERATURANAME.1)
SALIDA="$SALIDA \nTEMPERATURA: $TEMPERATURANAME = $TEMPERATURA ºC"

TEMPERATURA=$(snmpwalk -v2c -Ovq -c $COMUNITY $HOSTNAME $OID_TEMPERATURA.2)
TEMPERATURANAME=$(snmpwalk -v2c -Ovq -c $COMUNITY $HOSTNAME $OID_TEMPERATURANAME.2)
SALIDA="$SALIDA $TEMPERATURANAME = $TEMPERATURA ºC"

TEMPERATURA=$(snmpwalk -v2c -Ovq -c $COMUNITY $HOSTNAME $OID_TEMPERATURA.3)
TEMPERATURANAME=$(snmpwalk -v2c -Ovq -c $COMUNITY $HOSTNAME $OID_TEMPERATURANAME.3)
SALIDA="$SALIDA $TEMPERATURANAME = $TEMPERATURA ºC"


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









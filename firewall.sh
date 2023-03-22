#!/bin/sh
# Script ejecutable de configuración de iptables

# Eliminar todas las reglas previas de la tabla FILTER, que puedan existir 
iptables -F

# Eliminar todas las reglas previas de la tabla NAT, que puedan existir 
iptables -t nat -F

# Crear las reglas para establecer la política permisiva por defecto en las cadenas (permitir o ACCEPT)
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT

# Crear la regla para permitir la entrada y salida de todos los paquetes de datos
#  por la interfaz o tarjeta de red local (lo = loopback = 127.0.0.1), para evitar errores en el sistema
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Activar el enrutamiento, para que funcione PREROUTING, FORWARD, POSTROUTING...
echo "1" > /proc/sys/net/ipv4/ip_forward

# Crear las reglas para filtrar, traducir o modificar los paquetes de datos

##### INICIO REGLAS #####
# Ejemplo 1:
#   Bloquear la entrada de todos los paquetes de datos que vienen de la red origen 172.16.200.0/24
iptables -A INPUT -s 172.16.200.0/24 -j DROP

# Ejemplo 2:
#   Permitir la entrada de todos los paquetes de datos que vienen de la red origen 10.200.0.0/24 
iptables -A INPUT -s 10.200.0.0/24 -j ACCEPT
##### FIN REGLAS #####

# Listar todas las reglas configuradas de la tabla FILTER
iptables -nL --line-numbers

# Listar todas las reglas configuradas de la tabla NAT
iptables -t nat -nL --line-numbers
 
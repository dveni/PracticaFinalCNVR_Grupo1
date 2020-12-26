# Practica Final CNVR - Grupo1
Desarrollo de la práctica final de CNVR curso 2020/21
## Autores :
- Raúl Torres García
- Daniel Vera Nieto
- Salomon Fereres Benzaquen
------------

## Objetivo:
Automatizar el despliegue sobre Openstack de una aplicación utilizando Heat.
Desarrollo de los scripts, plantillas y otros ficheros de configuración necesarios para desplegar de forma automática en una nube Openstack utilizando los servicios de orquestación Heat de
una aplicación escalable compuesta por servidores web, base de datos, balanceadores y firewall
------------

## Escenario:
![Escenario](https://github.com/RAULTG97/PracticaFinalRDSV_Grupo12/blob/main/PracticaFinalRDSV.png)


- Tres servidores web que alojen la aplicación web que soporta el servicio
escalable.
- Una base de datos pensada para almacenar datos de la aplicación. Nota: no es necesario que la aplicación utilice la base de datos, pero si será necesario demostrar que la base de datos esta accesible desde los servidores.
- Un servidor de administración que se utilizará para tareas de gestión del servicio y que será el único que esté accesible desde el exterior mediante SSH.
- Un firewall que filtre el tráfico procedente del exterior (norte-sur) y que permita únicamente los accesos a los servidores web por parte de los clientes, así como el tráfico SSH hacia el servidor de gestión por parte de los administradores del
servicio.
- Un balanceador de carga que distribuya el tráfico entre los distintos servidores
web.
- Opcionalmente, otros servidores que considere adecuados, por ejemplo, servidores de almacenamiento a los que acceden los servidores web para almacenar o recuperar ficheros.
------------

## Requisitos:

- Características del escenario:
	- Aplicación alojada en múltiples servidores web sobre los que se balancea el tráfico mediante un balanceador
	- Servidor de administración para acceso a la gestión de las máquinas virtuales del escenario
	- Cortafuegos basado en FwaaSv2 o VM Linux con fwbuilder o similar
	- Autoconfiguración mediante (cloud-init y metadatos) de las máquinas virtuales partiendo de imagen Ubuntu
		- Dos fases: creación de la imagen y arranque de las MVs
	- Red interna con servidores (bases de datos, almacenamiento, etc.) no accesibles desde el exterior

- Partes opcionales:
	- Autoescalado mediante Heat/Ceilometer
	- Soporte servicios IoT con HomeAssistant/Mosquitto
------------

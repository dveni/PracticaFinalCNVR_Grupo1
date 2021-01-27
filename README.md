# CNVR Final Project - Group1
Development of the final project of CNVR course 2020/21
## Authors :
- Raúl Torres García
- Daniel Vera Nieto
- Salomón Fereres Benzaquen
------------

## Objective:

Automate the deployment on Openstack of an application using Heat.
Development of scripts, templates and other configuration files needed to deploy automatically on an Openstack cloud using Heat orchestration services of a scalable application consisting of web servers, database, balancers and firewall.

------------

## Scenario:
![Scenario](https://github.com/RAULTG97/PracticaFinalCNVR_Grupo1/blob/main/images/escenario.png)


- Three web servers hosting the web application supporting the scalable service.
scalable service.
- A database designed to store application data. Note: it is not necessary for the application to use the database, but it will be necessary to demonstrate that the database is accessible from the servers.
- An administration server that will be used for service management tasks and will be the only one accessible from the outside via SSH.
- A firewall that filters traffic from the outside (north-south) and only allows access to the web servers by the clients, as well as SSH traffic to the management server by the service administrators.
administrators to the management server.
- A load balancer that distributes the traffic between the different web servers.
servers.
- Optionally, other servers that you consider appropriate, e.g. storage servers accessed by the web servers to store or retrieve files.
------------

## Requirements:

- Scenario characteristics:
	- Application hosted on multiple web servers over which traffic is balanced by a load balancer.
	- Administration server for access to the management of the scenario virtual machines.
	- Firewall based on FwaaSv2 or Linux VM with fwbuilder or similar
	- Auto-configuration (cloud-init and metadata) of the virtual machines starting from Ubuntu image
		- Two phases: creation of the image and booting of the VMs
	- Internal network with servers (databases, storage, etc.) not accessible from the outside

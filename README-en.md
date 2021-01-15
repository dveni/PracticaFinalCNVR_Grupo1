# CNVR Final Assignment - Group1
Development of the CNVR's final assignment - Year 2020/21
## Authors :
- Raúl Torres García
- Daniel Vera Nieto
- Salomon Fereres Benzaquen
------------

## Objective:

To automate the deployment on Openstack of an application using Heat.
Development of the scripts, templates and other configuration files needed to automatically deploy on an Openstack cloud using Heat orchestration services of a scalable application composed of web servers, database, balancers and firewall

------------

## Scenario:
![Scenario](https://github.com/RAULTG97/PracticaFinalCNVR_Grupo1/blob/main/images/escenario.png)


- Three web servers that host the web application that supports the service
scalable.
- A database designed to store application data. Note: it is not necessary for the application to use the database, but it will be necessary to demonstrate that the database is accessible from the servers.
- An administration server that will be used for service management tasks and that will be the only one accessible from the outside through SSH.
- A firewall that filters the traffic coming from the outside (north-south) and that only allows access to the web servers by the clients, as well as the SSH traffic to the management server by the administrators of the
service.
- A load balancer that distributes the traffic between the different servers
website.
- Optionally, other servers that you consider appropriate, for example, storage servers accessed by web servers to store or retrieve files.
------------

## Requirements:

- Scenario characteristics:
	- Application hosted on multiple web servers on which traffic is balanced by a balancer
	- Administration server for access to the management of the stage's virtual machines
	- Firewall based on FwaaSv2 or Linux VM with fwbuilder or similar
	- Auto-configuration (cloud-init and metadata) of the virtual machines from the Ubuntu image
		- Two phases: creation of the image and starting up the MVs
	- Internal network with servers (databases, storage, etc.) not accessible from the outside

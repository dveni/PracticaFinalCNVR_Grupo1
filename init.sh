#!/bin/bash

#START OPENSTACK
/lab/cnvr/bin/get-openstack-tutorial.sh 

#START SCENARIO [HAY QUE MODIFICAR LAS IMAGENES EN LOAD-IMG]
sudo vnx -f /mnt/tmp/openstack_lab-stein_4n_classic_ovs-v06/openstack_lab.xml -v --create 
sudo vnx -f /mnt/tmp/openstack_lab-stein_4n_classic_ovs-v06/openstack_lab.xml -v -x start-all
sudo vnx -f /mnt/tmp/openstack_lab-stein_4n_classic_ovs-v06/openstack_lab.xml -v -x load-img

#CONFIGURE NAT
EXT=`ifconfig | grep enp | awk '{print $1}' | tr -d ':'`
sudo vnx_config_nat ExtNet $EXT

#ExtNet (Antes se creaba con create-demo-scenario desde VNX, ahora todo eso se hace con Heat)
#openstack network create --share --external --provider-physical-network provider --provider-network-type flat ExtNet
#openstack subnet create --network ExtNet --gateway 10.0.10.1 --dns-nameserver 10.0.10.1 --subnet-range 10.0.10.0/24 --allocation-pool start=10.0.10.100,end=10.0.10.200 ExtSubNet


#CREATE ADMIN USER
#USAMOS INICIALMENTE PRIVILEGIOS DE USUARIO ADMIN PARA CREAR NUESTRO PROPIO USUARIO
source bin/admin-openrc.sh
openstack stack create -t create-project.yaml --parameter "project_name=group1project" --parameter "admin_name=group1user" --parameter "admin_password=xxxx" stackuser
sleep 30
#Alternativa para crearlo desde la linea de comandos de Openstack
#openstack project create --domain default --description "CNVR Project Group 1" group1project
#openstack user create --domain default --project group1project --password xxxx --description "User for group1project CNVR" group1user
#openstack role add --project group1project --user group1user user


#IMAGES (necesita roles de admin)
#BBDD
#wget https://www.dropbox.com/s/r73z17ze26apxlx/bbdd-server.raw?dl=0
#mv bbdd-server.raw?dl=0 bbdd-server.raw
glance image-create --name "bbdd-image" --file bbdd-server.raw --disk-format raw --container-format bare --visibility public --progress

#WEBSERVER
#wget https://www.dropbox.com/s/wk8snabpf4fzeux/webserver.raw?dl=0
#mv webserver.raw?dl=0 webserver.raw
glance image-create --name "webserver-image" --file webserver.raw --disk-format raw --container-format bare --visibility public --progress


#PRIVILEGIOS PARA NUESTRO USUARIO
#Usuario: group1user | Password: xxxx
source bin/group1user-openrc.sh


#HEAT STACK
openstack stack create -t scenario.yaml --parameter "key_name=key_group1" stackscenario

sleep 120

#LOAD BALANCER
./loadBalancerConfiguration.sh
#cd templates/
#openstack stack create lbstack -e lb_properties.yaml -t lb.yaml
#cd ../

#FIREWALL
#./firewallConfiguration.sh




#COMANDOS UTILES
#openstack orchestration template validate -t scenario.yaml
#openstack stack list
#openstack stack show stack1
#openstack stack output show --all stack1
#openstack stack output show -f json --all stack1
#openstack stack output show -f json -c instance_ip --all stack1
#openstack stack output show -c instance_ip --all stack1

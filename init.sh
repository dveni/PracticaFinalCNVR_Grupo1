#!/bin/bash

#START OPENSTACK
/lab/cnvr/bin/get-openstack-tutorial.sh 

#MODIFY OPENSTACK_LAB.XML [CREO QUE ESTE PASO NO HACE FALTA]
#cd /mnt/tmp/openstack_lab-stein_4n_classic_ovs-v06 
#rm /mnt/tmp/openstack_lab-stein_4n_classic_ovs-v06/openstack_lab.xml
#cp xml/openstack_lab.xml /mnt/tmp/openstack_lab-stein_4n_classic_ovs-v06

#START SCENARIO [HAY QUE MODIFICAR LAS IMAGENES EN LOAD-IMG]
sudo vnx -f /mnt/tmp/openstack_lab-stein_4n_classic_ovs-v06/openstack_lab.xml --create 
sudo vnx -f /mnt/tmp/openstack_lab-stein_4n_classic_ovs-v06/openstack_lab.xml -x start-all,load-img


#CREATE ADMIN USER
#USAMOS INICIALMENTE PRIVILEGIOS DE USUARIO ADMIN PARA CREAR NUESTRO PROPIO USUARIO
source bin/admin-openrc.sh
openstack project create --domain default --description "CNVR Project Group 1" group1project
openstack user create --domain default --project group1project --password xxxx --description "User for group1project CNVR" group1user
openstack role add --project group1project --user group1user admin

#Usuario: group1user | Password: xxxx
source bin/group1user-openrc.sh

#ExtNet (Antes se creaba con create-demo-scenario desde VNX, ahora todo eso se hace con Heat)
openstack network create --share --external --provider-physical-network provider --provider-network-type flat ExtNet
openstack subnet create --network ExtNet --gateway 10.0.10.1 --dns-nameserver 10.0.10.1 --subnet-range 10.0.10.0/24 --allocation-pool start=10.0.10.100,end=10.0.10.200 ExtSubNet
#CONFIGURE NAT
EXT=`ifconfig | grep enp | awk '{print $1}' | tr -d ':'`
sudo vnx_config_nat ExtNet $EXT
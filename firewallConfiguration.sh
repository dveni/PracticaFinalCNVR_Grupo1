#!/bin/bash


source bin/group1user-openrc.sh

# IPs
IP_SADMIN="$(openstack stack output show stackscenario s_admin_private_ip_net1 -c output_value -f value)"
IP_LB="$(neutron lbaas-loadbalancer-show lb | awk 'FNR == 14 {print $4}')"
PORT_ID="$(openstack port list --fixed-ip subnet=subnet1,ip-address=10.1.1.1 -c ID -f value)"

#Permitir acceso desde el exterior al puerto SSH(22) de s_admin (10.1.1.97)
openstack firewall group rule create --protocol tcp --destination-port 22 --destination-ip-address "${IP_SADMIN}" --action allow --name fw_rule_sadmin

#Permitir acceso desde el interior (10.1.1.0/24 - 10.1.2.0/24) a cualquier destino con cualquier protocolo
openstack firewall group rule create --protocol any --source-ip-address 10.1.1.0/24 --destination-ip-address 0.0.0.0/24 --action allow --name fw_rule_net1
openstack firewall group rule create --protocol any --source-ip-address 10.1.2.0/24 --destination-ip-address 0.0.0.0/24 --action allow --name fw_rule_net2

#Permitir acceso desde el exterior al puerto WWW(80) del Balanceador de carga
openstack firewall group rule create --protocol tcp --destination-port 80 --destination-ip-address "${IP_LB}" --action allow --name fw_rule_lb

#Crear el firewall policy y añadir las reglas al policy
openstack firewall group policy create --firewall-rule "fw_rule_sadmin" fwcnvr
openstack firewall group policy add rule fwcnvr "fw_rule_net1"
openstack firewall group policy add rule fwcnvr "fw_rule_net2"
openstack firewall group policy add rule fwcnvr "fw_rule_lb"

#Crear el firewall group
#openstack firewall group create --ingress-firewall-policy "fwcnvr" --no-port
openstack firewall group create --ingress-firewall-policy "fwcnvr" --port "${PORT_ID}"

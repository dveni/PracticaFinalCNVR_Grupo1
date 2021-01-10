#!/bin/bash


source bin/group1user-openrc.sh

neutron lbaas-loadbalancer-create --name lb subnet1

sleep 20

neutron security-group-create lbaasv2

neutron security-group-rule-create   --direction ingress   --protocol icmp   lbaasv2
neutron security-group-rule-create   --direction ingress   --protocol tcp   --port-range-min 8001   --port-range-max 8001   --remote-ip-prefix 0.0.0.0/0   lbaasv2


neutron port-update --security-group lbaasv2 $(neutron lbaas-loadbalancer-show lb | awk 'FNR == 15 {print $4}')


neutron lbaas-listener-create --name lb-http-8001 --loadbalancer lb --protocol HTTP --protocol-port 8001
sleep 5
neutron lbaas-pool-create --name lb-http-pool-8001 --lb-algorithm ROUND_ROBIN --listener lb-http-8001 --protocol HTTP
sleep 5

S1="$(openstack server show s1 -c addresses -f value | awk 'FNR == 1 {print $2}' | awk -F "=" '{print $2}')"
S2="$(openstack server show s2 -c addresses -f value | awk 'FNR == 1 {print $2}' | awk -F "=" '{print $2}')"
S3="$(openstack server show s3 -c addresses -f value | awk 'FNR == 1 {print $2}' | awk -F "=" '{print $2}')"
neutron lbaas-member-create --name lb-member-01 --subnet subnet1 --address s1 --protocol-port 8001 lb-http-pool-8001
neutron lbaas-member-create --name lb-member-02 --subnet subnet1 --address s2 --protocol-port 8001 lb-http-pool-8001
neutron lbaas-member-create --name lb-member-03 --subnet subnet1 --address s3 --protocol-port 8001 lb-http-pool-8001


# Assign floating IP to LB
ID_LB="$( neutron lbaas-loadbalancer-list -c id -f value )"
VIP_PORT_LB="$( neutron lbaas-loadbalancer-show -c vip_port_id -f value "${ID_LB}" )"
ID_LB_FIP="$( openstack ip floating create ExtNet -c id -f value )"
neutron floatingip-associate "${ID_LB_FIP}" "${VIP_PORT_LB}"

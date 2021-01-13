#!/bin/bash


source bin/group1user-openrc.sh

neutron lbaas-loadbalancer-create --name lb subnet1

sleep 20

neutron security-group-create lbaasv2

neutron security-group-rule-create   --direction ingress   --protocol icmp   lbaasv2
neutron security-group-rule-create   --direction ingress   --protocol tcp   --port-range-min 8001   --port-range-max 8001   --remote-ip-prefix 0.0.0.0/0   lbaasv2


neutron port-update --security-group lbaasv2 $(neutron lbaas-loadbalancer-show lb | awk 'FNR == 15 {print $4}')


neutron lbaas-listener-create --name lb-http-8001 --loadbalancer lb --protocol HTTP --protocol-port 8001
sleep 40
neutron lbaas-pool-create --name lb-http-pool-8001 --lb-algorithm ROUND_ROBIN --listener lb-http-8001 --protocol HTTP
sleep 30

# Assign floating IP to LB
ID_LB="$( neutron lbaas-loadbalancer-list -c id -f value )"
VIP_PORT_LB="$( neutron lbaas-loadbalancer-show -c vip_port_id -f value "${ID_LB}" )"
ID_LB_FIP="$( openstack ip floating create ExtNet -c id -f value )"
neutron floatingip-associate "${ID_LB_FIP}" "${VIP_PORT_LB}"

echo "The floating ip of the load balancer is: " "$(openstack ip floating show "${ID_LB_FIP}" -c floating_ip_address -f value)"

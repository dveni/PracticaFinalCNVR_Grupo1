#!/bin/bash


source bin/group1user-openrc.sh

neutron lbaas-loadbalancer-create --name lb subnet1

sleep 5

neutron security-group-create lbaasv2

neutron security-group-rule-create   --direction ingress   --protocol tcp   --port-range-min 80   --port-range-max 80   --remote-ip-prefix 0.0.0.0/0   lbaasv2
neutron security-group-rule-create   --direction ingress   --protocol tcp   --port-range-min 443   --port-range-max 443   --remote-ip-prefix 0.0.0.0/0   lbaasv2
neutron security-group-rule-create   --direction ingress   --protocol icmp   lbaasv2
neutron security-group-rule-create   --direction ingress   --protocol tcp   --port-range-min 8001   --port-range-max 8001   --remote-ip-prefix 0.0.0.0/0   lbaasv2


neutron port-update --security-group lbaasv2 245b4951-dd27-4215-bfc8-a6ce81484e1e


neutron lbaas-listener-create --name lb-http-8001 --loadbalancer lb --protocol HTTP --protocol-port 8001
sleep 5
neutron lbaas-pool-create --name lb-http-pool-8001 --lb-algorithm ROUND_ROBIN --listener lb-http-8001 --protocol HTTP
sleep 5

neutron lbaas-member-create --name lb-member-01 --subnet subnet1 --address 10.1.1.12 --protocol-port 8001 lb-http-pool-8001
neutron lbaas-member-create --name lb-member-02 --subnet subnet1 --address 10.1.1.72 --protocol-port 8001 lb-http-pool-8001
neutron lbaas-member-create --name lb-member-3 --subnet subnet1 --address 10.1.1.99 --protocol-port 8001 lb-http-pool-8001


# Assign floating IP to LB
ID_LB="$( neutron lbaas-loadbalancer-list -c id -f value )"
VIP_PORT_LB="$( neutron lbaas-loadbalancer-show -c vip_port_id -f value "${ID_LB}" )"
ID_LB_FIP="$( openstack ip floating create ExtNet -c id -f value )"
neutron floatingip-associate "${ID_LB_FIP}" "${VIP_PORT_LB}"
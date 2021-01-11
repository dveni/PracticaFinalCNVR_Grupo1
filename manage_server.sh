#!/bin/bash

ACTION=$1

if [$ACTION == "DELETE"]
then 
	server_to_delete = "$(neutron lbaas-member-list lbstack-pool-ygdxv72n5mly | awk 'FNR==4{print $2}')"
	echo "Removing server with id "$(server_to_delete)"..."
	#neutron lbaas-member-delete "$(server_to_delete)"
	nova delete "$(server_to_delete)"
	echo "Server removed"
fi

if [$ACTION == "CREATE"]
then
	STACK_NAME=$2
	echo "Creating a new server with stack $STACK_NAME..."
	cd templates/
	openstack stack create -e server_properties.yaml -t lb_server.yaml $STACK_NAME
	cd ../
fi

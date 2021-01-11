#!/bin/bash

ACTION=$1
source bin/group1user-openrc.sh

if [ $ACTION == "DELETE" ]
then 
	server_to_delete="$(nova list | awk 'BEGIN {FS="|"}; {print $2, $3}' | awk '{
	if ($2 ~ /server/ )
	print $1
	}' | awk 'FNR == 1'
	)"
	echo "Removing server with id "${server_to_delete}"..."
	#neutron lbaas-member-delete "${server_to_delete}"
	nova delete "${server_to_delete}"
	echo "Server removed"
fi

if [ $ACTION == "CREATE" ]
then
	STACK_NAME=$2
	echo "Creating a new server with stack $STACK_NAME..."
	cd templates/
	openstack stack create -e server_properties.yaml -t lb_server.yaml $STACK_NAME
	cd ../
fi

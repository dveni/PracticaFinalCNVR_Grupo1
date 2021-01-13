#!/bin/bash

ACTION=$1
source bin/group1user-openrc.sh
SERVER_NAME=$2
if [ $ACTION == "DELETE" ]
then 
	
	echo "Removing server with id "${SERVER_NAME}"..."
	openstack stack delete $SERVER_NAME
	echo "Server removed"
fi

if [ $ACTION == "CREATE" ]
then

	echo "Creating a new server $SERVER_NAME..."
	cd templates/
	openstack stack create -e server_properties.yaml --parameter "name=$SERVER_NAME" -t lb_server.yaml $SERVER_NAME
	cd ../
fi

#!/bin/bash
. "$(dirname $0)/vars.sh"

sudo cp ./ansible/hosts /etc/ansible/
case "$1" in
	configure)
		cd ansible
			ansible dev -m ping
			ansible-playbook test.yml
			ansible-playbook docker.yml
		cd -
	;;
	clone)
		cd ansible
			ansible-playbook clone.yml
		cd -
	;;
	remove)
		cd ansible
			ansible-playbook remove.yml
		cd -
	;;
	new)
		./$0 remove
		./$0 clone
		./$0 all
	;;
	all)
		./$0 app
		./$0 service
		./$0 database
	;;
	app)
		cd ansible
			ansible-playbook app.yml
		cd -
	;;
	service)
		cd ansible
			ansible-playbook service.yml
		cd -
	;;
	database)
		cd ansible
			ansible-playbook database.yml
		cd -
	;;
	view)
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME_A "sudo docker container ls"
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME_B "sudo docker container ls"
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME_C "sudo docker container ls"
	;;
	view-images)
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME_A "sudo docker images"
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME_B "sudo docker images"
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME_C "sudo docker images"
	;;
	stop)
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME_A "sudo docker stop \$(sudo docker ps -a -q)"
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME_B "sudo docker stop \$(sudo docker ps -a -q)"
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME_C "sudo docker stop \$(sudo docker ps -a -q)"
	;;
	delete-containers)
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME_A "sudo docker rm -f \$(sudo docker ps -a -q)"
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME_B "sudo docker rm -f \$(sudo docker ps -a -q)"
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME_C "sudo docker rm -f \$(sudo docker ps -a -q)"
	;;
	delete-images)
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME_A "sudo docker rmi -f \$(sudo docker images -q)"
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME_B "sudo docker rmi -f \$(sudo docker images -q)"
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME_C "sudo docker rmi -f \$(sudo docker images -q)"				
	;;
	help)
		echo ansible
		echo clone-local
		echo clone-remote
		echo clone-remove
	;;
esac

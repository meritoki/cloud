#!/bin/bash
. "$(dirname $0)/vars.sh"

sudo cp ./hosts /etc/ansible/
case "$1" in
	configure)
		ansible dev -m ping
		ansible-playbook dev.yml
		ansible-playbook docker.yml
	;;
	clone)
			ansible-playbook clone.yml
	;;
	remove)
			ansible-playbook remove.yml
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
		ansible-playbook app.yml
	;;
	service)
		ansible-playbook service.yml
	;;
	database)
		ansible-playbook database.yml
	;;
	view)
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME "sudo docker container ls"
	;;
	view-images)
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME "sudo docker images"
	;;
	stop)
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME "sudo docker stop \$(sudo docker ps -a -q)"
	;;
	delete-containers)
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME "sudo docker rm \$(sudo docker ps -a -q)"
	;;
	delete-images)
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME "sudo docker rmi \$(sudo docker images -q)"
	;;
	help)
		echo ansible
		echo clone-local
		echo clone-remote
		echo clone-remove
	;;
esac

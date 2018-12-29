#!/bin/bash
. "$(dirname $0)/vars.sh"

sudo cp ./ansible/hosts /etc/ansible/
case "$1" in
	preconfigure)
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME "mkdir -p ~/meritoki/dailybread/cloud/ssh"
		scp -rp ./ssh/sshd_config $REMOTE_USERNAME@$REMOTE_HOSTNAME:~/meritoki/dailybread/cloud/ssh
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME "sudo apt-get install python"
	configure)
		cd ansible
			ansible dev -m ping
			ansible-playbook dev.yml
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
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME "sudo docker container ls"
	;;
	view-images)
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME "sudo docker images"
	;;
	stop)
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME "sudo docker stop \$(sudo docker ps -a -q)"
	;;
	delete-containers)
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME "sudo docker rm -f \$(sudo docker ps -a -q)"
	;;
	delete-images)
		ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME "sudo docker rmi -f \$(sudo docker images -q)"
	;;
	help)
		echo ansible
		echo clone-local
		echo clone-remote
		echo clone-remove
	;;
esac

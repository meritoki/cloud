#!/bin/bash
. "$(dirname $0)/vars.sh"

case "$1" in
	hosts)
			sudo cp ./ansible/hosts /etc/ansible/
	;;
	ping)
		cd ansible
			ansible dev -m ping
		cd -
	;;
	preconfigure)
		cd ansible
			ansible-playbook ssh.yml --ask-become-pass --ask-pass --extra-vars='pubkey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtngM11pmS2uHUvcoDvxrgx8/mA+alSxbGMzWYAyv+q4BbbMY3L7DLAV9pGFhQ7hI6HWbN0XB6ARNt2vBjSJgo9UQRj+ivcJNQqgmw+0vkbeGsjcgVW7jQLr4IbmSaIZKjw54gpGgRT0/nqborGVyjru/S7XfmmYUaWcDMIS8hlTUqciY+CyyHfu7moYiaeCi28z2gMsIO2/wCWoG2CIMWTIW0D7qJd65OP5/6RST9sl5/iphpVqjPIAgZD7Yr749cbChVx1Z8sxJ9DSUtL4wlFAGq++LWP+2cvYi1lSCsgWqPGFa9CWc9hZiV+pBHuvHaJtLqrWv0YuC5g7K5U7Tt jorodriguez@jor-server-0002
"'
			ansible-playbook python.yml
		cd -
	;;
	configure)
		cd ansible
			ansible-playbook dev.yml
			ansible-playbook docker.yml
		cd -
	;;
	clone)
		cd ansible
			ansible-playbook clone.yml
		cd -
	;;
	clone-config)
		cd ansible
			ansible-playbook clone-config.yml
		cd -
	;;
	clone-app)
		cd ansible
			ansible-playbook clone-app.yml
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
		echo [option]
		echo hosts
		echo ping
		echo preconfiure
		echo configure
		echo remove
		echo clone
		echo new
		echo all
		echo app
		echo service
		echo database
		echo view
		echo view-images
		echo stop
		echo delete-containers
		echo delete-images
	;;
esac

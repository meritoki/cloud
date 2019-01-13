#!/bin/bash
. "$(dirname $0)/vars.sh"

VERSION="${2:-$VERSION}"
DOCKER="${3:-$DOCKER}"
HOSTNAME="${3:-localhost}"
case "$1" in
	kill)
		echo killing all node/nodejs processes
		sudo killall nodejs
	;;
	hosts)
		sudo cp ./ansible/hosts /etc/ansible/
	;;
	configure)
		echo running ansible to configure local env
		cd ansible
			ansible-playbook -K local.yml
			ansible-playbook -K docker.yml
		cd -
	;;
	remove)
		echo removing all clone directories
		sudo rm -r config
		sudo rm -r app
		sudo rm -r service
		sudo rm -r auth
		sudo rm -r user
		sudo rm -r id
		sudo rm -r location
		sudo rm -r database
		sudo rm -r msg
	;;
	remove-app)

	;;
	remove-service)

	;;
	remove-database)

	;;
	clone)
		echo cloning repositories from local source
		git clone ~/Workspace/Config/config/.git
		git clone ~/Workspace/Application/app/.git
		git clone ~/Workspace/Service/service/.git
		git clone ~/Workspace/Service/auth/.git
		git clone ~/Workspace/Service/user/.git
		git clone ~/Workspace/Service/id/.git
		git clone ~/Workspace/Service/location/.git
		git clone ~/Workspace/Service/msg/.git
		git clone ~/Workspace/Database/database/.git
	;;
	clone-github)
		echo cloning repositories from github
		git clone https://github.com/meritoki/config.git
		git clone https://github.com/meritoki/auth.git
		git clone https://github.com/meritoki/user.git
		git clone https://github.com/meritoki/id.git
		git clone https://github.com/meritoki/location.git
		git clone https://github.com/meritoki/database.git
		git clone https://github.com/meritoki/app.git
		git clone https://github.com/meritoki/service.git
  	;;
	new)
		echo configuring and installing a new env
		./$0 configure
		./$0 remove
		./$0 clone
		./$0 all
	;;
	all)
		sudo killall nodejs
		./$0 config
		./$0 app
		./$0 service
		./$0 database
	;;
	config)
		cd config
			git stash
			git checkout $VERSION
			git status
			git pull
		cd -
	;;
	app)
		cd app
			echo app
			git checkout $VERSION
			git status
			git pull
			sudo npm install
			cp ../config/local/$HOSTNAME/app/web/properties.js controller/properties.js
			if [ "$DOCKER" = true ]; then
				sudo docker build -t dailybread/app .
				sudo docker run --network host -dlt --restart unless-stopped -p 80:80 dailybread/app
			else
				sudo nodejs index.js &
			fi
		cd -
	;;
	service)
		cd service
			echo service
			git checkout $VERSION
			git status
			git pull
			sudo npm install --no-audit
			cp ../config/local/$HOSTNAME/service/service/properties.js controller/properties.js
			if [ "$DOCKER" = true ] ; then
				sudo docker build -t dailybread/service .
				sudo docker run --network host -dlt --restart unless-stopped -p 8080:8080 dailybread/service
			else
				sudo nodejs index.js &
			fi
		cd -
		./$0 auth
		./$0 user
		./$0 location
		./$0 id
		./$0 msg
	;;
	headless)
		./$0 auth
		./$0 user
		./$0 location
		./$0 id
		./$0 msg
	;;
	auth)
		cd auth
			echo auth
			git checkout $VERSION
			git pull
			sudo npm install --no-audit
			cp ../config/local/$HOSTNAME/service/auth/properties.js controller/properties.js
			if [ "$DOCKER" = true ] ; then
				sudo docker build -t dailybread/auth-service .
				sudo docker run --network host -dlt --restart unless-stopped -p 3000:3000 dailybread/auth-service
			else
				sudo nodejs index.js &
			fi
		cd -
	;;
	user)
		cd user
			echo user
			git checkout $VERSION
			git pull
			sudo npm install --no-audit
			cp ../config/local/$HOSTNAME/service/user/properties.js controller/properties.js
			if [ "$DOCKER" = true ]; then
				sudo docker build -t dailybread/user-service .
				sudo docker run --network host -dlt --restart unless-stopped -p 3001:3001 dailybread/user-service
			else
				sudo nodejs index.js &
			fi
		cd -
	;;
	location)
		cd location
			echo location
			git checkout $VERSION
			git status
			git pull
			sudo npm install --no-audit
			cp ../config/local/$HOSTNAME/service/location/properties.js controller/properties.js
			if [ "$DOCKER" = true ]; then
				sudo docker build -t dailybread/location-service .
				sudo docker run --network host -dlt --restart unless-stopped -p 3002:3002 dailybread/location-service
			else
				sudo nodejs index.js &
			fi
		cd -
	;;
	id)
		cd id
			echo id
			git stash
			git checkout $VERSION
			git status
			git pull
			sudo npm install --no-audit
			cp ../config/local/$HOSTNAME/service/id/properties.js controller/properties.js
			if [ "$DOCKER" = true ]; then
				sudo docker build -t dailybread/id-service .
				sudo docker run --network host -dlt --restart unless-stopped -p 3003:3003 dailybread/id-service
			else
				sudo nodejs index.js &
			fi
		cd -
	;;
	msg)
		cd msg
			echo msg
			git checkout $VERSION
			git pull
			sudo npm install --no-audit
			cp ../config/local/$HOSTNAME/service/msg/properties.js controller/properties.js
			if [ "$DOCKER" = true ]; then
				sudo docker build -t dailybread/msg-service .
				sudo docker run --network host -dlt --restart unless-stopped -p 3003:3003 dailybread/msg-service
			else
				sudo nodejs index.js &
			fi
		cd -
	;;
	database)
		cd database
			echo database
			git checkout $VERSION
			git pull
			sudo ./install.sh new
		cd -
	;;
	view)
		sudo docker container ls
	;;
	view-images)
		sudo docker images
	;;
	stop)
		sudo docker stop $(sudo docker ps -a -q)
	;;
	delete-containers)
		sudo docker rm -f $(sudo docker ps -a -q)
	;;
	delete-images)
		sudo docker rmi -f $(sudo docker images -q)
	;;
	help)
		echo [option] [version=0.1/0.2/dev] [docker=true/false]
		echo kill
		echo ansible
		echo remove
		echo clone
		echo clone-github
		echo new
		echo all
		echo config
		echo app
		echo service
		echo headless
		echo auth
		echo user
		echo location
		echo id
		echo msg
		echo daetabase
		echo view
		echo view-images
		echo stop
		echo delete-containers
		echo delete-images

	;;
esac

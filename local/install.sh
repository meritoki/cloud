#!/bin/bash
. "$(dirname $0)/vars.sh"
sudo cp ./ansible/hosts /etc/ansible/
case "$1" in
	ansible)
		cd ansible
				ansible-playbook -K local.yml
				ansible-playbook -K docker.yml
		cd -
	;;
	remove)
		sudo rm -r config
		sudo rm -r app
		sudo rm -r service
		sudo rm -r auth
		sudo rm -r user
		sudo rm -r id
		sudo rm -r location
		sudo rm -r database
	;;
	clone)
		git clone ~/Workspace/Config/config/.git
		git clone ~/Workspace/Application/app/.git
		git clone ~/Workspace/Service/service/.git
		git clone ~/Workspace/Service/auth/.git
		git clone ~/Workspace/Service/user/.git
		git clone ~/Workspace/Service/id/.git
		git clone ~/Workspace/Service/location/.git
		git clone ~/Workspace/Database/database/.git
	;;
	github)
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
		./$0 ansible
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
			git checkout $VERSION
			git pull
		cd -
	;;
	app)
		cd app
			echo app
			git checkout $VERSION
			git pull
			sudo npm install
			cp ../config/local/app/web/properties.js controller/properties.js
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
			git pull
			sudo npm install
			cp ../config/local/service/service/properties.js controller/properties.js
			if [ "$DOCKER" = true ] ; then
				sudo docker build -t dailybread/service .
				sudo docker run --network host -dlt --restart unless-stopped -p 8080:8080 dailybread/service
			else
				sudo nodejs index.js &
			fi
		cd -
		./$0 app
		./$0 user
		./$0 location
		./$0 id
	;;
	auth)
		cd auth
			echo auth
			git checkout $VERSION
			git pull
			sudo npm install
			cp ../config/local/service/auth/properties.js controller/properties.js
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
			sudo npm install
			cp ../config/local/service/user/properties.js controller/properties.js
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
			git pull
			sudo npm install
			cp ../config/local/service/location/properties.js controller/properties.js
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
			git checkout $VERSION
			git pull
			sudo npm install
			cp ../config/local/service/id/properties.js controller/properties.js
			if [ "$DOCKER" = true ]; then
				sudo docker build -t dailybread/id-service .
				sudo docker run --network host -dlt --restart unless-stopped -p 3003:3003 dailybread/id-service
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
esac

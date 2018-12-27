#!/bin/bash
. "$(dirname $0)/vars.sh"
REMOTE_USERNAME="jorodriguez"
REMOTE_HOSTNAME=192.168.2.32
case "$1" in
	ansible)
		ansible dev -m ping
		ansible-playbook -K dev.yml
		ansible-playbook -K mysql.yml
	;;
	copy-remote)
		  ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME "mkdir -p ~/meritoki/dailybread/cloud"
		  scp -r ./ $REMOTE_USERNAME@$REMOTE_HOSTNAME:~/meritoki/dailybread/cloud
	;;
	all-remote)
		  ssh $REMOTE_USERNAME@$REMOTE_HOSTNAME "cd ~/meritoki/dailybread/cloud/;./install.sh all"
	
	;;
	clone-local)
		git clone ~/Workspace/Config/config/.git
		git clone ~/Workspace/Application/app/.git
		git clone ~/Workspace/Service/service/.git
		git clone ~/Workspace/Service/auth/.git
		git clone ~/Workspace/Service/user/.git
		git clone ~/Workspace/Service/id/.git
		git clone ~/Workspace/Service/location/.git
		git clone ~/Workspace/Database/database/.git
	;;
	clone-remote)
		git clone https://github.com/meritoki/config.git
		git clone https://github.com/meritoki/app.git
		git clone https://github.com/meritoki/service.git
		git clone https://github.com/meritoki/auth.git
		git clone https://github.com/meritoki/user.git
		git clone https://github.com/meritoki/id.git
		git clone https://github.com/meritoki/location.git
		git clone https://github.com/meritoki/database.git
	;;
	clone-remove)
		sudo rm -r config
		sudo rm -r app
		sudo rm -r service
		sudo rm -r auth
		sudo rm -r user
		sudo rm -r id
		sudo rm -r location
		sudo rm -r database
	;;
	new-local)
		./$0 ansible
		./$0 remove
		./$0 clone-local
		./$0 all
	;;
	new-remote)
		./$0 remove
		./$0 clone-remote
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
			sudo docker build -t meritoki/web-application .
			sudo docker run -dlt --restart unless-stopped -p 80:8080 meritoki/web-application
		cd -
	;;
	service)
		cd service
			echo service
			git checkout $VERSION
			git pull
			sudo npm install
			cp ../config/local/service/service/properties.js controller/properties.js
			sudo docker build -t meritoki/web-service .
			sudo docker run -dlt --restart unless-stopped -p 8080:8080 meritoki/web-service
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
			sudo docker build -t meritoki/auth-service .
			sudo docker run -dlt --restart unless-stopped -p 3000:3000 meritoki/auth-service
		cd -
	;;
	user)
		cd user
			echo user
			git checkout $VERSION
			git pull
			sudo npm install
			cp ../config/local/service/user/properties.js controller/properties.js
			sudo docker build -t meritoki/user-service .
			sudo docker run -dlt --restart unless-stopped -p 3001:3001 meritoki/user-service
		cd -
	;;
	location)
		cd location
			echo location
			git checkout $VERSION
			git pull
			sudo npm install
			cp ../config/local/service/location/properties.js controller/properties.js
			sudo docker build -t meritoki/location-service .
			sudo docker run -dlt --restart unless-stopped -p 3002:3002 meritoki/location-service
		cd -
	;;
	id)
		cd id
			echo id
			git checkout $VERSION
			git pull
			sudo npm install
			cp ../config/local/service/id/properties.js controller/properties.js
			sudo docker build -t meritoki/id-service .
			sudo docker run -dlt --restart unless-stopped -p 3003:3003 meritoki/id-service
		cd -
	;;
	database)
		cd database
			echo database
			git checkout $VERSION
			git pull
			./install.sh new

		cd -
	;;
	view)
		sudo docker container ls
	;;
	stop)
		sudo docker stop $(sudo docker ps -a -q)
	;;
	delete-containers)
		sudo docker rm $(sudo docker ps -a -q)
	;;
	delete-images)
		sudo docker rmi $(sudo docker images -q)
	;;
	help)
		echo ansible
		echo clone-local
		echo clone-remote
		echo clone-remove
		
	;;
esac

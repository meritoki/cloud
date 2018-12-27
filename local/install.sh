#!/bin/bash
. "$(dirname $0)/vars.sh"
case "$1" in
	ansible)
		ansible-playbook -K local.yml	
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
			sudo nodejs index.js &
		cd -
	;;
	service)
		cd service
			echo service
			git checkout $VERSION
			git pull
			sudo npm install
			cp ../config/local/service/service/properties.js controller/properties.js
			sudo nodejs index.js &
		cd -

		cd auth
			echo auth
			git checkout $VERSION
			git pull
			sudo npm install
			cp ../config/local/service/auth/properties.js controller/properties.js
			sudo nodejs index.js &
		cd -

		cd user
			echo user
			git checkout $VERSION
			git pull
			sudo npm install
			cp ../config/local/service/user/properties.js controller/properties.js
			sudo nodejs index.js &
		cd -

		cd location
			echo location
			git checkout $VERSION
			git pull
			sudo npm install
			cp ../config/local/service/location/properties.js controller/properties.js
			sudo nodejs index.js &
		cd -

		cd id
			echo id
			git checkout $VERSION
			git pull
			sudo npm install
			cp ../config/local/service/id/properties.js controller/properties.js
			sudo nodejs index.js &
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
esac

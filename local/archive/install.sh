. "$(dirname $0)/vars.sh"
sudo killall nodejs
#ansible-playbook -K local.yml
git clone ~/Workspace/Config/config/.git
git clone ~/Workspace/Service/service/.git
git clone ~/Workspace/Service/auth/.git
git clone ~/Workspace/Service/user/.git
git clone ~/Workspace/Service/id/.git
git clone ~/Workspace/Service/location/.git

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

cd id
echo id
git checkout $VERSION
git pull
sudo npm install
cp ../config/local/service/id/properties.js controller/properties.js
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

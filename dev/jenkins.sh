docker pull jenkins/jenkins


case "$1" in
	start)
    sudo docker run -p 8080:8080 --name=jenkins -d jenkins/jenkins
  ;;
  remove)
    sudo docker rm jenkins
  ;;
esac

#!/bin/bash
USER=$1
HOST=$2
if [ "$#" -eq 2 ]
then
    ssh-keygen -t rsa
    ssh-add ~/.ssh/id_rsa.pub
    cat ~/.ssh/id_rsa.pub | ssh $USER@$HOST "mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && cat >> ~/.ssh/authorized_keys"
    ssh $USER@$HOST
else
echo "requires user host"
exit 1
fi

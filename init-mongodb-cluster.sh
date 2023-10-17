#!/bin/bash
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init-mongodb-cluster.sh                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nabihali <naali@student.42.fr>             +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/10/17 10:30:42 by nabihali          #+#    #+#+#+#+#        #
#                                                                              #
#                                                                              #
# **************************************************************************** #

echo -n "What is the network name ? (default: mongoNet) "
read mongoNet

if [ -z "$mongoNet" ]; then
	mongoNet="mongoNet"
fi

docker network create "$mongoNet"

echo -n "Default name for your container ? (default: mongo) => (Example: mongo1, mongo2, mongo3...) "
read mongo

if [ -z "$mongo" ]; then
	mongo="mongo"
fi

while
	echo -n "How many containers do you want ? (default & minimum: 3) "
	read input
	[ -n "$input" ] && [[ -n ${input//[3-9]/} ]]
do :; done

if [ -z "$input" ]; then
	max=3
else
	max=$((input))
fi

default="ReplicaSet"
replicaSetName="$mongo$default"
setForReplica=""
portStart=27017

for (( i=1; i <= $max; i++ )); do
	echo "$mongo$i in $mongoNet network"
	docker run -d --rm -p $((portStart + i - 1)):27017 --name "$mongo$i" --network "$mongoNet" mongo:latest mongod --replSet "$replicaSetName" --bind_ip localhost,"$mongo$i"
	setForReplica="${setForReplica}{_id: $((i - 1)), host: \"$mongo$i\"}"
	if [ $i -lt $max ]; then
		setForReplica="${setForReplica},
"
	fi
done

docker exec -it "${mongo}1" mongosh --eval "rs.initiate({ _id: \"$replicaSetName\", members: [ $setForReplica ] })"

docker exec -it "${mongo}1" mongosh --eval "rs.status()"

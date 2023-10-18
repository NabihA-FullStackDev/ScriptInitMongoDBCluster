# ScriptInitMongoDBCluster
This is a Script Bash to initialized a small MongoDB cluster using Docker's containers on MacOS

# Requirements
- Docker installed -> or follow the [link](https://docs.docker.com/engine/install/)
- Node installed -> same [here](https://nodejs.org/fr/download)
- MongoDB Shell -> [here](https://www.mongodb.com/docs/mongodb-shell/)

# How to

### Autorisation
```
chmod+x ini-mongodb-cluster.sh`
```

### Execution
```
./init-mongodb-cluster.sh
```
### Then follow the instructions 
1. Give a name to the cluster network
1. Choose a name for every containers that will be created by this script
1. Select the number of mongoDB container you will create (min 3, max 9)
Enjoy, Your Cluster is ready

Note
-
It will always use the latest update for mongo but you can change that easily

line (49,95): mongo:latest by any version you want

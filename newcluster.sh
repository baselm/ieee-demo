#!/bin/bash
eval $(docker-machine env nupic)
docker swarm leave --force 
docker swarm init --advertise-addr 192.168.99.100 --force-new-cluster
ADMIN_USER=admin ADMIN_PASSWORD=admin docker stack deploy -c basic-docker-compose.yml mon3
docker rm $(docker ps -a -q)
docker service ls 
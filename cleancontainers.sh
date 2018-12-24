#!/bin/bash

 
eval $(docker-machine env nupic)
docker rm $(docker ps -a -q)
docker ps
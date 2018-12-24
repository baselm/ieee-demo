#!/bin/bash

 
eval $(docker-machine env nupic)
docker rmi $(docker images -q)
docker images
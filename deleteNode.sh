#!/bin/bash
NodeName=$(docker-machine ls -q --filter label="createdBy=adaptation-manager")
#NodeName=$(docker node ls --format "{{.Hostname}}" -f "role=worker")
echo "${NodeName[0]}"
set -- $NodeName
docker-machine rm -f $1
#echo Hey that\'s a large number. ${#NodeName[@]}
#docker node rm -f  "${NodeName[0]}"
#eval $(docker-machine env nupic)
#docker node rm "${NodeName[0]}"
docker-machine ls 
  
   # or do whatever with individual element of the array

#docker-machine rm -f -y $i
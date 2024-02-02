sudo docker images | grep 32 | awk '{ print "sudo docker rmi " $3 }' | bash 
sudo docker images | grep 5000 | awk '{ print "sudo docker rmi " $3 }' | bash 
sudo docker images | grep none | awk '{ print "sudo docker rmi " $3 }' | bash 
sudo docker system prune -f 
sudo docker volume prune -f 
sudo docker network prune -f 

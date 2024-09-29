
#   Build image with tag my_image ot whatever you want
docker build -t my-node-app .
docker build -t mohamed093/node-app-test .
docker pull php # pull image from docker hub
========================================================
# لو انا عملت اى تغير فى الكود لازم اعمل build تانى ل image علشان يتم تحديث ال image
# build -> run -> stop -> remove -> build -> run
# منساش ان هو بيسيب ال صوره القديمة و بيعمل صوره جديدة فلازم نمسحها بنفسناوبعد كده نبقى نعمل بيلد تانى بعد ما نمسح الكونتينر القديم
========================================================
# to build image with a specific Dockerfile
docker build ./Dockerfile -t my-node-app

# or for simplicity to build 
docker build .

docker ps # list all running containers
docker image ls # list all images 


docker run my-node-app # run image with name my-node-app with no name for container

docker run --name my_container my_image # run image with name my_image with name for container
# for example
docker run --name my-node-app-container my-node-app # run image with name my-node-app with name my-node-app-container  for container 

# best way to run image with name 
# run image with name my-node-app with name my-node-app-container  for container and -d for detached mode that mean the container will run in background
docker run --name my-node-app-container -d my-node-app  
# to run container with specific port(port forward) 
# port forward is used to access the container from the host port(left port) 3000 is the host port and (right port) 4000 is the container port
docker run --name my-node-app-container -d -p 3000:4000 my-node-app


========================================================
# To remove container 
docker rm my-node-app-container -f # -f for force remove
# to stop container
docker stop my-node-app-container
docker restart my-node-app-container

========================================================

# Docker Optimization lec 6 

# to open bash terminal in container
docker exec -it my-node-app-container bash # -it for interactive terminal
docker exec -it 1-nodejs_mongodb-mongo-1 bash
# "exit" to exit from container terminal
ls -d */ # to list all directories in the current directory
ls -d node* # to list all directories that start with node in the current directory

# to avoid copy all files in container we can use .dockerignore file
========================================================
docker logs my-node-app-container # to show logs of container
docker logs my-node-app-container -f # to show logs of container and follow the logs live
docker run --name my-node-app-container -v "E:/0-WEB/Docker/Docker-Practical-Course-in-Arabic/code/node-app:/app" -d -p 3000:4000 my-node-app
# -v for volume to map the host folder to container folder to sync the files between host and container ##### bind mount
# بس دا عامل مشكله ان اى حاجه عندى هتحصل جوا الكونتينر هتتعدل على لوكال  هوست  والعكس صحيح
*******************************************************
docker run --name my-node-app-container -v "E:/0-WEB/Docker/Docker-Practical-Course-in-Arabic/code/node-app:/app:ro" -d -p 3000:4000 my-node-app
# :ro for read only to prevent read from container to myPC  #one way sync
docker run --name my-node-app-container -v "$(PWD):/app:ro" -d -p 3000:4000 my-node-app
# $(PWD) to get the current path
# دا حل مشكله ال sync
#  بين لوكال  هوست  والكونتينر بس فى مشكله تانيه ان مثلا لو مسحت فايل جوا لوكال  هوست  مثلا 
# هيتم مسحه من الكونتينر وده مش منطقى
=======================================================
# Anonymous Volumes 
docker run --name my-node-app-container -v "${PWD}:/app:ro" -v /app/node_modules -d -p 3000:4000 my-node-app

# هنا بنعمل فولدر جديد اسمه النود فايلز وبنحطه فى الكونتينر وبنعمله ريد اونلى وبنعمله بند ماونت ودا بحمى الفولدر من التعديل جوا الكونتنر 
# وبيحمى الفولدر من ال sync
=======================================================
docker run --name my-node-app-container -v "$(PWD)/src:/app/src:ro" -d -p 3000:4000 my-node-app
# هنا بعمل فولدر جديد اسمه src وبعمله ريد اونلى وبعمله بند ماونت وبحمى الفولدر من التعديل جوا الكونتنر
# التعديل هيحصل فقط فى الفولدر src وهيبقى تزامن ما بينه وما بين اللوكال هوست والكونتينر

*************************************************************************
# ########################### Docker Compose ################################
docker-compose up -d # to run the docker-compose.yml file to in detached mode
docker-compose down # to stop the containers in docker-compose.yml file
# image name in docker-compose.yml file is the name of project name_service name for ex node-app_my-node-app

=======================================================

# how to pass environment variables to by using terminal
docker run --name my-node-app-container -v "$(PWD)/src:/app/src:ro" --env PORT=4000 --env NODE_ENV=devlopment -d -p 3000:4000 my-node-app

# to print the environment variables in the container terminal
docker exec -it my-node-app-container bash
printenv

# to pass environment variables by using .env file
docker run --name my-node-app-container -v "$(PWD)/src:/app/src:ro" --env-file ./.env -d -p 3000:4000 my-node-app

    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      # how to pass environment variables to the container in docker-compose file 
    environment:
      - NODE_ENV=production
      - PORT=4000  

      # how to pass environment variables to the container in docker-compose file by using .env file
    env_file:
      - ./.env
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
=============================================================================================================
# lec 11 Docker environment (dev, staging, production)
# tp run 
docker-compose -f docker-compose.dev.yml up -d # to run the docker-compose.dev.yml file to in detached mode
docker-compose -f docker-compose.staging.yml up -d # to run the docker-compose.staging.yml file to in detached mode
docker-compose -f docker-compose.prod.yml up -d # to run the docker-compose.prod.yml file to in detached mode

docker-compose -f docker-compose.dev.yml down  # to stop the containers in docker-compose.dev.yml file
docker-compose -f docker-compose.staging.yml down  # to stop the containers in docker-compose.staging.yml file
docker-compose -f docker-compose.prod.yml down  # to stop the containers in docker-compose.prod.yml file

# if i want to run the docker-compose.yml file with specific environment
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
docker-compose -f docker-compose.yml -f docker-compose.staging.yml up -d 
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
# select the environment file that i want to run with the docker-compose.yml file 
# put the commen variables in the docker-compose.yml file and the specific variables in the specific environment file
# and the specific environment file will override the common variables in the docker-compose.yml file
# and the last file will override the previous file
# the order of the files is important
________________________________________________________________________
docker-compose -f docker-compose.yml -f docker-compose.dev.yml down -v # to remove the volumes with the containers


docker-compose -f docker-compose.yml -f docker-compose.dev.yml down
docker-compose -f docker-compose.yml -f docker-compose.staging.yml down
docker-compose -f docker-compose.yml -f docker-compose.prod.yml down
# to stop the containers in the specific environment file

docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build

# --build to build the image before run the container from the image
=============================================================================================================
docker inspect my-node-app-container # to show the container details

docker network ls # to list all networks
docker network inspect 1-nodejs_mongodb_default # to show the bridge network details
=============================================================================================================
docker volume ls # to list all volumes
docker volume rm my-node-app-container # to remove volume
docker volume prune # to remove all volumes not used by any container


mongosh --username root --password example --port 27017 # to connect to mongodb


===================================== Doker Hub =====================================
docker login # to login to docker hub
docker login -u username -p password # to login to docker hub by using username and password
docker login -u mohamed093 -p Mo@01113245605
docker tag my-node-app username/my-node-app # to tag the image with the username
docker-compose -f docker-compose.yml -f docker-compose.prod.yml push node-app # to push the image to docker hub with the specific name of serivce in the docker-compose file
docker push mohamed093/node-app-test # to push the image to docker hub with the specific name the same commend in the previous commend
# after push the image to docker hub we can pull the image from docker hub by using the following commend
docker pull mohamed093/node-app-test
# or we can use docker compose file to pull the image from docker hub
# and it's check if the image if changed or not and if changed it will pull the new image 
# we don't need to build the image again in the commend it's just to pull the image from docker hub if it's changed
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d 

===================================== cycle from beginning if changed any this in code =====================================
# in the local
docker-compose -f docker-compose.yml -f docker-compose.prod.yml build
docker-compose -f docker-compose.yml -f docker-compose.prod.yml push node-app
# in the server
docker-compose -f docker-compose.yml -f docker-compose.prod.yml pull # to make pull for all services ****** this is resk to make pull for all services
docker-compose -f docker-compose.yml -f docker-compose.prod.yml pull node-app # we can spcify the service name to pull the image for this service only 
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d # this must recreat the container to apply the new image to the container

# when the code is changed we must build the image in local 
# and push it to docker hub and pull it from docker hub in the server and run the container with the new image then restart the container
===================================== load balancer =====================================
# in load balancer we can't use the same port for all the containers or the same container name 
# we must remove the port and container name from the docker-compose file and use the following command to run the containers
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --scale node-app=3
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build --scale node-app=3

===================================== Docker Watch tower  =====================================
# to update the image in the container automatically when the image is changed in the docker hub
# in this commed the watch tower will all containers in the server and check if the image is changed or not and if changed it will pull the new image and run the container with the new image
docker run -d --name watchtower -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
#  but if i need to run the specific container only with the watch tower
docker run -d --name watchtower -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower my-node-app-container

# to enable the trace mode to show the logs of the watch tower and add the poll interval to check the image in the docker hub every 30 seconds 
# we can add the environment variables to the watch tower container from the arrguments link https://containrrr.dev/watchtower/arguments/ 
docker run -d --name  watchtower -e WATCHTOWER_TRACE=true -e WATCHTOWER_POLL_INTERVAL=30 -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower my-node-app-container --debug

# to add the user name and password 
docker run -d --name watchtower -e REPO_USER=username -e REPO_PASS=password -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower node-app  --debug


# in docker-compose file
services:
  watchtower:
    image: containrrr/watchtower
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock      

# to add the user name and password to the docker-compose file
services:
  watchtower:
    image: containrrr/watchtower
    environment:
      - REPO_USER=username
      - REPO_PASS=password
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock


--------------------------------- when cahnge the code ---------------------------------
# to build a new  image in local
docker-compose -f docker-compose.yml -f docker-compose.prod.yml build      
# to push the image to docker hub
docker-compose -f docker-compose.yml -f docker-compose.prod.yml push node-app
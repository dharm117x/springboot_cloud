https://hub.docker.com/repositories/dharm117docker

1. Docker image build command , Note docker should up and ruuning in machine.
mvn spring-boot:build-image

2. Using jIB plugin
-------------------
BUild iamge locally-reuired docker installer locally
mvn compile jib:dockerBuild

Push to repositray: WIthout docker
mvn compile jib:build

<image>docker.io/dharm117docker/${project.artifactId}:${project.version}</image>

docker.io - Host Repos
dharm117docker - Username
${project.artifactId}:${project.version} - Repostiray

2.1 Dcoekr CLI - pull and push from Repos
------------------------------------------
docker pull dharm117docker/springboot-docker:1.0
docker pull --all-tags dharm117docker/springboot-docker

docker login


# Syntax: docker tag <source_image> <username>/<repository>:<tag>
docker tag my-local-image:v1.0 myusername/my-repo:v1.0

docker push dharm117docker/springboot-docker:1.0

3. Docker imaage
------------------
docker images


4. Docker container commands
-----------------------------
docker container ls -a
docker container remove <container_id>
docker container logs <container_id>
docker container stop <container_id>
docker container start <container_id>
docker container remove <container_id>


6. Docker run by compose file
------------------------------
1. Crete docker-compose.yml file
2. docker-compose up -d
3. docker-compose down

EC2- Docekr compose install
------------ ----------------

sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m) -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
docker compose version

sudo ln -s /usr/local/lib/docker/cli-plugins/docker-compose /usr/bin/docker-compose
docker-compose --version


EC2-RDS: MysQL database connection commands
-------------------------------------------
mysql -h <host>.rds.amazonaws.com -u admin -p

show databses;
create database app_db;
use app_db;
drop database app_db;

mkdir -p /home/ec2-user/app-logs
chmod -R 777 /home/ec2-user/app-logs

docker run -d \
  --name my-app \
  -v /home/ec2-user/app-logs:/app/logs \
  -p 9001:9001 \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://<Host>.rds.amazonaws.com:3306/app_db \
  -e SPRING_DATASOURCE_USERNAME=user \
  -e SPRING_DATASOURCE_PASSWORD=***** \
  dharm117docker/springboot:1.1

Docker Commands:
-----------------
docker build -t my-ecr-repo:latest . : Build a Docker image from the current directory (where the Dockerfile is located) and tag it as "my-ecr-repo:latest".

docker tag my-ecr-repo:latest <ACC_NO>.dkr.ecr.us-east-1.amazonaws.com/my-ecr-repo:latest : Tag the local image with the ECR repository URI so it can be pushed to ECR.
docker push <ACC_NO>.dkr.ecr.us-east-1.amazonaws.com/my-ecr-repo:latest : Push the tagged image to your ECR repository in AWS.
docker pull <ACC_NO>.dkr.ecr.us-east-1.amazonaws.com/my-ecr-repo:latest : Pull the image from ECR to your local machine.
docker rmi <ACC_NO>.dkr.ecr.us-east-1.amazonaws.com/my-ecr-repo:latest  : Remove the local copy of the image after pushing to ECR to free up space.

docker images: List all local Docker images.
docker ps: List all running Docker containers.
docker ps -a: List all Docker containers (including stopped ones).
docker stop container_id: Stop a running container.
docker rm container_id: Remove a stopped container.
docker rmi image_id: Remove a Docker image from local storage.
docker logs container_id: View logs from a running container.
docker exec -it container_id bash: Access the shell of a running container for debugging or management.
docker run --env VAR_NAME=value -v host_dir:container_dir -d -p host_port:container_port --name container_name image_name:tag: 
---Run a new container with multiple options, including setting environment variables, mounting volumes, running in detached mode, mapping ports, and assigning a name to the container.

docker run --network network_name image_name:tag: Run a new container and connect it to a specific Docker network for inter-container communication.
docker run --name container_name --restart unless-stopped image_name:tag: Run a new container with a specific name and set it to automatically restart unless it is explicitly stopped, ensuring high availability for critical services.
docker run --name container_name --cpus="1.5" image_name:tag: Run a new container with a specific name and limit its CPU usage to 1.5 cores to manage resource allocation on the host machine.
docker run --name container_name --memory="512m" image_name:tag: Run a new container with a specific name and limit its memory usage to 512 megabytes to prevent it from consuming too much memory on the host machine.


Docekr-Compose Commands:
-------------------------
docker-compose up: Start all services defined in a docker-compose.yml file.
docker-compose down: Stop and remove all services defined in a docker-compose.yml file.
docker-compose logs: View logs from all services defined in a docker-compose.yml file.
docker-compose build: Build or rebuild services defined in a docker-compose.yml file.
docker-compose ps: List the status of all services defined in a docker-compose.yml file.
docker-compose exec service_name bash: Access the shell of a running service defined in a docker-compose.yml file.




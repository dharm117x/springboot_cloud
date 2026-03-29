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


3. RDS: MysQL database connection commands
-------------------------------------------
mysql -h <host>.rds.amazonaws.com -u admin -p

show databses;
create database app_db;
use app_db;
drop database app_db;

4. Docker container commands
-----------------------------
docker container ls -a
docker container remove <container_id>
docker container logs <container_id>
docker container stop <container_id>
docker container start <container_id>
docker container remove <container_id>


docker run -d \
  --name my-app \
  -p 9001:9001 \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://<Host>.rds.amazonaws.com:3306/app_db \
  -e SPRING_DATASOURCE_USERNAME=user \
  -e SPRING_DATASOURCE_PASSWORD=***** \
  dharm117docker/springboot:1.1


5. Docekr compose install on ec2
------------ ----
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m) -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
docker compose version

sudo ln -s /usr/local/lib/docker/cli-plugins/docker-compose /usr/bin/docker-compose
docker-compose --version

6. Docker run by compose file
------------------------------
1. Crete docker-compose.yml file
2. docker-compose up -d
3. docker-compose down




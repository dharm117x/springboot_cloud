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





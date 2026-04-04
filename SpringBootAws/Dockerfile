# Use a lightweight Java 17 runtime as the base image
FROM eclipse-temurin:17-jre-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from your target folder to the container
COPY target/*.jar app.jar

# Expose the port your Spring Boot app runs on (default 8080)
EXPOSE 9001

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

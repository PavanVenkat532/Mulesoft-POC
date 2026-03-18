# Stage 1: Build (The "Kitchen")
FROM maven:3.8-openjdk-11 AS build
COPY . /usr/src/app
WORKDIR /usr/src/app
# This runs your Maven build inside OpenShift
RUN mvn clean package -DskipTests || exit 1 

# Use a specific wildcard to avoid picking up the wrong, smaller JAR
COPY --from=build /usr/src/app/target/*-mule-application.jar /deployments/app.jar
# Add this line to verify the file exists and has size during the BUILD logs
RUN ls -lh /deployments/app.jar
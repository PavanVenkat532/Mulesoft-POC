# Stage 1: Build (USE THIS IMAGE)
FROM maven:3.8.6-openjdk-11 AS build
WORKDIR /usr/src/app
COPY . .
# Now this command will work!
RUN mvn clean package -DskipTests || exit 1

# Stage 2: Run
FROM default-route-openshift-image-registry.apps.rm2.thpm.p1.openshiftapps.com/openshift/java-runtime:openjdk-11-ubi8

WORKDIR /deployments

# DO NOT USE *.jar. Use the specific '-mule-application.jar' suffix
COPY --from=build /usr/src/app/target/*-mule-application.jar /deployments/app.jar

# Add this line to verify the file size DURING the build logs
RUN ls -lh /deployments/app.jar

EXPOSE 8081
CMD ["java", "-jar", "/deployments/app.jar"]
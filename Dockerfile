# Stage 1: Build (The "Kitchen")
FROM maven:3.8-openjdk-11 AS build
COPY . /usr/src/app
WORKDIR /usr/src/app
# This runs your Maven build inside OpenShift
RUN mvn clean package -DskipTests

# Stage 2: Run
FROM default-route-openshift-image-registry.apps.rm2.thpm.p1.openshiftapps.com/openshift/java-runtime:openjdk-11-ubi8
# This ensures we get the heavy 'mule-application' JAR, not the light one
COPY --from=build /usr/src/app/target/*-mule-application.jar /deployments/app.jar
CMD ["java", "-jar", "/deployments/app.jar"]
FROM eclipse-temurin:21-jdk

WORKDIR /app

LABEL maintainer="javaguides-net"

COPY target/hello-world-service-0.0.1-SNAPSHOT.jar hello-world-service.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "hello-world-service.jar"]

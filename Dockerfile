FROM maven:3.8.6-jdk-11 AS build
WORKDIR /app
ADD ./spring-boot-with-metrics ./
RUN mvn package

FROM openjdk:11-slim-buster
WORKDIR /app
COPY --from=build /app/target/*.jar ./SNAPSHOT.jar
CMD ["java", "-jar", "./SNAPSHOT.jar"]
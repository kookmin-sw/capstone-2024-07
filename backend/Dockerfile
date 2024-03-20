FROM openjdk:17-jdk-slim as builder

COPY ./ ./

RUN chmod +x ./gradlew

RUN ./gradlew bootJar


FROM openjdk:17-jdk-slim

WORKDIR /app

COPY --from=builder ./build/libs/*.jar ./server.jar

ENTRYPOINT ["java","-Dspring.profiles.active=dev","-jar","./server.jar"]


FROM amazoncorretto:17-alpine-jdk

ARG JAR_FILE=build/libs/backend-0.0.1-SNAPSHOT.jar

ADD ${JAR_FILE} backend.jar

ENV TZ=Asia/Seoul

ENTRYPOINT ["java", "-jar","-Dspring.profiles.active=prod","/backend.jar"]

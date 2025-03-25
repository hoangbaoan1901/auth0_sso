FROM amazoncorretto:17-al2023-jdk
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} app.jar
EXPOSE 3000
ENTRYPOINT ["java","-jar","/app.jar"]
FROM maven:3.8.4-openjdk-11-slim
WORKDIR /app
COPY . /app/
RUN mvn compile
CMD ["java", "-cp", "target/classes", "HelloWorld"]

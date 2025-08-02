# Stage 1: Build stage (uses Maven)
FROM maven:3.9.4-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Package the application
RUN mvn clean package -DskipTests -Dmaven.test.skip=true

# Stage 2: Run stage (uses JRE)
FROM eclipse-temurin:17-jre

# Set working directory in container
WORKDIR /app

# Copy jar file from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port (default Spring Boot port)
EXPOSE 8080

# Set environment variable (optional)
ENV JAVA_OPTS=""

# Run application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]

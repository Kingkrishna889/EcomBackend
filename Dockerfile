# Stage 1: Build the Spring Boot application
FROM eclipse-temurin:17-jdk-focal AS builder

WORKDIR /app

# Maven wrapper files copy
COPY mvnw .
COPY .mvn .mvn

# pom.xml copy
COPY pom.xml .

# source code copy
COPY src src

# Maven wrapper executable
RUN chmod +x mvnw

# Build jar
RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-focal

WORKDIR /app

# Copy generated jar from target folder
COPY --from=builder /app/target/*.jar app.jar

# Render dynamic port
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]

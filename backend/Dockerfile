FROM maven:3.9.11-eclipse-temurin-17 AS build

WORKDIR /app

COPY pom.xml ./
COPY ai-agent-api/pom.xml ai-agent-api/
COPY ai-agent-app/pom.xml ai-agent-app/
COPY ai-agent-domain/pom.xml ai-agent-domain/
COPY ai-agent-trigger/pom.xml ai-agent-trigger/
COPY ai-agent-infrastructure/pom.xml ai-agent-infrastructure/
COPY ai-agent-types/pom.xml ai-agent-types/

COPY ai-agent-api/src ai-agent-api/src
COPY ai-agent-app/src ai-agent-app/src
COPY ai-agent-domain/src ai-agent-domain/src
COPY ai-agent-trigger/src ai-agent-trigger/src
COPY ai-agent-infrastructure/src ai-agent-infrastructure/src
COPY ai-agent-types/src ai-agent-types/src

RUN mvn -pl ai-agent-app -am -DskipTests clean package

FROM eclipse-temurin:17-jre

WORKDIR /app

ENV TZ=Asia/Shanghai

COPY --from=build /app/ai-agent-app/target/ai-agent-app.jar /app/ai-agent-app.jar

EXPOSE 8066

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/ai-agent-app.jar"]

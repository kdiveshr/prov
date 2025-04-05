# prv api

This project represents the CodeTypeService microservice. It is written using the Java and Spring.
The api is 
[fully documented](http://localhost:8080/divesh-api/api/swagger-ui/index.html) 
using the OpenAPI 3.0 specification.

## Getting Started

1. Clone the repository and go to project folder
```
git clone https://prod-cicm.prv.pov/gitlab/madrid/divesh-api.git
cd divesh-api
```

2. Run the main project
```
cd main
mvn clean install spring-boot:run
```

<!--3. Build docker image: 
```
docker build ./ -t divesh-api
```

4. Run docker image
```
docker run -p 8080:8080 sample
```
-->
# Project structure

```
api                                 common DTOs used by both main Service and Client SDK
client                              client sdk to communicate with this service
devops                              CI/CD & IaC Terraform tooling to provision application
main                                main spring api application
|_ src/                                         project source code
|  |-main/java/pov.prv.divesh.api.codetypeservice   app components
|  |  |- common/                                configuration classes
|  |  |- config/                                configuration classes
|  |  |- controller/                            endpoint controllers
|  |  |- dao/                                   data access object repositories
|  |  |- entity/                                database class representations
|  |  |- repository/                            business logic classes
|  |  |- service/                               business logic classes
|  |  |- util/                                  business logic classes
|  |  |- CodeTypeServiceApplication.java       Entry point into application
|  |- resources/                                   configuration files, etc
|  |- test/                                        project tests
|  |  |- java/pov.prv.divesh.api.codetypeservice                        app component tests
|  |- config/                                   configuration class tests
|  |- controller/                               endpoint controller tests
|  |- dao/                                      data access object repository tests
|  |- service/                                  business logic class tests
|  |- BaseIntegrationTest.java                  entry point into integration tests and configuration
|  |- SecurityContextUtil.java                  utility class for setting authentication and authorization
|- resources/                                   configuration files, etc
pom.xml                                         project object model

/test
|_ src/
|- test/                                        
pom.xml                                         project object model for solution
sonar.properties                                static analysis server configuration
```

#### Tools

Development, build and quality processes are based on [Spring](https://spring.io) and
[Maven](https://maven.apache.org/download.cgi)

#### Libraries

* [Java 11](https://docs.oracle.com/en/java/javase/11/)
* [Spring Boot](https://spring.io/projects/spring-boot)
* [Spring Data JPA](https://spring.io/projects/spring-data-jpa)
* [Spring Security](https://spring.io/projects/spring-security)

## Running

The main entry point into the application is pov.prv.divesh.api.codetypeservice.CodeTypeServiceApplication. It immediately
calls into the normal spring application runner. All arguments are passed directly into the spring runner and are never
touched directly by our underlying code.

## Automated Testing

### Unit Testing
Unit testing is handled with [JUnit](https://junit.org/junit4/) and supported by [Mockito](https://github.com/mockito/mockito)

Run tests from the root with `mvn clean test`.

Run tests with coverage `mvn clean verify`. 

### Integration Testing
Integration testing is run with the maven failsafe plugin. 

Test files must be named with `<file>IT.java` for the plugin to run them. 

Run tests from the root with `mvn clean integration-test`.

# Commands to know
# to build: docker build -t myapp . where "myapp" can be any name.
# to jump in final container: docker run -it myapp /bin/bash/
# to loginto inside final container: docker run -it myapp /bin/bash/
# to run image: docker run -p 8080:8080 myapp
# to view deployment http://localhost:8080

# Go to Nexus and Update to the latest HARD version prior to releasing code
# https://prod-cicm.prv.pov/nexus3/#browse/browse:docker-baseline:v2%2Fecc%2Foci%2Fprv-custom-amzcorretto-21%2Ftags
FROM prod-cicm.prv.pov:9998/ecc/oci/prv-custom-amzcorretto-21:latest

# This will add the OTEL agent jar file for integrating with CloudWatch Application Signals.
COPY --from=prod-cicm.prv.pov:9996/aws-observability/adot-autoinstrumentation-java:v2.0.0 /javaagent.jar /otel-auto-instrumentation/javaagent.jar

# In your terraform.tfvars file make sure you update service_container_env_vars JAVA_TOOL_OPTIONS to include the instana agent: -javaagent:/instana/instana-fargate-collector.jar

# Patch your image with latest updates
RUN yum update -y \
  && yum clean all

# yum update can sometimes delete prv ca certs ... so you need to run this to re-add the prv certs
# NOTE: the following command changes based on your JDK. In this example, it's JDK 21
RUN keytool -importkeystore -srckeystore /certs/prv-cacerts -srcstorepass changeit -destkeystore /lib/jvm/java-21-amazon-corretto/lib/security/cacerts -deststorepass changeit -noprompt

VOLUME /tmp
ARG JAR_FILE=target/divesh-api-main-*-runnable.jar
COPY ${JAR_FILE} app.jar
COPY entrypoint.sh entrypoint.sh


# In the container, run cat /etc/passwd you'll see a list of         #
# existing users. The nobody user should have the least permissions. #
USER nobody

ENTRYPOINT ["bash", "entrypoint.sh"]

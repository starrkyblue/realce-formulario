FROM 070073855891.dkr.ecr.us-east-1.amazonaws.com/bdb-java8-oracle-alpine:1.0
MAINTAINER BdB <gmorris@bancodebogota.com.co>
ARG BDB_ENV
ARG BDB_AWS_ACCESS_KEY_ID
ARG BDB_AWS_SECRET_ACCESS_KEY
ARG BDB_AWS_ACCOUNT_ID
ARG BDB_SECRETS_FILE_ENV
ARG BDB_SECRETS_FILES_COUNT_ENV
VOLUME /tmp
ADD target/app.jar app.jar
RUN bash -c 'touch /app.jar'

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]


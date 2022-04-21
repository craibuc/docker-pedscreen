ARG OPENJDK_TAG=11

FROM sbt:latest AS build

ARG ACCOUNT=account
ARG TOKEN=token
ARG BRANCH=branch

ARG URI="https://$ACCOUNT:$TOKEN@github.com/chop-dbhi/ped-screen"

WORKDIR /source

# copy source to image
RUN git clone $URI -b $BRANCH .

COPY ./*.properties ./conf/local

# create "fat" .JAR file
RUN sbt assembly

#
# final image
#

FROM openjdk:${OPENJDK_TAG}

WORKDIR /app

# configuration files
COPY --from=build ./source/conf/local/*.properties ./conf/local/
# SQL files
COPY --from=build ./source/sql ./sql
# application (rename to remove version)
COPY --from=build ./source/target/scala*/pedscreen*.jar ./pedscreen.jar
# COPY --from=build ./source/target/scala-$SCALA_VERSION/pedscreen-$PEDSCREEN_VERSION.jar ./pedscreen.jar

# default executable and parameters that can't be modified by docker run
ENTRYPOINT ["java","-jar","pedscreen.jar","pedscreen","--pecarn"]

# added to ENTRYPOINT command; can be modified by docker run
CMD ["--list_params"]

# java -jar pedscreen.jar pedscreen --pecarn --list_params

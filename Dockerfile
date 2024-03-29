ARG OPENJDK_TAG=11.0.13
ARG SBT_TAG=latest

FROM mozilla/sbt:${SBT_TAG} AS build

# build arguments that must be supplied during the build, as environment variables
ARG REPO_URI="https://github.com/chop-dbhi/ped-screen"
ARG APP_VERSION=1.2
ARG GITHUB_BRANCH=main

WORKDIR /source

# clone the remote repository's branch to /source
RUN git clone $REPO_URI -b $GITHUB_BRANCH .

# copy local settings files
COPY ./conf/*.properties ./conf/local/

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

# default executable and parameters that can't be modified by docker run
ENTRYPOINT ["java","-jar","pedscreen.jar","pedscreen","--pecarn"]

# added to ENTRYPOINT command; can be modified by docker run
CMD ["--list_params"]

# java -jar pedscreen.jar pedscreen --pecarn --list_params

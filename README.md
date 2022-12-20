# docker-pedscreen
A Docker container for the ped-screen application.

## Configuration
One-time configuration tasks to be completed.

> NOTE: unless otherwise indicated, the Bash commands should be executed in the project's root folder (`$`).

### Github
#### Create the environment variables

Create environment variables to access the ped-screen's project on Github.

> NOTE: this could be added to `.bashrc` or `.profile`.

```bash
export GITHUB_ACCOUNT=<github account>
export GITHUB_TOKEN=<github personal-access token (PAT)>
export GITHUB_BRANCH=<github branch name>
```
### Pedscreen

#### Create the environment file
This file contains the environment variables that are supplied to docker when the `pedscreen` container is run.

- Copy `.env.sample` to `.env`

```bash
$ cd .pedscreen
$ .pedscreen> cp .env.sample .env
```

- Edit the file and supply the missing values

### Postgres

#### Create the environment file
This file contains the environment variables that are supplied to docker when the `postgres` container is run.

- Copy `.env.sample` to `.env`

```bash
$ cd .postgres
$ .postgres> cp .env.sample .env
```

- Edit the file and supply the missing values

### Docker Compose

#### Create the docker-compose.yaml

```bash
$ cp docker-compose.sample.yaml docker-compose.yaml
```

Modify the contents of the file to meet your needs.

#### Create a symbolic link for postgres' environment file

```bash
$ ln -s .postgres/.env .env
```

## Build
The image can be built using `docker` or `docker compose`.  The later is preferred.

### docker
Creates the pedscreen image, using the supplied arguments.

```bash
$ docker build \
	--build-arg REPO_URI="https://$(GITHUB_ACCOUNT):$(GITHUB_TOKEN)@github.com/chop-dbhi/ped-screen" \
	--build-arg BRANCH=$(BRANCH) \
	--tag pedscreen:latest \
	.
```

### docker compose
It is easier, however, to use docker-compose to build the ped-screen image.  The build settings are contained in the `docker-comfig.yaml` file.

```bash
$ docker compose build
```

## Run

Because the `pedscreen` application depends on an instance of `postgres`, it is recommend to use `docker compose` to run the containers.  By using `docker compose`, an application/database container pair will be created for each location (3 pairs in the default configuration).

#### Export the date ranges as environment variables

```bash
$ export DATE_START=2021-03-01
$ export DATE_END=2021-03-31
```

### start all containers

```bash
$ docker-compose up -d
```

> NOTE: `docker compose` will automatically use the `.env` file in the project's root.  **Ensure that the `.env` symbolic link references `.postgres/.env`.**

### monitor the logs, optionally supplying the name of the service to filter the logs

```bash
$ docker-compose logs -f [database|app]
```

### stop and remove all containers and network

```bash
$ docker-compose down
```

## References

- [ped-screen source](https://github.com/chop-dbhi/ped-screen)
- [docker-sbt](https://github.com/craibuc/docker-sbt)
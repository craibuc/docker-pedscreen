# docker-pedscreen
A Docker container for the ped-screen application.

## Usage

### Build

#### Export environment variables
> NOTE: this could be added to `.bashrc` or `.profile`.

```bash
export GITHUB_ACCOUNT=<github account>
export GITHUB_TOKEN=<github personal-access token (PAT)>
export BRANCH=<github branch name>
```

#### Build the image
```bash
$ docker build \
	--build-arg REPO_URI="https://$(GITHUB_ACCOUNT):$(GITHUB_TOKEN)@github.com/chop-dbhi/ped-screen" \
	--build-arg BRANCH=$(BRANCH) \
	--tag pedscreen:latest \
	.
```

### Run

#### Create the environment file
This file contains the environment variables that are supplied to docker when the container is run.

- Copy `.env.sample` to `.env`
```bash
$ cp .env.sample .env
```
- Edit the file and supply the missing values

#### Run container and display ped-screen's parameters
```bash
$ docker run --rm --env-file=.env pedscreen:latest
```

#### Run container and generate the extract

```bash
$ docker run --rm --env-file=.env pedscreen:latest --location_id ABCD --department_id 123456 --date_start 2019-03-31 --date_end 2019-03-31
```

## Make
Use `make` to simplify the build/run process; the project contains a sample `makefile`.

### Build the image
```bash
$ make build
```

### Run container and create a terminal session
```bash
$ make tty
```

### Run container and display ped-screen's parameters
```bash
$ make param
```

### Run container and generate files
```bash
$ make run
```

## References

- [ped-screen source](https://github.com/chop-dbhi/ped-screen)
- [docker-sbt](https://github.com/craibuc/docker-sbt)
# docker-pedscreen
A Docker container for the ped-screen application.

## Prepare

### Export environment variable for the build task
```bash
export ACCOUNT=<github account>
export TOKEN=<github personal-access token (PAT)>
export BRANCH=<github branch name>
```

### Create the environment file for the run task
- Copy `.env.sample` to `.env`
```bash
$ cp .env.sample .env
```
- Edit the file and supply the missing values


## Usage

### build the image
```bash
$ docker build \
	--build-arg ACCOUNT=$(ACCOUNT) \
	--build-arg TOKEN=$(TOKEN) \
	--build-arg BRANCH=$(BRANCH) \
	--tag pedscreen:latest \
	.
```

### run container and display ped-screen's parameters
```bash
$ docker run --rm --env-file=.env pedscreen:latest
```

### run container and display ped-screen's parameters
```bash
$ docker run --rm --env-file=.env pedscreen:latest --department_id 123456 --site_id ABCD --date_start 2019-03-31 --date_end 2019-03-31
```
## Make
Use `make` to simplify the build/run process.

### build the image
```bash
$ make build
```

### run container and start terminal
```bash
$ make tty
```

### run container and display ped-screen's parameters
```bash
$ make run
```

## References

- [ped-screen source](https://github.com/chop-dbhi/ped-screen)
- [docker-sbt](https://github.com/craibuc/docker-sbt)
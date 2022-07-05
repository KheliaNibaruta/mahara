# Mahara Docker

This directory contains tools for standing up Mahara using Docker for
**development** purposes.

If you would like to use this Docker environment in production, please be aware that you will need to change the Docker compose files and make configuration changes, e.g. passwords, email configuration, caching.

## tl;dr;

This assumes that you've gone through the initial setup steps already.

1. Clone Mahara.
2. Run `make up` from the repo root directory.

To indicate what version you want set the DOCKER_PHP_MAJOR_VERSION to
the value you want, eg for PHP 8.0 development run `export DOCKER_PHP_MAJOR_VERSION=8 && make up`.

Valid options, which specify what PHP version you want, are 8.1, 8, 7.4 and if no value is specified it will default to PHP 7.2

## The details

Docker is a great way to develop for and try out Mahara without needing to
install dependencies yourself.

The instructions have been tested on Ubuntu 18.04 and 20.04. If you use an
older version of Ubuntu, a different flavour of Linux, or use your Docker setup
on another operating system, some instructions may not work the same way.

The commands here are to be run in a terminal.

### Set up Docker

You can get the most recent version of Docker from the [official Docker website](https://docs.docker.com/get-docker).

Please follow the generic Docker instructions there to make it possible to run without 'sudo'.

Once you have done that, run:
```bash
docker run ubuntu echo "Yes, I have Docker."
```

If you have Docker configured, the last line of the output will state:
> "Yes, I have Docker."

In order to use the Docker compose files, install Docker compose. Follow the [installation instructions](https://docs.docker.com/compose/install).

To test that Docker compose is working run `docker-compose --version`.

The version output should be greater than 1.28.

The following scripts and Docker commands can read a lot of config
variables from the environment.

If there are settings that you always want to make, set them as environment
variables. For example, `export MAHARA_DOCKER_PORT=6142` will set the http
port of the `mahara` Docker container to http://localhost:6142.

> See `./docker/.env-dist` for the list of configurable environment variables.

Using a tool such as [Direnv](https://direnv.net/) can make this even easier
because you can define the variables persistently.

For example, for both local development and running PHPUnit or Behat tests, you
can use an environment variables file to store all necessary config settings
instead of putting them into `config.php` itself.

> By default this is copied from `./htdocs/config-environment.php` when using `make up` if it does not already exist.

**Note**: Instead of putting values into `config-environment.php`, or `./htdocs/config.php`, you can set up a local `.envrc` file to contain your custom variables as that will not be added to the repository when you commit changes, allowing you to keep passwords more secure. It is excluded from being pushed to a Git repository in `.gitignore`.

### Get the Mahara Docker image

Download the Mahara codebase to use the Docker image. If you work with Git, we
recommend you do that via `git clone`:

* From the official Mahara repository: `git clone https://git.mahara.org/mahara/mahara.git`
* From GitHub: `git clone https://github.com/MaharaProject/mahara.git`
* Docker Hub: There is no Docker image available on Docker Hub. Instead, you build your own image.

The Mahara Docker image contains the dependencies required for building and
testing Mahara, including generating CSS, PHPUnit and Behat tests.

### Start up a new development environment

In order to allow Docker to have access to and set various Mahara environment variables, a `docker/.env` file is used to set Mahara specific variables.

> By default this is copied from `docker/.env-dist` when using `make up` if it does not already exist.

If your development environment is available on any network, you should change the following:
* MAHARA_URL_SECRET: Set a string as the cron requires it to work correctly.
* MAHARA_PASSWORD_SALT_MAIN: Set a string.

If this is your first time running Mahara with Docker, you will need to run
`make docker-image` to build the Mahara Docker image. This will create a Docker
image with Apache, PHP, other dependencies, and of course Mahara.

**Note**: Add Gerrit so you can `make push` later if you want to [contribute your changes](https://wiki.mahara.org/wiki/Developer_Area/Contributing_Code) to the Mahara project.

* Run the command `make up` to start your Mahara Docker environment. This configures your environment automatically.
* Open the URL that you see on screen. It starts with http://localhost:6142/. Mahara is available in a subdirectory, and the name of it is the name of the folder of your repository. If you installed Mahara in the folder 'mahara', then the URL is http://localhost:6142/mahara/ (the slash is important or you won't see your site). If you installed it in the folder '20.10', the URL is http://localhost:6142/20.10/.

> **Note**: if you work with PHP 7 and PHP 8 at the same time, you can start a second environment on the same codebase for the other version. Assuming your config is set to PHP 7, you can start a PHP 8 environment by specifying the `DOCKER_PHP_MAJOR_VERSION` variable on the command line:
>
> `DOCKER_PHP_MAJOR_VERSION=8 make up`
>
> When starting this way, you need to specify this again when shutting down:
>
> `DOCKER_PHP_MAJOR_VERSION=8 make down`

Because the code is not part of the Docker image but is available on your computer, the CSS needs to be built outside of Docker. Follow the ['Set up npm and gulp' instructions](https://wiki.mahara.org/index.php/Developer_Area/Developer_Environment) on the Mahara wiki to set that up. Then run `make css` to build the CSS.

### Useful commands

* List running containers: `docker ps`
* View logs for a container: `docker logs <container name>`
* Run CLI commands inside of a container: `make docker-bash`

**Note**: Site-specific containers are prefixed with the name of the directory of your site, followed by 'mahara', e.g. 'mahara-mahara' or '22.04-mahara' for repositories in the directories 'mahara' and '22.04' respectively. Shared containers are prefixed 'shared-mahara'.

### Shut down the environment

From the site directory in your terminal, type `make down`. That will shut down
all containers unique to this site. Shared containers are not shut down, e.g.
if you run multiple Docker images in parallel.

If you type `docker ps` again, you will see the shared containers that are not
shut down by `make down`. All shared containers for Mahara are prefixed 'shared-mahara'.

At the moment, the only two shared containers are `mailhog` and `nginx`. If
these are the only two remaining ones, you can shut them down with `make shared-down`.

If you started the environment with `DOCKER_PHP_MAJOR_VERSION`, this will need
to be specified again when shutting down (see the sections 'Start up a new development environment' and 'Use PHP 8 for development').

### Refresh the image

We recommend you refresh your Mahara Docker image periodically (every week or
two) to refresh the image with any security patches from its base image, which
includes the operating system. Run `make docker-image`.

### Use PHP 8 persistently ###

To use PHP 8 instead of PHP 7, use the following command to set the variable
DOCKER_PHP_MAJOR_VERSION. This will change all subsequent Docker related make
commands to work on the PHP 8 containers, and you don't have to specify the PHP version when starting up and shutting down your environment.

```bash
export DOCKER_PHP_MAJOR_VERSION = 8
make docker-image
make up
make down
```

When you use PHP 8, the container will deploy to a different location.

For example: http://localhost:6142/mahara/ will be available on
http://localhost:6142/mahara-8/ instead.

It is possible to build a PHP 7 and a PHP 8 site from the same directory. See
section 'Start up a new development environment'.

### Set up mail

Mail is delivered to a local mail server called [Mailhog](https://github.com/mailhog/MailHog). The server is shared between all your development sites.

**This mail server within Docker will not forward any email to a real mail server.**
Instead, it will keep all mail output and present it at http://localhost:8025.
That means that you do not have to configure the config.php variable
'sendallemailto' because mails will not be sent to any address.

### Delete a database or sitedata volume for a site

During development you may wish to delete the database and or sitedata in order
to start again from a fresh instance.

1. Shut down your site: `make down`.
1. List the volumes: `docker volume ls`. You see a list of volume names,
including volumes with the names <Foldername>_mahara-db and <Foldername>_mahara-data.
1. Delete the database volume with `docker volume rm <foldername>_mahara-db` or
delete the sitedata volume with `docker volume rm <foldername>_mahara-data`.

When you run `make up`, new volumes will be created automatically to replace
the ones you had removed, providing you with a fresh instance.

### Refresh and restore a database

These commands are for wiping an existing database and restoring a database
from a backup file:

* `make docker-database-refresh`: Deletes the current database and creates an empty one.
* `dbpath="/example/database/path.pg" make docker-database-restore`: Restores a database from a database file that you specified in the path. Your previous database will be deleted.

### Connect to the database

1. Run `docker ps` to list the running containers.
2. Get the container ID and port number of the PostreSQL container.
3. Run `docker exec -it <container id> /bin/bash` to enter the container.
4. Run `psql -h 127.0.0.1 -U mahara -W -p 5432 mahara` to connect to the Mahara database. You will be asked for the password. It is stated in the config.php file.

If you fail to connect at this point, check your `.env` file for the correct value in the `MAHARA_DB_*` value. If you don't have an `.env` file, check in the `config-environment.php` file.

5. Run SQL queries.

If you fail to connect at this point, check your `.env` file for the correct
value in the `MAHARA_DB_*` value. If you don't have an `.env` file, check in
the `config-environment.php` file.

### Run automated tests

To run PHPUnit and Behat tests, a different image is required. You can get it
by running `make docker-builder`.

**Note**: Running PHPUnit and Behat tests via Docker is in the beginning stages
and not everything may work. We keep the instructions in here though.

The base command to generate tests (and CSS) is:

`./docker/make.sh <target>`

Available `make` commands are:

* `./docker/make.sh css` to generate css
* `./docker/make.sh phpunit` to run PHPUnit tests
* `./docker/make.sh behat` to run the Behat test suite.
* `./docker/make.sh -e BEHAT_TESTS=change_account_settings.feature behat`
to run only the specified test feature file
* `./docker/make.sh -e BEHAT_MODE=rundebug -e BEHAT_TESTS=change_account_settings.feature behat`
to run only the specified test feature file, watching the browser execute the test.

The Mahara wiki contains more information on [Behat testing](https://wiki.mahara.org/wiki/Testing_Area/Behat_Testing).

The PHPUnit and Behat 'targets' need a database. You can start and stop a test
Docker database with these commands:

1. `docker/test-db.sh start` to start a test database
1. Run your tests.
1. `docker/test-db.sh stop` to stop a test database

To access the database with psql, run `docker/test-db.sh psql`.

<!--- # #################################################
# CONTRIBUTOR; WARNING
# This file is generated by the /update script. 
# Don't edit it directly.
#
# @see /update
# ################################################# -->
[![Docker Hub](https://img.shields.io/docker/cloud/build/eaudeweb/scratch?label=Docker%20Hub&style=flat)](https://hub.docker.com/u/decidim)

<p align="center">
  <h1 align="center"><img width="400" src="https://cdn.rawgit.com/decidim/decidim/develop/logo.svg" alt="Decidim"></h1>
  <h2 align="center">The participatory democracy framework</h2>
  <p align="center">Free Open-Source participatory democracy, citizen participation and open government for cities and organizations. <a href="https://docs.decidim.org/"><br>Explore the docs »</a></p>
  <p align="center">Join our <a href="http://chat.decidim.org">Matrix.org chat rooms</a>.</p>
  <p align="center">
    <a href="https://decidim.org/features">Features</a> ·
    <a href="https://github.com/decidim/decidim/projects/16">Roadmap</a> ·
    <a href="https://github.com/decidim/docker/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc+label%3A%22type%3A+bug%22">Decidim on Docker: Report Bug</a> ·
    <a href="https://meta.decidim.org/processes/roadmap">Propose New Features</a> ·
    <a href="https://github.com/decidim/decidim">Decidim main repository</a></p>
</p>


## Getting started
Let's run an empty Decidim instance locally in 5min ⏱

### Local dependencies
In order to run this tutorial, you'll need the following local installations:

* unix-like bash or shell
* [docker](https://docs.docker.com/get-docker/)
  * If you haven't the desktop version of docker, you need to install [docker-compose](https://docs.docker.com/compose/install/) as well.
* curl

And now, check you have all of this in your terminal:
```
docker --version # should be 20.*
docker-compose --version # 1.29.* is fine
```

### Get the docker-compose
In an empty directory, download the [quickstart](https://raw.githubusercontent.com/decidim/docker/master/quickstart.yml) docker-compose.

```bash
mkdir my-participatory-platform
cd my-participatory-platform
curl https://raw.githubusercontent.com/decidim/docker/master/quickstart.yml > docker-compose.yml
```

### Run the docker-compose
```bash
docker-compose up
```

### Create your first organization
Now you can access [http://127.0.0.1:3000/system](http://127.0.0.1:3000/system). And use the credentials presents in the docker-compose: 

```
DECIDIM_SYSTEM_EMAIL=hello@myorg.com
DECIDIM_SYSTEM_PASSWORD=youReallyWantToChangeMe
```

Once connected, you can go in [/system](http://127.0.0.1:3000/system/organizations) and create a new organization. 
Then you can define your new organization:

- **Name**: Your application name
- **Reference prefix**: A small prefix for the uploaded files and documents.
- **Host**: `127.0.0.1`
- **Secondary host**: Leave empty
- **Organization admin name**: Your name
- **Organization admin email**: Your email
- **Locale**: Choose your own
- **Force authentication**: don't select
- **Users registration mode**: `Allow participants to register and login`
- **Available Authorizations**: Leave empty

And click on `Create organization & invite admin`.
You will then receive an email on this link: [http://127.0.0.1:1080](http://127.0.0.1:1080). You can there accept the invite.

### Safeguard your migrations files
Your instance now completly rely on the docker image you build. But it is sensible to changes. 
In order to be a bit more resilient, keep a copy of your migrations files and bind them as volume: 

```
# Copy files from the decidim container in a local `db/migrate` directory
docker cp decidim:/home/decidim/app/db/migrate db/migrate
```

And add these lines in your docker-compose.yml file:
```diff
    container_name: decidim
    image: ghcr.io/decidim/decidim:latest
    ports:
      - 3000:3000
    volumes:
      - storage:/home/decidim/app/storage
+     - ./db/migrate:/home/decidim/app/migrate
+   environment:
-   environment:    
      - DECIDIM_SYSTEM_EMAIL=hello@myorg.com
      - DECIDIM_SYSTEM_PASSWORD=youReallyWantToChangeMe
```

You can now `docker-compose up` again and have a safer place to tweak decidim.

### 🎉
That's it, you've got your participatory platform!

| URL | Description |
|---|---|
| [http://127.0.0.1:1080](http://127.0.0.1:1080) | ✉️ A Mailcatcher instance, all emails will be sent there |
| [http://127.0.0.1:3000](http://127.0.0.1:3000) | 🌱 Decidim instance |
| [http://127.0.0.1:3000/admin](http://127.0.0.1:3000/admin) | Decidim administration, your credentials are `admin@example.org`/`123456` |
| [http://127.0.0.1:3000/sidekiq](http://127.0.0.1:3000/_queuedjobs) | Monitoring Sidekiq jobs (login with your admin account) |
| [http://127.0.0.1:3000/system](http://127.0.0.1:3000/system) | Decidim system, see environments: `DECIDIM_SYSTEM_EMAIL`/`DECIDIM_SYSTEM_PASSWORD` |

Before deploying, be sure to read the [good practices](#good-practices).

---
## Read more about Decidim on docker

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Dockerhub](#dockerhub)
- [Eject you decidim instance](#eject-you-decidim-instance)
- [Environments configurations](#environments-configurations)
- [Unsupported Environments](#unsupported-environments)
- [Cron configurations](#cron-configurations)
- [Extend Decidim Images](#extend-decidim-images)
- [Good Practices](#good-practices)
  - [Choose a 64chars password for redis](#choose-a-64chars-password-for-redis)
  - [Use memcached as cache](#use-memcached-as-cache)
  - [Redis as a persistent store (AOF)](#redis-as-a-persistent-store-aof)
  - [Don't run decidim with privilegied postgres user](#dont-run-decidim-with-privilegied-postgres-user)
- [Contribute](#contribute)
- [Local development](#local-development)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

---

## Dockerhub
Don't use the `latest` tag, it is used for `develop` branch and is not suited for production.
Please choose one of the officially supported version of Decidim. 

**Stable tags**

[`:0.27.2-alpine`](https://hub.docker.com/r/hfroger/decidim/tags?page=1&name=0.27.2-alpine), [`:0.27-alpine`](https://hub.docker.com/r/hfroger/decidim/tags?page=1&name=0.27-alpine), [`:0.26.5-alpine`](https://hub.docker.com/r/hfroger/decidim/tags?page=1&name=0.26.5-alpine), [`:0.26-alpine`](https://hub.docker.com/r/hfroger/decidim/tags?page=1&name=0.26-alpine)

**Development tags**

[`:latest`](https://hub.docker.com/r/hfroger/decidim/tags?page=1&name=latest), [`:0.27.2-dev`](https://hub.docker.com/r/hfroger/decidim/tags?page=1&name=0.27.2-dev), [`:0.27-dev`](https://hub.docker.com/r/hfroger/decidim/tags?page=1&name=0.27-dev), [`:0.26.5-dev`](https://hub.docker.com/r/hfroger/decidim/tags?page=1&name=0.26.5-dev), [`:0.26-dev`](https://hub.docker.com/r/hfroger/decidim/tags?page=1&name=0.26-dev), [`:develop-alpine`](https://hub.docker.com/r/hfroger/decidim/tags?page=1&name=develop-alpine), [`:develop-dev`](https://hub.docker.com/r/hfroger/decidim/tags?page=1&name=develop-dev), [`:develop-alpine`](https://hub.docker.com/r/hfroger/decidim/tags?page=1&name=develop-alpine), [`:develop-dev`](https://hub.docker.com/r/hfroger/decidim/tags?page=1&name=develop-dev)

## Eject you decidim instance
You want to publish your instance on a git client? 
You can copy all files of your decidim container in your local environment with `docker cp`

```bash
docker-compose -f quickstart.yml up -d
docker cp decidim:/home/decidim/app ready-to-publish # Wait the command finishes!
cd ready-to-publish && git init
# Follow your git client instructions to upload this repo to github
```

And if you want to keep this docker-compose from quickstart: 
```diff
    container_name: decidim
    image: ghcr.io/decidim/decidim:latest
    ports:
      - 3000:3000
    volumes:
+     - ./ready-to-publish:/home/decidim/app
+   environment:
-     - storage:/home/decidim/app/storage
-     - ./db/migrate:/home/decidim/app/migrate
-   environment:    
      - DECIDIM_SYSTEM_EMAIL=hello@myorg.com
      - DECIDIM_SYSTEM_PASSWORD=youReallyWantToChangeMe
```

## Environments configurations
>  🔐: be sure to read the [good practices](#good-practices) ;)

| Env Name | Description | Default |
|---|---|---|
| DECIDIM_SYSTEM_EMAIL | Email use to access /system | `hello@myorg.com` |
| DECIDIM_SYSTEM_PASSWORD | Password use to access /system | `youReallyWantToChangeMe` |
| DECIDIM_RUN_RAILS | If the container should run rails | `1` |
| DECIDIM_RUN_SIDEKIQ | If the container should run sidekiq | `1` |
| DECIDIM_RUN_CRON | If the container should run cron | `1` |
| SECRET_KEY_BASE | 🔐 Secret used to initialize application's key generator | `youReallyWantToChangeMe` |
| RAILS_MASTER_KEY | 🔐 Used to decrypt credentials file | `youReallyWantToChangeMe` |
| RAILS_FORCE_SSL | If rails should force SSL | `false` |
| RAILS_MAX_THREADS | How many threads rails can use | `5` |
| RAILS_SERVE_STATIC_FILES | If rails should be accountable to serve assets | `false` |
| RAILS_ASSET_HOST | If set, define the assets are loaded from (S3?) | `` |
| SIDEKIQ_CONCURRENCY | Concurrency for sidekiq worker. MUST be <= DATABASE_MAX_POOL_SIZE | `RAILS_MAX_THREADS` |
| DATABASE_MAX_POOL_SIZE | Max pool size for the database. | `RAILS_MAX_THREADS` |
| DATABASE_URL | Host for the postgres database. | `pg` |
| TZ | Timezone used | `Europe/Madrid` |
| REDIS_UR | Redis url for sidekiq | `redis` |
| SMTP_AUTHENTICATION | How rails should authenticate to SMTP | `plain`, `none` |
| SMTP_USERNAME | Username for SMTP | `my-participatory-plateform@iredmail.org` |
| SMTP_PASSWORD | 🔐 Password for SMTP | `youReallyWantToChangeMe` |
| SMTP_ADDRESS | SMTP address | smtp.iredmail.org |
| SMTP_DOMAIN | SMTP [HELO Domain](https://www.ibm.com/docs/en/zos/2.2.0?topic=sc-helo-command-identify-domain-name-sending-host-smtp) | `iredmail` |
| SMTP_PORT | SMTP address port | `587` |
| SMTP_STARTTLS_AUTO | If TLS should start automatically | `enabled` |
| SMTP_VERIFY_MODE | How smtp certificates are verified | `none` |

Almost all the `DECIDIM_` variables are available. [See the documentation on default environments variables](https://github.com/decidim/decidim/blob/v0.27.0/docs/modules/configure/pages/environment_variables.adoc).


## Unsupported Environments

| Env name | Why it is NOT supported |
|---|---|
| RAILS_LOG_TO_STDOUT | We use `supervisord` process manager that will create/rotates logfiles for you. `RAILS_LOG_TO_STDOUT` will have no effect. |


## Cron configurations
Cron is configured to run scripts every 15min, 1hour, daily, weekly, monthly. 
When the times comes, it will execute all scripts present in the `/etc/periodic` directory. 
[By default](./bundle/docker/crontab.d), the following scripts are executed: 

```sh
├── 15min
│   └── change_active_steps.sh
├── daily
│   ├── daily_digest.sh
│   ├── open_data_export.sh
│   └── reminders_all.sh
├── hourly
│   ├── compute_metrics.sh
│   └── delete_download_your_data_files.sh
├── monthly
└── weekly
    ├── clean_registration_forms.sh
    └── weekly_digest.sh
```

To configure this, you can copy this `cron.d` directory, change the scripts and map a volume. 
Carefull, these scripts need permission to be executed, don't forget to `chmod +x` any new scripts.

```
# Copy the container directory locally
docker cp decidim:/etc/periodic crontab.d
```

And update your docker-compose: 
```diff
    container_name: decidim
    image: ghcr.io/decidim/decidim:latest
    ports:
      - 3000:3000
    volumes:
      - storage:/home/decidim/app/storage
+     - ./crontab.d:/etc/periodic
+   environment:
-   environment:    
```


## Extend Decidim Images
Let say you want to use official image, but a binary is missing. For the sake of the example, let's add `restic` a binary to manage encrypted backups. 
```
# Your new custom image
FROM decidim:v027
USER root # temporary go back in root to add your executable
RUN apk --update --no-cache restic
USER decidim # Go back to non-root user
# You are done!
```

To improve this you could remove logs, cache and others artifact from `apk` or use a multi-stage build to keep only the restic binary.


## Good Practices

### Choose a 64chars password for redis
> Redis internally stores passwords hashed with SHA256. If you set a password and check the output of ACL LIST or ACL GETUSER, you'll see a long hex string that looks pseudo random. […]
> Using SHA256 provides the ability to avoid storing the password in clear text while still allowing for a very fast AUTH command, which is a very important feature of Redis and is coherent with what clients expect from Redis.
> **However ACL passwords are not really passwords**. They are shared secrets between the server and the client, because the password is not an authentication token used by a human being. […]
> For this reason, slowing down the password authentication, in order to use an algorithm that uses time and space to make password cracking hard, is a very poor choice. What we suggest instead is to **generate strong passwords**, so that nobody will be able to crack it using a dictionary or a brute force attack even if they have the hash […]
> […] 64-byte alphanumerical string […] is long enough to avoid attacks and short enough to be easy to manage[…]
> Source: [_Redis Documentation_. ACL, Redis Access Control List, Key permissions. (visited 08/11/2022)](https://redis.io/docs/management/security/acl/)

### Use memcached as cache
**Avoid using redis as cache**. Redis should be configured in persistent mode (AOF) for sidekiq running. It is not a well suited configuration for caching, and you shouldn't use the same redis instance to do cache and queuing.
Read more on this particular issue in [the sidekiq wiki:](https://github.com/mperham/sidekiq/wiki/Using-Redis#multiple-redis-instances)

### Redis as a persistent store (AOF)
Sidekiq is used to send emails and do remote tasks. It should be configured as a persistent store (AOF).
Read more on configuring redis persistence on the [Redis Documentation](https://redis.io/docs/management/persistence/).

### Don't run decidim with privilegied postgres user
A good practice is to run decidim with unpriviligied user (can not create table, truncate it or alter it). 
A common way to put this in practice is to have CI/CD deployment script (through github actions for example), where: 

- While deploying, deploy a temporary instance (sidecars) with priviliged database access. Migrate the database.
- Once `rails db:migrate:status` gives only `up` migrations, redeploy an instance without priviliged accesses.

**NB** running `rails db:migrate` while a rails application is running is most of the time a bad idea (connection to postgres can hangs). Always check `rails db:migrate:status` after a migration, to be sure all migration passed.

## Contribute
See [CONTRIBUTING.md](./CONTRIBUTING.md) for more informations.

## Local development
To debug and rebuild the images locally, you can: 
1. Clone this repository (`git clone git@github.com:decidim/docker.git decidim-docker`)
2. Run `quickstart.yml` docker-compose with the version you want to build. 

| Decidim Version | Alpine Ruby image | Alpine Node image | Docker-compose command |
|---|---|---|---|
| 0.27.2 | ruby:3.0-alpine3.15 | node:16.20-alpine3.17 | `docker-compose -f quickstart.yml -f quickstart.v027.yml up` |
| 0.27.2 | ruby:3.0-alpine3.15 | node:16.20-alpine3.17 | `docker-compose -f quickstart.yml -f dev-v027.yml up` |
| 0.26.5 | ruby:2.7-alpine3.15 | node:16.20-alpine3.17 | `docker-compose -f quickstart.yml -f quickstart.v026.yml up` |
| 0.26.5 | ruby:2.7-alpine3.15 | node:16.20-alpine3.17 | `docker-compose -f quickstart.yml -f dev-v026.yml up` |
| 0.28.0.dev | ruby:3.0-alpine3.15 | node:16.20-alpine3.17 | `docker-compose -f quickstart.yml -f quickstart.develop.yml up` |
| 0.28.0.dev | ruby:3.0-alpine3.15 | node:16.20-alpine3.17 | `docker-compose -f quickstart.yml -f dev-develop.yml up` |


The templates for README, quickstart.yml, quickstart.NAME_YOUR_VERSION.yml are available in the [template directory](./templates)


[PR are Welcome](./CONTRIBUTING.md) ❤️ 

## License
This repository is under [GNU AFFERO GENERAL PUBLIC LICENSE, V3](./LICENSE).

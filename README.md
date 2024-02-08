<!--
CONTRIBUTOR; WARNING
This file is generated by the /update-documentation.rb script. 
Don't edit it directly.

@see /update-documentation.rb
@see /templates/README.md.erb
-->

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

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Dockerhub](#dockerhub)
- [▶️ 5min tutorial](#-5min-tutorial)
  - [Eject you decidim instance](#eject-you-decidim-instance)
  - [Environments configurations](#environments-configurations)
  - [Cron configurations](#cron-configurations)
  - [Entrypoints](#entrypoints)
    - [Command](#command)
  - [Extend Decidim Images](#extend-decidim-images)
  - [Run Decidim in development/test mode](#run-decidim-in-developmenttest-mode)
  - [Contribute](#contribute)
    - [How Does It Works](#how-does-it-works)
    - [Repository Structure](#repository-structure)
  - [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

---

# Dockerhub

**Stable tags**

[:0.26](https://hub.docker.com/r/hfroger/decidim/tags?page=1&name=0.26),[:0.27](https://hub.docker.com/r/hfroger/decidim/tags?page=1&name=0.27),[:0.28](https://hub.docker.com/r/hfroger/decidim/tags?page=1&name=0.28)


**Development tags**

[:nightly](https://hub.docker.com/r/hfroger/decidim/tags?page=1&name=nightly)

# [▶️ 5min tutorial](./docs/5min-tutorial.md)
Ready to mount a Decidim installation locally in 5min?
[Follow our 5min tutorial](./docs/5min-tutorial.md) to setup Decidim with Docker locally.

## Eject you decidim instance
You want to publish your instance on a git? 
You can copy all files of your decidim container in your local environment with `docker cp`

```bash
docker-compose up -d
docker cp decidim:/home/decidim/app ready-to-publish # Wait the command finishes!
cd ready-to-publish && git init
# Follow your git client instructions to upload this repo to github
```

Once ejected, you will have a Dockerfile and docker-compose ready to use on your ejected application.

## Environments configurations
>  🔐: be sure to read the [good practices](#good-practices) ;)

| Env Name | Description | Default |
|---|---|---|
| DECIDIM_SYSTEM_EMAIL | Email use to access /system | `hello@myorg.com` |
| DECIDIM_SYSTEM_PASSWORD | Password use to access /system | `my_insecure_password` |
| SECRET_KEY_BASE | 🔐 Secret used to initialize application's key generator | `my_insecure_password` |
| RAILS_MASTER_KEY | 🔐 Used to decrypt credentials file | `my_insecure_password` |
| RAILS_FORCE_SSL | If rails should force SSL | `false` |
| RAILS_MAX_THREADS | How many threads rails can use | `5` |
| RAILS_SERVE_STATIC_FILES | If rails should be accountable to serve assets | `false` |
| RAILS_ASSET_HOST | If set, define the assets are loaded from (S3?) | `` |
| SIDEKIQ_CONCURRENCY | Concurrency for sidekiq worker. MUST be <= DATABASE_MAX_POOL_SIZE | `RAILS_MAX_THREADS` |
| DATABASE_MAX_POOL_SIZE | Max pool size for the database. | `RAILS_MAX_THREADS` |
| DATABASE_URL | Host for the postgres database. | `pg` |
| TZ | Timezone used | `Europe/Madrid` |
| REDIS_URL | Redis url for sidekiq | `redis` |
| SMTP_AUTHENTICATION | How rails should authenticate to SMTP | `plain`, `none` |
| SMTP_USERNAME | Username for SMTP | `my-participatory-plateform@iredmail.org` |
| SMTP_PASSWORD | 🔐 Password for SMTP | `my_insecure_password` |
| SMTP_ADDRESS | SMTP address | smtp.iredmail.org |
| SMTP_DOMAIN | SMTP [HELO Domain](https://www.ibm.com/docs/en/zos/2.2.0?topic=sc-helo-command-identify-domain-name-sending-host-smtp) | `iredmail` |
| SMTP_PORT | SMTP address port | `587` |
| SMTP_STARTTLS_AUTO | If TLS should start automatically | `enabled` |
| SMTP_VERIFY_MODE | How smtp certificates are verified | `none` |

All the `DECIDIM_` variables are available. [See the documentation on default environments variables](https://github.com/decidim/decidim/blob/v0.27.0/docs/modules/configure/pages/environment_variables.adoc).


## Cron configurations
Cron is configured to run scripts every 15min, 1hour, daily, weekly, monthly. 
When the times comes, it will execute all scripts present in the `/etc/periodic` directory. 
[By default](./bundle/crontab.d), the following scripts are executed:

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
    image: decidim/decidim:latest
    ports:
      - 3000:3000
    volumes:
      - storage:/home/decidim/app/storage
+     - ./crontab.d:/etc/periodic
+   environment:
-   environment:    
```

If you don't use docker image to run your cron and prefer using a schedulder, 
you can get the commands in the [crontab file](./bundle/crontab.d/crontab)

## Entrypoints
Before running the docker command, we go through [entrypoints scripts](./bundle/docker-entrypoint.d).

* **10_remove_pids**: Remove old puma pids if exists
* **15_wait_for_it**: Run a [wait-for-it](./bundle/bin/wait-for-it) for dependancies: `REDIS_URL`, `DATABASE_URL` and `MEMCACHE_SERVERS` are supported.
* **35_bundle_check**: Check if all your gems are installed, and your migrations are up.
* **45_template**: Set the motd file to have a nice welcome message.
* **50_upsert-sysadmin**: Check your `DECIDIM_SYSTEM_EMAIL` and `DECIDIM_SYSTEM_PASSWORD` and update the first /system administrator

### Command
You can update your docker-compose command to whatever you want.
It is common to see one of these:

* **bundle exec rails server -b 0.0.0.0**: start a puma server.
* **bundle exec sidekiq**: start a sidekiq worker.
* **cron start -f**: start cron in forground.
* **sleep infinity**: do nothing, and let you exec processes in the container with `docker exec decidim`.


## Extend Decidim Images
Let say you want to use official image, but a binary is missing. For the sake of the example, let's add `restic` a binary to manage encrypted backups. 
```
# Your new custom image
FROM decidim:0.28.0-onbuild
RUN apk --update --no-cache restic
# You are done, restic is now available in your image.
```

## Run Decidim in development/test mode
The docker-compose `docker-compose.NAME_YOUR_VERSION.dev.yml` allows you to run decidim in `development` or `test` mode. 
They are larger images, and are not suited for production usage.


## Contribute
See [CONTRIBUTING.md](./CONTRIBUTING.md) for more informations.
[PR are Welcome](./CONTRIBUTING.md) ❤️ 

### How Does It Works
This repository is designed to automate the publication of Decidim versions using Docker containers, along with generating documentation to use these containers.

**Decidim Version Management**

* `lib/decidim_version.rb`: For a specific Decidim version, retrieve dependancies (Ruby, Node.js, Bundler) versions.
* `lib/docker_image.rb`: Match dependancies with the right ruby docker image

**Docker Image Automation**

* `update-registry.rb`: Manages Docker images by building, tagging, and optionally pushing them to a Docker registry. It utilizes ERB templates to generate Docker-related files dynamically.
* `lib/helpers.rb`: Utility function to manage images.

**Documentation Generation**

* `update-documentation.rb`: Automatically generates documentation for each supported Decidim version. It uses ERB templates to create version-specific docker-compose files and a README.md, outlining available Docker images and setup instructions.


###  Repository Structure
* `lib/`: Contains core classes and modules for version management and Docker image creation.
* `templates/`: Holds ERB templates for Docker configurations and documentation.
* Scripts: `update-registry.rb` and `update-documentation.rb` automate Docker image management and documentation generation.

## License
This repository is under [GNU AFFERO GENERAL PUBLIC LICENSE, V3](./LICENSE).

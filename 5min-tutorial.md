<!--
 NOTICE
 [`rake docker:docs`] This file is generated from a template
    @see ./templates/docs/5min-tutorial.md.erb
-->

# 5min tutorial
Let's run an empty Decidim instance locally in 5min ⏱

### Local dependencies
In order to run this tutorial, you'll need the following local installations:

* a bash or shell
* [docker](https://docs.docker.com/get-docker/)
  * If you haven't the desktop version of docker, you need to install [docker-compose](https://docs.docker.com/compose/install/) as well.
* curl

And now, check you have all of this in your terminal:
```
docker --version # should be >= 28
docker compose version # should be >= 2.35
```

## Get the docker-compose
In an empty directory, download the [docker-compose quickstart](https://raw.githubusercontent.com/decidim/docker/master/quickstart.yml).

```bash
mkdir my-participatory-platform
cd my-participatory-platform
curl https://raw.githubusercontent.com/decidim/docker/master/quickstart.yml > docker-compose.yml
```

## Run the docker-compose
```bash
docker-compose up
```

## Create your first organization
Now you can access [http://127.0.0.1:8080/system](http://127.0.0.1:8080/system). And use the credentials presents in the docker-compose: 

```
DECIDIM_SYSTEM_EMAIL=hello@example.org
DECIDIM_SYSTEM_PASSWORD=my_insecure_password
```

Once connected, you can go in [/system](http://127.0.0.1:8080/system/organizations) and create a new organization. 
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
You will then receive an email on this link: [http://127.0.0.1:1080](http://127.0.0.1:1080). 
Accept the invite.

### Safeguard your migrations files
Your instance now completly rely on the docker image you build.
But the migrations files will change in the image published everyday on docker hub. 
In order to be resilient to re-build, keep a copy of your migrations files and bind them as volume: 

```
# Ensure you still have a docker-compose up running. 
# Copy files from the decidim container in a local `db/migrate` directory
docker cp decidim:/home/decidim/db/migrate db/migrate
```

And add these lines in your docker-compose.yml file:
```diff
    container_name: decidim
    image: decidim/decidim:0.30.0
    volumes:
      - storage:/home/decidim/storage
+     - ./db/migrate:/home/decidim/migrate
+   environment:
-   environment:
```

You can now `docker-compose up` again and have a safer place to tweak decidim.

# Welcome to Decidim 🎉
That's it, you've got your participatory platform!

| URL | Description |
|---|---|
| [http://127.0.0.1:1080](http://127.0.0.1:1080) | ✉️ A Mailcatcher instance, all emails will be sent there |
| [http://127.0.0.1:8080](http://127.0.0.1:8080) | 🌱 Decidim instance |
| [http://127.0.0.1:8080/admin](http://127.0.0.1:8080/admin) | Decidim administration, your credentials are `admin@example.org`/`123456` |
| [http://127.0.0.1:8080/system](http://127.0.0.1:8080/system) | Decidim system, see environments: `DECIDIM_SYSTEM_EMAIL`/`DECIDIM_SYSTEM_PASSWORD` |

Before going to production, be sure to read the [good practices](./good-practices).

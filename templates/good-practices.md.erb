<!--
 NOTICE
 [`rake docker:docs`] This file is generated from a template
    @see ./templates/good-practices.md.erb for contributing
-->

# Good practices
> Warning: This is a work in progress.

This is a collection of good practices for putting Decidim in production.
Decidim is a Rails module, so most of the good practices are the same as for Rails applications.
We will focus on Decidim-specific aspects, as many Rails features are not relevant for Decidim.

## Easy redeploy
It is important to be able to redeploy the docker image easily, without losing data. 

- Use a git repository for the code
- Use Environment variables as much as possible
- Use CI/CD pipelines to build and re-deploy Docker images

The images published here are built every day on __Decidim Stable branches__ and on latest operating systems.
Being able to redeploy fast is a key factor for a secure installation.

## Background jobs
Decidim depends on background jobs to: 

- Send emails
- Build search index
- Compute metrics
- Cleanup

These jobs are for long-running operations, so they should be running in the background.
In Decidim, sending emails is _critical_: make them async, monitor them, and ensure they are working correctly.

**For small installations**  
We recommend using the `good_job` gem to run background jobs in `async_server` mode.
Good Job runs on your postgres database (no need for redis), and `async_server` mode runs
together with your puma process. This keeps your installation minimalistic and gives you a similar experience to a sidekiq installation.
When the installation gets bigger, switch to `external` mode or use the `sidekiq` gem.


**For large installations**  
Use `sidekiq` or `good_job` in `external` mode.

Note that sidekiq has specific requirements for the redis server:
- It must run in Append Only mode (AOF): the redis server must be different from the one used by cache (as cache will not use AOF).
- Sidekiq does not guarantee that your jobs won't be lost if the redis server is restarted. (Only sidekiq pro and good_job do).

## Database user
Do not use a postgres root user for the application. Use a dedicated user instead.
You can use CI/CD pipelines, sidecar, or whatever is available to run database migrations.
Once migrations are done, no Decidim operations require root access to the database.

## Use an object storage compatible with aws-s3
Configure Active Storage to use an object storage system, ideally with a cdn and a public host. 
This will off-load your server, and increase your performances. Public host will allow you to do a more 
aggressive cache on your instances


# Use a proxy (Nginx, HAProxy, etc.)
Use a proxy to handle the public traffic to your Decidim instance.

This will allow you to:
- Handle SSL termination
- Distribute `/public` assets to your users
- Add a HSTS and Strict-Transport-Security headers to responses
- Protect your instance from direct access to the web

# Production Checklist

- [ ] Create a `decidim-<your organization>` public repository
- [ ] Add pipelines to deploy in your environments
- [ ] Connect to an object storage service compatible with aws-s3
- [ ] For small installation (< 2000 participants)
  - [ ] Use good_job in `async_server` mode
- [ ] For large installation (> 2000 participants)
  - [ ] Use sidekiq in `external` mode
  - [ ] Setup a redis server in Append Only mode
- [ ] Use a dedicated database user with no DROP/CREATE permissions
- [ ] Monitor puma and background job processes
- [ ] Monitor error reporting
- [ ] Rotate your logs
- [ ] Check your services security: 
  - [ ] proxy accessible to the web, everything else is private
  - [ ] redis (background process or cache) password is at least 128 chars
  - [ ] postgres (database) password is at least 64 chars
- [ ] Check your services security: no direct access to the web, only through the proxy
- [ ] Fine tune `WEB_CONCURRENCY` and `RAILS_MAX_THREADS` together with your database max pool size.
- [ ] Define a backup routine for your database and your assets.
- [ ] Test how to redeploy your instance without losing data.
- [ ] Plan regular maintenance windows for minor upgrades
- [ ] Join Decidim Community on matrix, present yourself, and join the dev chat room (will need this to get help when you need it).


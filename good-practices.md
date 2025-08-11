<!--
 NOTICE
 [`rake docker:docs`] This file is generated from a template
    @see ./templates/good-practices.md.erb for contributing
-->

# Good practices
> Warning: This is a work in progress.

This a collection of good practices for putting Decidim in production.
Decidim is a Rails module, so most of the good practices are the same as for Rails applications. 
We will focus on Decidim specific aspects, as many rails features are not relevant for Decidim.

## Easy redeploy
It is important to be able to redeploy the docker image easily, without loosing data. 

- Use a git repository for the code
- Use Environment variables as much as possible
- Use CI/CD pipelines to build and re-deploy Docker images

The images published here are build every day on __Decidim Stable branches__ and on latest operating systems.
Beeing able to redeploy fast is a key factor for a secure installation.

## Background jobs
Decidim depends on background jobs to: 

- Send emails
- Build search index
- Compute metrics
- Cleanup

These jobs are for long running operations, so they should be running in background.
In Decidim, sending emails are _critical_: so make them async, monitor them, and make sure they are working well.

**For small installations**  
We recommend the use of the gem `good_job` to run background jobs in `async_server` mode.
Good Job will run over your postgres database (no need for a redis), and `async_server` mode will run 
together with your puma process. This keep your installation minimalistic, and give you similar experience as a sidekiq installation.
We installation get bigger, switch to `external` mode or go for `sidekiq` gem.


**For large installations**  
Use `sidekiq` or `good_job` in `external` mode.

Note that sidekiq have specific requirements for the redis server: 
- It must run on Append Only mode (AOF): the redis server must be different from the one used by cache (as cache will not be an AOF). 
- Sidekiq does not garentee your jobs won't be lost if the redis server is restarted. (Only sidekiq pro and good_job do).

## Database user
Do not use a postgres root user for the application but use a dedicated user.
You can use CI/CD pipelines, sidecar, or whatever available to run database migrations.
Once migrations are done, no decidim operations requires root access to the database.

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

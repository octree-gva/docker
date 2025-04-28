## Templates for repository documentation
This folder hold `.erb` template to update the repository to the current versions. 
The templating is done through `bundle exec rake docker:docs` tasks, and will inject the 
same variables for all the templates: 

- `develop_version`: The `Decidim::DecidimVersion` for the `develop` branch
- `last_version`: The `Decidim::DecidimVersion` for the last `release/*-stable` branch
- `prev_version`: The `Decidim::DecidimVersion` for the previous `release/*-stable` branch
- `base_image_tag`: The ubuntu tag used to generate images

As `last_version` receives features requests, and `prev_version` receives only bugs and security fixes, 
it is adviced to promote the use of the `prev_version` when new users comes in. 
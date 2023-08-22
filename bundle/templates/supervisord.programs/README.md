# Supervisord Programs
These programs files are part of a larger [`supervisord.conf`](../supervisord.conf.erb).
They are template files, having as `locals`

* `name`: program name
* `root`: the workdir absolute path
* `rails_env`: current rails environement. 

The rule for a program file to be added to the larger supervisord configuration file is to have an environment variable `RUN_<program name>` to 1. 
Example: `RUN_PUMA=1` will add the `puma.erb` program template to the supervisord configuration. 

 
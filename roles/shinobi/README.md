## Shinobi
Made my own image following what found in https://github.com/acobaugh/shinobi-docker

The official image install Mysql inside the container, this is properly decoupled.

### Shinobi keys

The entrypoint generates random Shinobi cron and plugin keys when no keys exist in the config or environment.
Set `shinobi_cron_key`, `shinobi_plugin_key_motion`, `shinobi_plugin_key_opencv`, and `shinobi_plugin_key_openalpr` to keep keys stable when Ansible recreates the container.
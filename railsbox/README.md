# Railsbox: auto deploy rails app

## railsbox cookbook (v0.1.0)

Setup a **Rails application server** to run Nginx+Unicorn+Psql+Cap+Github apps.

edit from: 

* [teohm/rackbox-cookbook](https://github.com/teohm/rackbox-cookbook)
* [teohm/databox-cookbook](https://github.com/teohm/databox-cookbook)
* [riceo/github-deploys](https://github.com/riceo/github-deploys)

It performs the following tasks when setup the server:

 * Install and setup Ruby environment  using `rbenv`.
 * Install Nginx from source as front-end server.
 * Setup Unicorn apps as backend server (if any).
 * Setup `runit` service.
 * Install nodejs from package to complie assest.
 * Using the Github API to authorise the new public key (if any).

## Requirements

### Supported Platforms

* `ubuntu` - tested on Ubuntu 12.04

### Cookbook Dependencies

* "appbox"   # apt\sudo\user\curl\htop\git\tmux
* 'rbenv'
* 'nginx'
* 'unicorn', ">= 1.2.2"
* 'runit', '>= 1.1.2'
* "postgresql"
* "database"
* "nodejs"

## Install

To install with **Berkshelf**, add this into `Berksfile`:

```
cookbook 'railsbox', git: 'git://github.com/ouyangzhiping/railsbox.git'
```

and run:

```
bundle exec berks install -p cookbooks/
```

And overwrite attributes to customize the cookbook. then add the default recipe to your runlist.

example:

```json
{
  "run_list":[
    "railsbox"
  ],
  "appbox": {
    "deploy_keys": ["ssh-rsa, 1. run cat ~/.ssh/id_rsa.pub on your mac 2. copy it"],
    "admin_keys": ["ssh-rsa, 1. run cat ~/.ssh/id_rsa.pub on your mac 2. copy it"]
  },
  "railsbox": {
    "db_root_password": "welcome!",
    "databases": {
      "postgresql": [
        { "username": "psyapp",
          "password": "psqlpassword",
          "database_name": "appname_production" }
      ]
    },
    "ruby": {
      "versions": ["2.0.0-p247", "2.0.0-p247"],
      "global_version": "2.0.0-p247"
    },
    "apps": {
      "unicorn": [
        { "appname": "railsbox-example-app1",
          "hostname": "33.33.33.10"
        }
      ]
    }
  },
    "github_deploys": {
    "deploy_user": "deploy",
    "github_api": {
      "username": "set your github username",
      "email": "set your github user email",
      "password": "set your github password"
    }
  },
  "nginx":
{
  "version": "1.5.2"
}
}
```

See also [ouyangzhiping/railsbox-example](https://github.com/ouyangzhiping/railsbox-example) for `railsbox` usage example with chef-solo.

## Attributes

You may change the **default config** settings:


 * **nginx**:
   * `node["railsbox"]["default_config"]["nginx"]["template_name"]` (default: `"nginx_vhost.conf.erb"`) - nginx vhost/site config template.
   * `node["railsbox"]["default_config"]["nginx"]["template_cookbook"]` (default: `"railsbox"`) - cookbook containing the nginx vhost/site config template.
   * `node["railsbox"]["default_config"]["nginx"]["listen_port"]` (default: `"80"`) - nginx vhost/site listen port.
   * `node["railsbox"]["upstream_start_port"]["unicorn"]` (default: `10001`) - start number for unicorn app listen port.
   * `node["railsbox"]["upstream_start_port"]["passenger"]` (default: `20001`) - start number for passenger app listen port.
 * **unicorn**:
   * `node["railsbox"]["default_config"]["unicorn"]["listen_port_options"]` (default: `{ :tcp_nodelay => true, :backlog => 100 }`) - unicorn listen port options.
   * `node["railsbox"]["default_config"]["unicorn"]["worker_timeout"]` (default: `60`) - unicorn worker timeout.
   * `node["railsbox"]["default_config"]["unicorn"]["preload_app"]` (default: `false`) - unicorn preload app flag.
   * `node["railsbox"]["default_config"]["unicorn"]["worker_processes"]` (default: `[node[:cpu][:total].to_i * 4, 8].min`) - total unicorn worker.
   * `node["railsbox"]["default_config"]["unicorn"]["before_fork"]` (default: `'sleep 1'`) - unicorn before_fork handler.
 * **unicorn_runit**:
   * `node["railsbox"]["default_config"]["unicorn_runit"]["template_name"]` (default: `"unicorn"`) - name to lookup unicorn runit templates (templates: `"sv-#{template_name}-run.erb"`, `"sv-#{template_name}-log-run.erb`).
   * `node["railsbox"]["default_config"]["unicorn_runit"]["template_cookbook"]` (default: `"railsbox"`) - cookbook containing the templates.
   * `node["railsbox"]["default_config"]["unicorn_runit"]["rack_env"]` (default: `"production"`) - default RACK_ENV to run a unicorn app.
* **postgresql**:
	* `node["railsbox"]["db_root_password"]` (default: `nil`) - postgresql root password string.
	* `node["railsbox"]["databases"]["postgresql"]["username"]`- Rails app database username
	* `node["railsbox"]["databases"]["postgresql"]["password"]`- Rails app database password
	* `node["railsbox"]["databases"]["postgresql"]["database_name"]`- Rails app database name
 * **github-deploys**:
   * `node["railsbox"]["github_deploys"]["deploy_user"]` (default: `"deploy"`) - don't edit !
    * `node["railsbox"]["github_deploys"]["github_api"]["endpoint_path"]` (default: `"/user/keys"`) - [User Public Keys | GitHub API](http://developer.github.com/v3/users/keys/#update-a-public-key) !
    * `node["railsbox"]["github_deploys"]["username"]` - set your github username
    * `node["railsbox"]["github_deploys"]["email"]` - set your github email
    * `node["railsbox"]["github_deploys"]["password"]` - set your github password


## Recipes

* recipe   "railsbox", "Includes all recipes."
* recipe   "railsbox::ruby", "Install and setup Ruby environment  using `rbenv`"
* recipe   "railsbox::nginx", "Install Nginx from source as front-end server."
* recipe   "railsbox::unicorn", "Setup Unicorn apps as backend server (if any)."
* recipe   "railsbox::postgresql", "Install PostgreSQL and create PostgreSQL databases."
* recipe   "railsbox::nodejs", "Install nodejs from package to complie assest."
* recipe   "railsbox:github-deploys", "Using the Github API to authorise the new public key (if any)"

## Change History

See [CHANGELOG](CHANGELOG.md).

## Author

Author:: zhiping (<http://yangzhiping.com>)

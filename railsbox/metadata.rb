name             'railsbox'
maintainer       'zhiping'
maintainer_email 'im@yangzhiping.com'
license          'Apache License 2.0'
description      'auto deploy railsapp with rbenv+nginx+unicorn+postgresql'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe   "railsbox", "Includes all recipes."
recipe   "railsbox::ruby", "setup a ruby version manager `rbenv`."
recipe   "railsbox::nginx", "setup `nginx` as front-end server."
recipe   "railsbox::unicorn", "setup `unicorn` apps, if any."
recipe   "railsbox::postgresql", "Install PostgreSQL and create PostgreSQL databases."
recipe   "railsbox::nodejs", "Install Nodejs based on the default installation method"
recipe   "railsbox:github-deploys", "install github-deploys"

supports "ubuntu"
supports "debian"

depends "appbox"   # apt\sudo\user\curl\htop\git\tmux
depends 'rbenv'
depends 'nginx'
depends 'unicorn', ">= 1.2.2"
depends 'runit', '>= 1.1.2'
depends "postgresql"
depends "database"
depends "nodejs"



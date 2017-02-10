server '13.112.193.80', user: 'app', roles: %w{app db web}
set :ssh_options, keys: '/home/vagrant/aws/.ssh/id_rsa'

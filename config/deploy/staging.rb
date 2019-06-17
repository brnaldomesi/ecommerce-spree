set :environment, 'staging'
set :rails_env, 'staging'

set :branch, ENV['BRANCH'] || 'master'

server '140.82.56.18', user: 'deploy', roles: %w{web app db}

set :ssh_options, {
    user: 'deploy',
    keys: ['~/.ssh/tbdmarket', '~/.ssh/id_rsa'],
    forward_agent: true,
    auth_methods: %w(publickey)
}
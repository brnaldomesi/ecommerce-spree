set :environment, 'staging'
set :rails_env, 'staging'

set :branch, ENV['BRANCH'] || 'master'

server 'tbdmarket.com', user: 'deploy', roles: %w{web app db}

set :ssh_options, {
    user: 'deploy',
    keys: ['~/.ssh/tbdmarket'],
    forward_agent: true,
    auth_methods: %w(publickey)
}
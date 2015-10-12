require 'serverspec'
require 'json'
require 'net/ssh'

set :backend, :exec

if ENV['ASK_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    warn "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

host = ENV['TARGET_HOST']

options = Net::SSH::Config.for(host)

options[:user] ||= ENV['RSPEC_USER']
options[:user] ||= 'Etc.getlogin'

set :host,        options[:host_name] || host
set :ssh_options, options

nodejson = '/tmp/serverspec-test/node.json'
if File.exists? nodejson then
  $node = ::JSON.parse(File.read(nodejson))
else
  warn "Node json not readable: " + nodejson
end


# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'

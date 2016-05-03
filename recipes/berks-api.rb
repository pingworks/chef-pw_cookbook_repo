apt_repository 'brightbox-ppa' do
  uri 'http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu'
  distribution 'trusty'
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key 'C3173AA6'
  action :add
end

node.force_override['apt']['periodic_update_min_delay'] = 0
include_recipe 'apt'

package 'ruby2.2'
package 'ruby2.2-dev'
package 'libarchive-dev'
package 'build-essential'
package 'git'

bash 'gem install berkshelf-api' do
  user 'root'
  cwd '/tmp'
  code <<-EOF
  gem install unf
  gem install berkshelf-api:2.1.1
  EOF
  not_if 'test -d /var/lib/gems/2.1.0/gems/berkshelf-api-2.1.1'
end

bash 'install berkshelf-api-binrepo-store' do
  user 'root'
  cwd '/usr/local/src'
  code <<-EOF
  set -e
  git clone https://github.com/pingworks/berkshelf-api-binrepo-store.git
  EOF
  not_if 'test -d /usr/local/src/berkshelf-api-binrepo-store/.git'
end

bash 'symlink benrepo_store' do
  user 'root'
  cwd '/tmp'
  code <<-EOF
  RUBY_VERSION=$(ruby --version | cut -d' ' -f2 | sed -e 's;^[^0-9]*\\([0-9]*\\.[0-9]*\\)\\.[0-9]*.*$;\\1.0;')
  echo R:$RUBY_VERSION
  BERKS_VERSION=$(berks-api --version)
  ln -sf /usr/local/src/berkshelf-api-binrepo-store/lib/berkshelf/api/cache_builder/worker/binrepo_store.rb \
    /var/lib/gems/${RUBY_VERSION}/gems/berkshelf-api-${BERKS_VERSION}/lib/berkshelf/api/cache_builder/worker/
  EOF
end

directory '/etc/berkshelf' do
  owner node['pw_cookbook_repo']['owner']
  group node['pw_cookbook_repo']['group']
  mode 00755
  recursive true
  action :create
end

template '/etc/berkshelf/config.json' do
  source 'berkshelf-api-config-json.erb'
  owner node['pw_cookbook_repo']['owner']
  group node['pw_cookbook_repo']['group']
  mode 00744
end

directory '/var/log/berks-api' do
  owner node['pw_cookbook_repo']['owner']
  group node['pw_cookbook_repo']['group']
  mode 00755
  recursive true
  action :create
end

directory node['pw_cookbook_repo']['importdir'] do
  owner node['pw_cookbook_repo']['owner']
  group node['pw_cookbook_repo']['group']
  mode 00755
  recursive true
  action :create
end

template '/etc/init.d/berks-api' do
  source 'berks_init_script.erb'
  owner 'root'
  group 'root'
  mode 00755
end

service 'berks-api' do
  action [ :enable, :start ]
end

apt_package 'apache2'

template '/etc/apache2/conf-available/berks-api-universe.conf' do
  source 'confd_berks-api_universe.erb'
  owner "root"
  group "root"
  mode '644'
end

bash 'enable_apache_berks-api-universe' do
  code 'a2enconf berks-api-universe'
end

bash 'a2enmod proxy' do
  code 'a2enmod proxy'
end

bash 'a2enmod proxy_http' do
  code 'a2enmod proxy_http'
end

bash 'apache2_restart' do
  code 'service apache2 restart'
end

require_relative '../spec_helper'

describe command("wget -O- http://localhost:26200/universe 2>&1") do
  its(:stdout) { should match /^{}$/ }
end

describe command("wget -O- http://localhost/universe 2>&1") do
  its(:stdout) { should match /^{}$/ }
end

describe file("#{$node['pw_cookbook_repo']['importdir']}") do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by $node['pw_cookbook_repo']['owner'] }
  it { should be_mode 755 }
end

describe process('berks-api') do
  it { should be_running }
end

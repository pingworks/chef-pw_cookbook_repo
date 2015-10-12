require_relative '../spec_helper'

describe command("wget -O/dev/null http://localhost#{$node['pw_cookbook_repo']['alias']} 2>&1") do
  its(:stdout) { should match /HTTP request sent, awaiting response... 200 OK/ }
end

describe file("#{$node['pw_cookbook_repo']['dir']}") do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by $node['pw_cookbook_repo']['owner'] }
  it { should be_mode 755 }
end

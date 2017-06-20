# for serverspec documentation: http://serverspec.org/
require_relative 'spec_helper'

files = ['/etc/bird/bird.conf', 
         '/etc/bird/config.d/route_1.conf',
         '/etc/bird/config.d/route_2.conf']

files.each do |file|
  describe file("#{file}") do
    it { should be_file }
  end
end

describe service('bird.service') do
  it { should be_running.under('systemd') }
  it { should be_enabled }
end

describe command('birdc show protocols | grep -q BGP') do
  its(:exit_status) { should eq 0 }
end

describe 'Linux kernel parameters' do
  context linux_kernel_parameter('net.ipv4.ip_forward') do
    its(:value) { should eq 1 }
  end

  context linux_kernel_parameter('net.ipv4.conf.all.accept_redirects') do
    its(:value) { should eq 0 }
  end

  context linux_kernel_parameter('net.ipv4.conf.all.send_redirects') do
    its(:value) { should eq 0 }
  end
end

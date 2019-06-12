#
# Cookbook:: rapid7
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

case node['platform']
when 'centos', 'redhat', 'amazon'  
  poise_archive 'download media' do
    path "#{node['rapid7']['download_url']}#{node['rapid7']['linux_src']}"
    destination "#{node['rapid7']['install_dir']}/rapid7/"
    user node['rapid7']['user']
    group node['rapid7']['group']
    strip_components 0
    keep_existing true
   end
execute "install" do
  cwd "#{node['rapid7']['install_dir']}/rapid7/"
  command "chmod -R 755 *"
end
execute "install" do
  cwd "#{node['rapid7']['install_dir']}/rapid7/"
  command "./agent_installer.sh install_start"
  user "root"
  group "root"
  action :run
  not_if{ ::File.directory?("#{node['rapid7']['install_dir']}/rapid7/ir_agent") }
end

when 'windows'
  directory "#{node['rapid7']['windows_install_dir']}" do
    rights :full_control, 'Everyone'
    inherits false
    action :create
  end
  windows_zipfile "#{node['rapid7']['windows_install_dir']}" do
    source "#{node['rapid7']['download_url']}#{node['rapid7']['windows_src']}"
    action :unzip
  end
  powershell_script "Install Agent" do
    cwd "#{node['rapid7']['windows_install_dir']}"
    code "msiexec /i agentInstaller-x86_64.msi /quiet"
  end
end

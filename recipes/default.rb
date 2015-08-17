#
# Cookbook Name:: sisense
# Recipe:: default
#

#Sisense depends on dotnet4.5 and VC++ 12.
#Installing of these should be in the role
# be include them here, just in case

include_recipe "iis"
include_recipe "iis::remove_default_site"
include_recipe "iis::mod_aspnet45"
include_recipe "jb-iis"
include_recipe "vcruntime::vc12"

powershell_script "restart-iis" do
  code "iisreset"
  action :nothing
end

#prism xml template
directory node['sisense']['config']['path'] do
  rights :full_control, 'Administrators'
  recursive true
end

template node['sisense']['config']['file'] do
  source 'PrismFeature.xml.erb'
  rights :full_control, 'Administrators'
end

install_file =  "#{Chef::Config[:file_cache_path]}/SiSenseLatestFull.exe"

log 'Sisense warn install' do
  action :nothing
  level :info
  message 'Installing SiSense, This could take a 5-10 mins....'
  subscribes :install,  "windows_package[SiSense]", :immediately
end

windows_package 'SiSense' do
  source  node['sisense']['install']['url']
  checksum node['sisense']['install']['checksum']
  version node['sisense']['install']['version']
  action :install
  installer_type :custom
  success_codes [0, 1, 42, 127]
  options "-username='#{node['sisense']['install']['user']}' -password='#{node['sisense']['install']['password']}' -x64 -q"
end

#update prism templates with mongodb host
#C:\Program Files\Sisense\PrismWeb\vnext\config\default.yaml
#AND
#C:\Program Files\Sisense\PrismWeb\App_Data\Configurations\db.config
#This config file contains a lot of secrets and connections strings.
#and seems like they might get updated at any moment or during an upgrade :-/
search = partial_search(:node, "role:#{node['sisense']['config']['frontend']['db']['search']}",
                         :keys => {'name' => ['fqdn'],
                                   'ip'   => ['ipaddress']
                                  }
                        )
if search.first
  db_host =  node['sisense']['config']['frontend']['db']['host'] || search.first['ip']
else
  db_host =  node['sisense']['config']['frontend']['db']['host'] || 'localhost'
end

directory node['sisense']['config']['frontend']['path'] do
  rights :full_control, 'Administrators'
  rights :full_control, 'IIS_IUSRS'
  rights :read_execute, 'Users'
  recursive true
  notifies :run, "powershell_script[restart-iis]", :delayed
end 

template node['sisense']['config']['frontend']['file'] do
  source 'default.yaml.erb'
  rights :full_control, 'Administrators'
  rights :full_control, 'IIS_IUSRS'
  rights :read_execute, 'Users'
  variables({
    :db_host => db_host,
    :db_port => node['sisense']['config']['frontend']['db']['port']
  }) 
  notifies :run, "powershell_script[restart-iis]", :delayed
end

directory node['sisense']['config']['frontend']['db']['config_path'] do
  rights :full_control, 'Administrators'
  rights :full_control, 'IIS_IUSRS'
  rights :read_execute, 'Users'
  recursive true
  notifies :run, "powershell_script[restart-iis]", :delayed
end 

template node['sisense']['config']['frontend']['db']['config_file'] do
  source 'db.config.erb'
  rights :full_control, 'Administrators'
  rights :full_control, 'IIS_IUSRS'
  rights :read_execute, 'Users'
  variables({
    :db_host => db_host,
    :db_port => node['sisense']['config']['frontend']['db']['port']
  }) 
  notifies :run, "powershell_script[restart-iis]", :delayed
end

#change bindings. 
# if this fails, Sisense didn't install
iis_site node['sisense']['iis']['site']['name'] do
  bindings node['sisense']['iis']['site']['bindings']
  action [:config]
end

#firewall rules
windows_firewall_rule 'ElasticubePorts' do
  localport "811,812"
  protocol :TCP
  firewall_action :allow
end


#setups and installs the "healthcheck" for sisense

#install python
include_recipe 'chocolatey'

#Add these paths before hand so they can be used by the shell
#If they are not set, you will need to reload the shell
#and rerun chef many times
windows_path node['python']['home'] do
  action :add
end
windows_path node['python']['scripts'] do
  action :add
end

chocolatey 'python2'
chocolatey 'easy.install'
chocolatey 'pip'


#Setup the healthcheck service
chocolatey 'nssm'

service "sisensecheck" do
 action :nothing
 start_command "nssm start sisensecheck"
 restart_command "nssm restart sisensecheck"
 stop_command "nssm stop sisensecheck"
 status_command "nssm status sisensecheck"
end

python_pip "Flask" do
  action :install
end

python_pip "Flask-Cache" do
  action :install
end

python_pip "PyJWT"  do
  action :install
end

directory node[:sisense][:healthcheck][:bin][:dir] do
  rights :read_execute, 'Everyone'
  rights :full_control, 'Administrators'
  action :create
  recursive true
end

template "#{node[:sisense][:healthcheck][:bin][:dir]}/#{node[:sisense][:healthcheck][:bin][:name]}" do
  source "sisensecheck.py.erb"
  rights :read_execute, 'Everyone'
  rights :full_control, 'Administrators'
  notifies :restart, 'service[sisensecheck]', :delayed
end

execute "add-sisensecheck-service" do
  command "nssm install sisensecheck python #{node[:sisense][:healthcheck][:bin][:dir]}/#{node[:sisense][:healthcheck][:bin][:name]}"
  returns [0,5]
end

#add firewall rule
windows_firewall_rule 'SisenseCheck' do
  localport node['sisense']['healthcheck']['listen']['port']
  protocol :TCP
  firewall_action :allow
end

service "sisensecheck" do
  action [ :enable, :start ]
end


#Install sisense plugins
directory node['sisense']['plugins']['path'] do
  rights :full_control, 'Administrators'
  rights :full_control, 'IIS_IUSRS'
  rights :read_execute, 'Users'
end

cookbook_file "#{node['sisense']['plugins']['path']}\\SendEmailAfterBuild.dll" do
  source "SendEmailAfterBuild.dll"
  rights :full_control, 'Administrators'
  rights :full_control, 'IIS_IUSRS'
  rights :read_execute, 'Users'
end

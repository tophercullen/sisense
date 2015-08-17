include_recipe "haproxy"
include_recipe "x509"

service = 'sisense'
members  = partial_search("node",
  "role:#{service} AND chef_environment:#{node.chef_environment}",
  :keys => {
     'healthcheck_port' => [ service, "healthcheck", "listen", "port" ],
     'name' => [ 'ipaddress' ],
     'tags' => [ 'tags' ]
      }) || []
for member in  members do
  if not member['healthcheck_port']
    members.delete(member)
  end
end


x509_certificate node['haproxy']['cert'] do 
  key node['haproxy']['cert']
  certificate node['haproxy']['cert']
  cn "Tester"
  bits 4096
  days 365
  not_if do ::File.exists?(node['haproxy']['cert']) end
end

template "#{node['haproxy']['conf_dir']}/haproxy.cfg" do
  source "haproxy-sisense.cfg.erb"
  owner "root"
  group "root"
  mode 00644
  variables(
    :members => members,
    :ssl_port => '443',
    :acls => node['sisense']['acls'],
    :defaults_options => haproxy_defaults_options,
    :defaults_timeouts => haproxy_defaults_timeouts
  )
  notifies :reload, "service[haproxy]"
end

service "haproxy" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end



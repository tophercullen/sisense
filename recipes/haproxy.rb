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


if not  ::File.exists?(node['haproxy']['cert'] )
  bash "gen temp ssl certs for testing" do
    code <<-EOS
        openssl genrsa -out /tmp/tmp.key 4096
        openssl req -subj "/C=US/ST=UT/L=SLC/O=Example/OU=IT/CN=Tester/emailAddress=noreply@example.com" -new -key /tmp/tmp.key -out /tmp/tmp.csr
        openssl x509 -req -days 365 -in /tmp/tmp.csr -signkey /tmp/tmp.key -out /tmp/tmp.crt
        cat /tmp/tmp.{key,crt,csr} >> #{node['haproxy']['cert']}
        rm -f /tmp/tmp.{csr,key,crt}
       EOS
    if not ::File.exists?(node['haproxy']['cert'])
     puts node['haproxy']['cert']
    end
  end
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



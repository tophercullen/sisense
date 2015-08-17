default['sisense']['install']['version'] = '5.8.0.1253'
#Different version checksums
default['sisense']['install']['5.8.0.1253']['checksum'] = 'e8351321634b4b0edda99b9436d68358127b96119007ecc55284bcfcedc9ba83'
default['sisense']['install']['5.7.7.515']['checksum'] = '55fc75e2d050cc72cb65786a9e26be14da6de9c181bb3ff127e7ff82318a2bc5'
default['sisense']['install']['url'] = "http://download.sisense.com/PrismInstallations/Full/Sisense.#{node['sisense']['install']['version']}.exe"
default['sisense']['install']['checksum'] = node['sisense']['install']["#{node['sisense']['install']['version']}"]['checksum']
default['sisense']['install']['user'] = 'myuser'
default['sisense']['install']['password'] = 'mypass'


#config settings
default['sisense']['config']['path'] = 'C:\\ProgramData\\sisense'
default['sisense']['config']['file'] = "#{node['sisense']['config']['path']}\\PrismFeature.xml"
default['sisense']['config']['frontend']['path'] = 'C:\\Program Files\\Sisense\\PrismWeb\\vnext\\config'
default['sisense']['config']['frontend']['file'] = "#{node['sisense']['config']['frontend']['path']}\\default.yaml"
default['sisense']['config']['frontend']['db']['search'] = 'sisense_mongodb'
default['sisense']['config']['frontend']['db']['host'] = nil
default['sisense']['config']['frontend']['db']['port'] = '27017' 
default['sisense']['config']['frontend']['db']['config_path'] = 'C:\\Program Files\\Sisense\\PrismWeb\\App_Data\\Configurations' 
default['sisense']['config']['frontend']['db']['config_file'] = "#{node['sisense']['config']['frontend']['db']['config_path']}\\db.config"

#Plugin settings
default['sisense']['plugins']['path'] = 'C:\\Program Files\\Sisense\\Prism\\Plugins'

#IIS settings
default['sisense']['iis']['site']['name'] = 'SiSenseWeb'
default['sisense']['iis']['site']['bindings'] = 'http/*:80:,https/*:443:'


#mongodb settings
force_default['mongodb']['install_method'] = 'mongodb-org'

#Healthcheck attributes
default['sisense']['healthcheck']['bin']['dir'] = 'C:\\inetpub\\sisensecheck'
default['sisense']['healthcheck']['bin']['name']  = 'sisensecheck.py'
default['sisense']['healthcheck']['listen']['address']  = '0.0.0.0'
default['sisense']['healthcheck']['listen']['port']  = '8888'
default['sisense']['healthcheck']['api']['user']  = node['sisense']['install']['user']
default['sisense']['healthcheck']['api']['password']  = node['sisense']['install']['password']
default['sisense']['healthcheck']['api']['key']  = 'myapikey'
default['sisense']['healthcheck']['api']['endpoint']  = '127.0.0.1'
default['sisense']['healthcheck']['api']['schema']  = 'http'
default['sisense']['healthcheck']['api']['port']  = '80'
default['sisense']['healthcheck']['api']['uri']  = '/api/elasticubes/servers/LocalHost/status'

# array of cubes we want to make sure are available, and fail if they are not
default['sisense']['healthcheck']['cubes']  = ["Sample Healthcare", "Sample ECommerce"]
default['sisense']['acls'] = {}

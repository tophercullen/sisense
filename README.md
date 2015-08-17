sisense Cookbook
================
Installs and configures the main SiSense application. 

Includes recipes for a basic multi application setup using mongodb and haproxy. 
Includes an optional python webapp that can be use for more advanced SiSense healthchecks. 

Default credentials will need to be updated to succesfully register a new application.

Requirements
------------
Requires Windows Server 2008 or 2012 for the main application and Linux for mongo and Haproxy. The following cookcooks are required.

 * 'mongodb'
 * 'iis'
 * 'windows'
 * 'vcruntime'
 * 'partial_search'
 * 'haproxy'
 * 'chocolatey'
 * 'windows_firewall'
 * 'x509'


Attributes
----------

#### Install
Default version will usually be ok. User and password will need to be updated
 * `node['sisense']['install']['version']`
 * `node['sisense']['install']['user']`
 * `node['sisense']['install']['password']`

### DB
Purposly set to nil as the recipe will search the environment for the role, check the value of the DB attribute and, if its nil will default to localhost
 * `node['sisense']['config']['frontend']['db']['host']`

### IIS
IIS port bindings. You will need to setup a cert before SSL will work. This is beyond the scope of this cookbook. See the windows_certificate_binding and windows_certificate resources in the windows cookbook.
 * `node['sisense']['iis']['site']['bindings']`

### Healthcheck
If using the healthcheck webapp, set the api key attribute. Note: the sisense api requires a user, password AND an api key to work. 
 * `node['sisense']['healthcheck']['api']['key']`

Usage
-----
#### SiSense
Just include `sisense` in your node's `run_list`:

```json
{
  "name":"sisense",
  "run_list": [
    "recipe[sisense]"
  ]
}
```

### Mongodb
```json
{
  "name":"sisense_mongodb",
  "run_list": [
    "recipe[sisense::mongodb]"
  ]
}
```

### Haproxy
```json
{
  "name":"sisense_haproxy",
  "run_list": [
    "recipe[sisense::haproxy]"
  ]

}
```

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Topher Cullen (topher.cullen@jamberry.com)

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

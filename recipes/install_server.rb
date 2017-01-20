#
# Cookbook Name:: ossec
# Recipe:: install_server
#
# Copyright 2015-2016, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'ossec::repository'

package 'ossec' do
  package_name value_for_platform_family('debian' => 'ossec-hids', 'default' => 'ossec-hids-server')
end

# Enable syslog
if node.default['ossec']['conf']['server']['syslog_output'] then
	execute 'ossec-enable-syslog' do
	  command "#{node['ossec']['dir']}/bin/ossec-control enable client-syslog"
	  not_if "#{node['ossec']['dir']}/bin/ossec-control status | grep syslog"
	  action :run
	  notifies :restart, 'service[ossec]'
	end
end

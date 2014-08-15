#
# Cookbook Name:: ratpoison
# Recipe:: windowmanager
#
# Copyright 2014, Shuberg Philis B.V.
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

include_recipe 'yum-epel'

package 'ratpoison'

ratpoison_binary = '/usr/bin/ratpoison'

template '/etc/init.d/ratpoison' do
  source 'ratpoison.init.d.erb'
  mode 00755
  variables(
    display:       node['ratpoison']['display'],
    screen:        node['ratpoison']['screen'],
    template_file: source.to_s,
    recipe_file:   (__FILE__).to_s.split('cookbooks/').last
  )
  notifies(:restart, 'service[ratpoison]')
end

service 'ratpoison' do
  pattern ratpoison_binary
  action [:start, :enable]
end

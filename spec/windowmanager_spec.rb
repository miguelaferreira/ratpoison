#
# Cookbook Name:: ratpoison
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

require 'chefspec'
require_relative 'spec_helper'

describe 'ratpoison::windowmanager' do
  let(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

  it 'includes the yum-epel cookbook' do
    expect(chef_run).to include_recipe('yum-epel')
  end

  init_script_file = '/etc/init.d/ratpoison'

  it "creates #{init_script_file} template" do
    expect(chef_run).to create_template(init_script_file)
      .with_mode(00755)
  end

  it "creates #{init_script_file} init script" do
    expect(chef_run).to render_file(init_script_file)
      .with_content("args=\"-d :0 -s 0\"")
  end

  it 'notifies ratpoison service to restart' do
    expect(chef_run.template(init_script_file)).to notify('service[ratpoison]')
      .to(:restart)
  end
end

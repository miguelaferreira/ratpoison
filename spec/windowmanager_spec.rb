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
require_relative 'spec_helper'

describe 'ratpoison::windowmanager' do
  context 'when installing on CentOS 6.6' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '6.6') do |node|
        node.set['ratpoison']['rpm']['file'] = 'some_dir/ratpoison.rpm'
        node.set['ratpoison']['rpm']['url']  = 'https://copr-be.cloud.fedoraproject.org/results/shassard/ratpoison/epel-7-x86_64/ratpoison-1.4.8-1.el7.centos/ratpoison-1.4.8-1.el7.centos.x86_64.rpm'
      end.converge(described_recipe)
    end

    it 'includes the yum-epel cookbook' do
      expect(chef_run).to include_recipe('yum-epel')
    end

    it 'does not download ratpoison rpm' do
      expect(chef_run).not_to create_remote_file(chef_run.node['ratpoison']['rpm']['file'])
    end

    it 'installs package retpoison' do
      expect(chef_run).to install_package('ratpoison')
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

    it 'starts the ratpoison service' do
      expect(chef_run).to start_service('ratpoison')
      expect(chef_run).to enable_service('ratpoison')
    end
  end

  context 'when installing on CentoOS 7.1' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '7.1.1503') do |node|
        node.set['ratpoison']['rpm']['file'] = 'some_dir/ratpoison.rpm'
        node.set['ratpoison']['rpm']['url']  = 'https://copr-be.cloud.fedoraproject.org/results/shassard/ratpoison/epel-7-x86_64/ratpoison-1.4.8-1.el7.centos/ratpoison-1.4.8-1.el7.centos.x86_64.rpm'
      end.converge(described_recipe)
    end

    it 'includes the yum-epel cookbook' do
      expect(chef_run).to include_recipe('yum-epel')
    end

    it 'downloads ratpoison rpm' do
      expect(chef_run).to create_remote_file(chef_run.node['ratpoison']['rpm']['file'])
    end

    it 'installs package retpoison' do
      expect(chef_run).to install_package('ratpoison')
        .with_source(chef_run.node['ratpoison']['rpm']['file'])
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

    it 'starts the ratpoison service' do
      expect(chef_run).to start_service('ratpoison')
      expect(chef_run).to enable_service('ratpoison')
    end
  end
end

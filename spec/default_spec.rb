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

describe 'ratpoison::default' do
  context 'when installing on CentOS 6.6' do
    let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'centos', version: '6.6').converge(described_recipe) }

    it 'includes the xvfb cookbook' do
      expect(chef_run).to include_recipe('xvfb')
    end

    it 'includes the ratpoison::windowmanager recipe' do
      expect(chef_run).to include_recipe('ratpoison::windowmanager')
    end
  end

  context 'when installing on CentoOS 7.1' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '7.1.1503') do |node|
        node.set['ratpoison']['rpm']['url'] = 'https://copr-be.cloud.fedoraproject.org/results/shassard/ratpoison/epel-7-x86_64/ratpoison-1.4.8-1.el7.centos/ratpoison-1.4.8-1.el7.centos.x86_64.rpm'
      end.converge(described_recipe)
    end

    it 'includes the xvfb cookbook' do
      expect(chef_run).to include_recipe('xvfb')
    end

    it 'includes the ratpoison::windowmanager recipe' do
      expect(chef_run).to include_recipe('ratpoison::windowmanager')
    end
  end
end

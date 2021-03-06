#
# Cookbook Name:: swift-private-cloud
# Recipe:: object-server
#
# Copyright 2012, Rackspace US, Inc.
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

include_recipe "swift-private-cloud::base"
include_recipe "swift-private-cloud::ring-common"
include_recipe "swift-private-cloud::storage-common"

include_recipe "swift-lite::object-server"

common = node["swift-private-cloud"]["swift_common"]

overrides = { "DEFAULT" => node["swift-private-cloud"]["swift_common"].select { |k, _| k.start_with?("log_statsd_") }}

if node["swift-private-cloud"]["object"] and node["swift-private-cloud"]["object"]["config"]
  overrides = overrides.merge(node["swift-private-cloud"]["object"]["config"]) { |k, x, y| x.merge(y) }
end

resources("template[/etc/swift/object-server.conf]").instance_exec do
  mode "0644"
  variables("config_options" => variables["config_options"].merge(overrides) { |k, x, y| x.merge(y) })
end

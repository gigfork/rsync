#
# Cookbook Name:: rsync
# Recipe:: ssh
#
# Copyright 2008-2009, Opscode, Inc.
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

include_recipe "rsync"
include_recipe "cron"

databags = node["rsync"]["ssh"]["databags"]

databags.each do |name|
  db = data_bag_item("rsync", name)
  db["jobs"].each do |job, value|
    u = node["rsync"]["ssh"]["user"]
    args = value["args"]
    s = value["source"]
    l = value["local"]
    m = value["minute"] || 30
    h = value["hour"] || "*"
    cmd = "rsync #{args} -e ssh #{job}:#{s} #{l}"
  
    directory l do
      owner u
      group u
      mode 00750
      action :create
    end

    cron_d name do
      minute m
      hour h
      user u
      command cmd
    end
  end
end

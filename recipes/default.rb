#
# Cookbook Name:: atlassian
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "java"


# for postgres

node['atlassian']['default']['packages'].each do |pkg,ver|
  package pkg do
    if ver == "latest"
      action :upgrade
    else
      action ver
    end
    ignore_failure true
  end
end


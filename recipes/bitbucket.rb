# Recipe to manage a bitbucket installation

include_recipe "atlassian"
include_recipe "nginx"


# Install required packages packages
node['atlassian']['bitbucket']['packages'].each do |pkg,ver|
  package pkg do
    if ver == "latest"
      action :upgrade
    else
      action ver
    end
    ignore_failure false
  end
end


# fetch bitbucket
wiki_pkg = node['atlassian']['bitbucket']['package']
download_path = "/root/#{wiki_pkg}"

remote_file "/root/#{node['atlassian']['bitbucket']['package']}" do
  source "#{node['atlassian']['bitbucket']['remote_url']}/#{node['atlassian']['bitbucket']['package']}"
  #checksum node['atlassian']['bitbucket']['package']
  mode "0644"
  not_if { ::File.exists?(download_path) }
end

file "/root/#{node['atlassian']['bitbucket']['package']}" do
  mode "0755"
  owner "root"
  group "root"
  only_if  { ::File.exists?(download_path) }
end


# Install the template file for an unattended install
template "/root/#{node['atlassian']['bitbucket']['answers_file']}" do
  source "bitbucket.response.varfile.erb"
end

execute "install-bitbucket" do
  command "/root/#{node['atlassian']['bitbucket']['package']} -q -varfile /root/#{node['atlassian']['bitbucket']['answers_file']}"
  not_if { ::File.exists?("#{node['atlassian']['bitbucket']['InstallDir']}") }
end


##
#
# Post-install configurations
#
##


# Install JDBC drivers if necessary
case node[:atlassian][:bitbucket][:database_type]
  when 'mysql'
    remote_file "#{node['atlassian']['bitbucket']['InstallDir']}/lib/#{node['atlassian']['mysql']['plugin_name']}" do
      source "#{node['atlassian']['mysql']['plugin_url']}/#{node['atlassian']['mysql']['plugin_name']}"
      mode 0644
      not_if { ::File.exists?("#{node['atlassian']['bitbucket']['InstallDir']}/lib/#{node['atlassian']['mysql']['plugin_name']}")}
      notifies :restart, 'service[atlbitbucket]'
    end
end

if node['atlassian']['bitbucket']['update_server_xml'] == true
  template "#{node['atlassian']['bitbucket']['bitbucketHome']}/shared/server.xml" do
    source "bitbucket_conf_server.xml.erb"
    notifies :restart, 'service[atlbitbucket]'
    only_if { ::File.exists?("#{node['atlassian']['bitbucket']['bitbucketHome']}/shared/server.xml")}
  end
end

# update keystore
if node['atlassian']['bitbucket']['update_keystore'] == true
  script "update-keystore" do
    interpreter "bash"
    code <<-EOH
#{node['atlassian']['bitbucket']['keytool_path']} -list -keystore #{node['atlassian']['bitbucket']['keystore_file']} -storepass #{node['atlassian']['bitbucket']['keystore_pass']} | grep #{node['atlassian']['bitbucket']['keytool_cert_alias']}

if [ $? -ne 0 ]
then
  echo "yes" | #{node['atlassian']['bitbucket']['keytool_path']} -import -trustcacerts -alias #{node['atlassian']['bitbucket']['keytool_cert_alias']} -file #{node['atlassian']['bitbucket']['crt_file']} -keystore #{node['atlassian']['bitbucket']['keystore_file']} -storepass #{node['atlassian']['bitbucket']['keystore_pass']}
fi
    EOH
    node.set_unless['atlassian']['bitbucket']['update_keystore'] = false
    #notifies :restart, 'service[atlbitbucket]'
    only_if { ::File.exists?("#{node['atlassian']['bitbucket']['crt_file']}") }
  end
end




service "atlbitbucket" do
  supports :start => true, :restart => true
  action [ :enable, :start ]
  restart_command "service atlbitbucket stop ; sleep 30; service atlbitbucket start"
end

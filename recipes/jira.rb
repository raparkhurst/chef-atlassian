# Recipe to manage a jira installation
include_recipe "atlassian"
include_recipe "nginx"

# fetch jira
wiki_pkg = node['atlassian']['jira']['package']
download_path = "/root/#{wiki_pkg}"

remote_file "/root/#{node['atlassian']['jira']['package']}" do
  source "#{node['atlassian']['jira']['remote_url']}/#{node['atlassian']['jira']['package']}"
  #checksum node['atlassian']['jira']['package']
  mode "0644"
  not_if { ::File.exists?(download_path) }
end

file "/root/#{node['atlassian']['jira']['package']}" do
  mode "0755"
  owner "root"
  group "root"
  only_if  { ::File.exists?(download_path) }
end


# Install the template file for an unattended install
template "/root/#{node['atlassian']['jira']['answers_file']}" do
  source "jira.response.varfile.erb"
end

execute "install-jira" do
  command "/root/#{node['atlassian']['jira']['package']} -q -varfile /root/#{node['atlassian']['jira']['answers_file']}"
  not_if { ::File.exists?("#{node['atlassian']['jira']['install_dir']}") }
end


# Install JDBC drivers if necessary
case node[:atlassian][:jira][:database_type]
  when 'mysql'
    remote_file "#{node['atlassian']['jira']['install_dir']}/lib/#{node['atlassian']['mysql']['plugin_name']}" do
      source "#{node['atlassian']['mysql']['plugin_url']}/#{node['atlassian']['mysql']['plugin_name']}"
      mode 0644
      not_if { ::File.exists?("#{node['atlassian']['jira']['install_dir']}/lib/#{node['atlassian']['mysql']['plugin_name']}")}
      notifies :restart, 'service[jira]'
    end
end


# WIP - may not support
#template "/var/atlassian/application-data/jira/dbconfig.xml" do
#  source "jira_dbconfig.xml.erb"
#  notifies :restart, 'service[jira]'
#end

if node['atlassian']['jira']['update_server_xml'] == true
  template "#{node['atlassian']['jira']['install_dir']}/conf/server.xml" do
    source "jira_conf_server.xml.erb"
    notifies :restart, 'service[jira]'
    only_if { ::File.exists?("/var/atlassian/application-data/jira/dbconfig.xml")}
  end
end


# update keystore
if node['atlassian']['jira']['update_keystore'] == true
script "update-keystore" do
  interpreter "bash"
  code <<-EOH
#{node['atlassian']['jira']['keytool_path']} -list -keystore #{node['atlassian']['jira']['keystore_file']} -storepass #{node['atlassian']['jira']['keystore_pass']} | grep #{node['atlassian']['jira']['keytool_cert_alias']}

if [ $? -ne 0 ]
then
  echo "yes" | #{node['atlassian']['jira']['keytool_path']} -import -trustcacerts -alias #{node['atlassian']['jira']['keytool_cert_alias']} -file #{node['atlassian']['jira']['crt_file']} -keystore #{node['atlassian']['jira']['keystore_file']} -storepass #{node['atlassian']['jira']['keystore_pass']}
fi
  EOH
  node.set_unless['atlassian']['jira']['update_keystore'] = false
  #notifies :restart, 'service[jira]'
  only_if { ::File.exists?("#{node['atlassian']['jira']['crt_file']}") }
end
end



service "jira" do
  supports :start => true, :restart => true
  action [ :enable, :start ]
  restart_command "service jira stop ; sleep 30; service jira start"
end



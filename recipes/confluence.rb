# Recipe to manage a confluence installation

include_recipe "atlassian"
include_recipe "nginx"


# fetch confluence
wiki_pkg = node['atlassian']['confluence']['package']
download_path = "/root/#{wiki_pkg}"

remote_file "/root/#{node['atlassian']['confluence']['package']}" do
  source "#{node['atlassian']['confluence']['remote_url']}/#{node['atlassian']['confluence']['package']}"
  #checksum node['atlassian']['confluence']['package']
  mode "0644"
  not_if { ::File.exists?(download_path) }
end

file "/root/#{node['atlassian']['confluence']['package']}" do
  mode "0755"
  owner "root"
  group "root"
  only_if  { ::File.exists?(download_path) }
end

template "/root/#{node['atlassian']['confluence']['answers_file']}" do
  source "confluence.response.varfile.erb"
end

execute "install-confluence" do
  command "/root/#{node['atlassian']['confluence']['package']} -q -varfile /root/#{node['atlassian']['confluence']['answers_file']}"
  not_if { ::File.exists?('/opt/atlassian/confluence') }
end




##
#
# Post install configurations
#
##


# Install JDBC drivers if necessary
case node[:atlassian][:confluence][:database_type]
  when 'mysql'
    remote_file "#{node['atlassian']['confluence']['install_dir']}/lib/#{node['atlassian']['mysql']['plugin_name']}" do
      source "#{node['atlassian']['mysql']['plugin_url']}/#{node['atlassian']['mysql']['plugin_name']}"
      mode 0644
      not_if { ::File.exists?("#{node['atlassian']['confluence']['install_dir']}/lib/#{node['atlassian']['mysql']['plugin_name']}")}
      notifies :restart, 'service[confluence]'
    end
end


if node['atlassian']['confluence']['update_server_xml'] == true
  template "#{node['atlassian']['confluence']['install_dir']}/conf/server.xml" do
    source "confluence_conf_server.xml.erb"
    notifies :restart, 'service[confluence]'
    only_if { ::File.exists?("#{node['atlassian']['confluence']['install_dir']}/conf/server.xml")}
  end
end


# update keystore
if node['atlassian']['confluence']['update_keystore'] == true
  script "update-keystore" do
    interpreter "bash"
    code <<-EOH
#{node['atlassian']['confluence']['keytool_path']} -list -keystore #{node['atlassian']['confluence']['keystore_file']} -storepass #{node['atlassian']['confluence']['keystore_pass']} | grep #{node['atlassian']['confluence']['keytool_cert_alias']}

if [ $? -ne 0 ]
then
  echo "yes" | #{node['atlassian']['confluence']['keytool_path']} -import -trustcacerts -alias #{node['atlassian']['confluence']['keytool_cert_alias']} -file #{node['atlassian']['confluence']['crt_file']} -keystore #{node['atlassian']['confluence']['keystore_file']} -storepass #{node['atlassian']['confluence']['keystore_pass']}
fi
    EOH
    node.set_unless['atlassian']['confluence']['update_keystore'] = false
    #notifies :restart, 'service[confluence]'
    only_if { ::File.exists?("#{node['atlassian']['confluence']['crt_file']}") }
  end
end


service "confluence" do
  supports :start => true, :restart => true
  action [ :enable, :start ]
end

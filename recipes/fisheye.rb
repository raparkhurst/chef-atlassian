# Recipe to manage a stash installation

include_recipe "atlassian"
include_recipe "nginx"
include_recipe "dx_ngx"

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless[:fisheye_dbuser_pw] = secure_password

postgresql_database node['atlassian']['fisheye']['db_name'] do
  connection(
    :host     => node['atlassian']['fisheye']['db_host'],
    :port     => 5432,
    :username => 'postgres',
    :password => node["postgresql"]["password"]["postgres"]
  )
  template 'DEFAULT'
  encoding 'DEFAULT'
  tablespace 'DEFAULT'
  connection_limit '-1'
  owner 'postgres'
  action :create
end


postgresql_connection_info = {
  :host     => node['atlassian']['fisheye']['db_host'],
  :port     => 5432,
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

database_user node['atlassian']['fisheye']['db_user'] do
  connection postgresql_connection_info
  password node[:fisheye_dbuser_pw]
  provider Chef::Provider::Database::PostgresqlUser
  action :create
end

postgresql_database_user node['atlassian']['fisheye']['db_user'] do
  connection postgresql_connection_info
  database_name node['atlassian']['fisheye']['db_name'] 
  privileges [:all]
  action :grant
end


# fetch fisheye
wiki_pkg = node['atlassian']['fisheye']['package']
download_path = "/root/#{wiki_pkg}"

remote_file "/root/#{node['atlassian']['fisheye']['package']}" do
  source "#{node['atlassian']['fisheye']['remote_url']}/#{node['atlassian']['fisheye']['package']}"
  checksum node['atlassian']['fisheye']['package']
  mode "0644"
  not_if { ::File.exists?(download_path) }
end

file "/root/#{node['atlassian']['fisheye']['package']}" do
  mode "0755"
  owner "root"
  group "root"
  only_if  { ::File.exists?(download_path) }
end


# Install the template file for an unattended install
#template "/root/response.varfile" do
#  source "fisheye.response.varfile.erb"
#end

#execute "install-fisheye" do
#  command "/root/#{node['atlassian']['fisheye']['package']} -q -varfile /root/response.varfile"
#  not_if { ::File.exists?('/opt/atlassian/fisheye') }
#end

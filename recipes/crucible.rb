# Recipe to manage a stash installation

include_recipe "atlassian"
include_recipe "nginx"
include_recipe "dx_ngx"

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless[:crucible_dbuser_pw] = secure_password

postgresql_database node['atlassian']['crucible']['db_name'] do
  connection(
    :host     => node['atlassian']['crucible']['db_host'],
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
  :host     => node['atlassian']['crucible']['db_host'],
  :port     => 5432,
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

database_user node['atlassian']['crucible']['db_user'] do
  connection postgresql_connection_info
  password node[:crucible_dbuser_pw]
  provider Chef::Provider::Database::PostgresqlUser
  action :create
end

postgresql_database_user node['atlassian']['crucible']['db_user'] do
  connection postgresql_connection_info
  database_name node['atlassian']['crucible']['db_name'] 
  privileges [:all]
  action :grant
end


# fetch crucible
wiki_pkg = node['atlassian']['crucible']['package']
download_path = "/root/#{wiki_pkg}"

remote_file "/root/#{node['atlassian']['crucible']['package']}" do
  source "#{node['atlassian']['crucible']['remote_url']}/#{node['atlassian']['crucible']['package']}"
  checksum node['atlassian']['crucible']['package']
  mode "0644"
  not_if { ::File.exists?(download_path) }
end

file "/root/#{node['atlassian']['crucible']['package']}" do
  mode "0755"
  owner "root"
  group "root"
  only_if  { ::File.exists?(download_path) }
end


# Install the template file for an unattended install
#template "/root/response.varfile" do
#  source "crucible.response.varfile.erb"
#end

#execute "install-crucible" do
#  command "/root/#{node['atlassian']['crucible']['package']} -q -varfile /root/response.varfile"
#  not_if { ::File.exists?('/opt/atlassian/crucible') }
#end

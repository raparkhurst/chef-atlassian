# Recipe to manage a artifact installation


include_recipe "nginx"
include_recipe "dx_ngx"

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless[:artifact_dbuser_pw] = secure_password

postgresql_database node['atlassian']['artifact']['db_name'] do
  connection(
    :host     => node['atlassian']['artifact']['db_host'],
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
  :host     => node['atlassian']['artifact']['db_host'],
  :port     => 5432,
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

database_user node['atlassian']['artifact']['db_user'] do
  connection postgresql_connection_info
  password node[:artifact_dbuser_pw]
  provider Chef::Provider::Database::PostgresqlUser
  action :create
end

postgresql_database_user node['atlassian']['artifact']['db_user'] do
  connection postgresql_connection_info
  database_name node['atlassian']['artifact']['db_name'] 
  privileges [:all]
  action :grant
end


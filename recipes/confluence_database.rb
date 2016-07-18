case node[:atlassian][:confluence][:database_type]
  when 'postgres'

    include_recipe "postgresql::client"

    chef_gem "pg" do
      action :install
    end

    ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
    node.set_unless['atlassian']['confluence']['database_password'] = secure_password
    node.set_unless['atlassian']['confluence']['database_name'] = node['atlassian']['confluence']['database_name']


    postgresql_database node['atlassian']['confluence']['database_name'] do
      connection(
          :host     => node['atlassian']['confluence']['database_host'],
          :port     => 5432,
          :username => 'postgres',
          :password => node["postgresql"]["postgres"]["password"]
      )
      template 'DEFAULT'
      encoding 'DEFAULT'
      tablespace 'DEFAULT'
      connection_limit '-1'
      owner 'postgres'
      action :create
    end


    postgresql_connection_info = {
        :host     => node['atlassian']['confluence']['database_host'],
        :port     => 5432,
        :username => 'postgres',
        :password => node['postgresql']['postgres']['password']
    }

    database_user node['atlassian']['confluence']['database_user'] do
      connection postgresql_connection_info
      password node['atlassian']['confluence']['database_password']
      provider Chef::Provider::Database::PostgresqlUser
      action :create
    end

    postgresql_database_user node['atlassian']['confluence']['database_user'] do
      connection postgresql_connection_info
      database_name node['atlassian']['confluence']['database_name']
      privileges [:all]
      action :grant
    end




  ### MySQL Connection follows
  else

    ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
    node.set_unless['atlassian']['confluence']['database_password'] = secure_password
    node.set_unless['atlassian']['confluence']['database_name'] = node['atlassian']['confluence']['database_name']


    mysql_connection_info = {
        :host     => node['atlassian']['confluence']['database_host'],
        :username => 'root',
        :password => node['mysql']['root']['password']
    }

    database node['atlassian']['confluence']['database_name'] do
      connection        mysql_connection_info
      provider          Chef::Provider::Database::Mysql
      action            :create
    end


    mysql_database_user node['atlassian']['confluence']['database_user'] do
      connection        mysql_connection_info
      password          node['atlassian']['confluence']['database_password']
      database_name     node['atlassian']['confluence']['database_name']
      provider          Chef::Provider::Database::MysqlUser
      host              '%'
      privileges        [:all]
      action            [:create,:grant]
    end



end


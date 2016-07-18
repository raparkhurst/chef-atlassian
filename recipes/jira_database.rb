case node[:atlassian][:jira][:database_type]
  when 'postgres'

    include_recipe "postgresql::ruby"
    include_recipe "postgresql::client"


    ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
    node.set_unless['atlassian']['jira']['database_password'] = secure_password
    node.set_unless['atlassian']['jira']['database_name'] = node['atlassian']['jira']['database_name']


    postgresql_database node['atlassian']['jira']['database_name'] do
      connection(
          :host     => node['atlassian']['jira']['database_host'],
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
        :host     => node['atlassian']['jira']['database_host'],
        :port     => 5432,
        :username => 'postgres',
        :password => node['postgresql']['postgres']['password']
    }

    database_user node['atlassian']['jira']['database_user'] do
      connection postgresql_connection_info
      password node['atlassian']['jira']['database_password']
      provider Chef::Provider::Database::PostgresqlUser
      action :create
    end

    postgresql_database_user node['atlassian']['jira']['database_user'] do
      connection postgresql_connection_info
      database_name node['atlassian']['jira']['database_name']
      privileges [:all]
      action :grant
    end




    ### MySQL Connection follows
  else

    ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
    node.set_unless['atlassian']['jira']['database_password'] = secure_password
    node.set_unless['atlassian']['jira']['database_name'] = node['atlassian']['jira']['database_name']


    mysql_connection_info = {
        :host     => node['atlassian']['jira']['database_host'],
        :username => 'root',
        :password => node['mysql']['root']['password']
    }

    database node['atlassian']['jira']['database_name'] do
      connection        mysql_connection_info
      provider          Chef::Provider::Database::Mysql
      action            :create
    end


    mysql_database_user node['atlassian']['jira']['database_user'] do
      connection        mysql_connection_info
      password          node['atlassian']['jira']['database_password']
      database_name     node['atlassian']['jira']['database_name']
      provider          Chef::Provider::Database::MysqlUser
      host              '%'
      privileges        [:all]
      action            [:create,:grant]
    end



end


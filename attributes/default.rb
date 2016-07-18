default['atlassian']['default']['packages'] = case node['platform_family']
                                                when 'debian'
                                                  {
                                                      "libpq-dev" => "latest"
                                                  }
                                                when 'rhel'
                                                  {

                                                  }
                                              end

default['atlassian']['mysql']['plugin_url'] = "http://repo.digitalsynapse.io/files"
default['atlassian']['mysql']['plugin_name'] = "mysql-connector-java-5.1.38-bin.jar"


# General / DB settings
default['atlassian']['bitbucket']['packages'] = case node['platform_family']
                                                  when 'debian'
                                                    {
                                                        "git" => "latest",
                                                        "git-flow" => "latest",
                                                        "git-core" => "latest",
                                                        "git-svn" => "latest",
                                                        "git-bzr" => "latest",
                                                        "git-cvs" => "latest"
                                                    }
                                                  when 'rhel'
                                                    {

                                                    }
                                                  else
                                                    {

                                                    }
                                                end



default['atlassian']['bitbucket']['database_type'] = "postgres"
default['atlassian']['bitbucket']['database_port'] = "3306"
default['atlassian']['bitbucket']['database_user'] = 'bitbucket'
default['atlassian']['bitbucket']['database_name'] = 'bitbucket_db'
default['atlassian']['bitbucket']['database_host'] = 'dbserver.example.com'
default['atlassian']['bitbucket']['version'] = "4.10.1"
default['atlassian']['bitbucket']['package'] = "atlassian-bitbucket-#{node['atlassian']['bitbucket']['version']}-x64.bin"
default['atlassian']['bitbucket']['remote_url'] = 'https://www.atlassian.com/software/stash/downloads/binary'
default['atlassian']['bitbucket']['answers_file'] = 'bitbucket_answers.varfile'


# Response file answers
default['atlassian']['bitbucket']['installService'] = "true"
default['atlassian']['bitbucket']['portChoice'] = "default"
default['atlassian']['bitbucket']['httpPort'] = "7990"
default['atlassian']['bitbucket']['serverPort'] = "8006"
default['atlassian']['bitbucket']['bitbucketHome'] = "/var/atlassian/application-data/bitbucket"
default['atlassian']['bitbucket']['installDirRoot'] = "/opt/atlassian/bitbucket/"
default['atlassian']['bitbucket']['InstallDir'] = "#{node['atlassian']['bitbucket']['installDirRoot']}/#{node['atlassian']['bitbucket']['version']}"
default['atlassian']['bitbucket']['install_dir'] = "#{node['atlassian']['bitbucket']['InstallDir']}"


# server.xml settings
default['atlassian']['bitbucket']['connectionTimeout'] = "20000"
default['atlassian']['bitbucket']['enableLookups'] = "false"
default['atlassian']['bitbucket']['protocol'] = "HTTP/1.1"
default['atlassian']['bitbucket']['useBodyEncodingForURI'] = "true"
default['atlassian']['bitbucket']['redirectPort'] = "443"
default['atlassian']['bitbucket']['proxyPort'] = "443"
default['atlassian']['bitbucket']['scheme'] = "https"
default['atlassian']['bitbucket']['contextPath'] = ""
default['atlassian']['bitbucket']['compression'] = "on"
default['atlassian']['bitbucket']['compressableMimeType'] = "text/html,text/xml,text/plain,text/css,application/json,application/javascript,application/x-javascript"
default['atlassian']['bitbucket']['secure'] = "true"
default['atlassian']['bitbucket']['proxyName'] = node['fqdn']


# keystore settings
default['atlassian']['bitbucket']['update_keystore'] = false
default['atlassian']['bitbucket']['keytool_path'] = "#{node['atlassian']['bitbucket']['install_dir']}/jre/bin/keytool"
default['atlassian']['bitbucket']['keytool_cert_alias'] = "mycert"
default['atlassian']['bitbucket']['crt_file'] = "/root/cert.crt"
default['atlassian']['bitbucket']['keystore_file'] = "#{node['atlassian']['bitbucket']['install_dir']}/jre/lib/security/cacerts"
default['atlassian']['bitbucket']['keystore_pass'] = "changeit"


default['atlassian']['bitbucket']['update_server_xml'] = false
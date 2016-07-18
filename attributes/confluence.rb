# General / Database settings
default['atlassian']['confluence']['database_type'] = "postgres"
default['atlassian']['confluence']['database_port'] = "3306"
default['atlassian']['confluence']['database_user'] = 'confluence'
default['atlassian']['confluence']['database_name'] = 'confluence_db'
default['atlassian']['confluence']['database_host'] = 'dbserver.example.com'
default['atlassian']['confluence']['package'] = 'atlassian-confluence-5.9.8-x64.bin'
default['atlassian']['confluence']['remote_url'] = 'http://www.atlassian.com/software/confluence/downloads/binary'
default['atlassian']['confluence']['answers_file'] = "confluence_answers.varfile"
default['atlassian']['confluence']['install_dir'] = "/opt/atlassian/confluence"


# Response file answers
default['atlassian']['confluence']['rmiPort'] = "8000"
default['atlassian']['confluence']['installService'] = "true"
default['atlassian']['confluence']['existingInstallationDir'] = "/usr/local/Confluence"
default['atlassian']['confluence']['updateInstallationString'] = "false"
default['atlassian']['confluence']['languageId'] = "en"
default['atlassian']['confluence']['InstallDir'] = "/opt/atlassian/confluence"
default['atlassian']['confluence']['confHome'] = "/var/atlassian/application-data/confluence"
default['atlassian']['confluence']['executeLauncherAction'] = "true"
default['atlassian']['confluence']['httpPort'] = "8090"
default['atlassian']['confluence']['portChoice'] = "default"


# server.xml settings
default['atlassian']['confluence']['port'] = "8090"
default['atlassian']['confluence']['maxHttpHeaderSize'] = "8192"
default['atlassian']['confluence']['maxThreads'] = "150"
default['atlassian']['confluence']['minSpareThreads'] = "25"
default['atlassian']['confluence']['maxSpareThreads'] = "75"
default['atlassian']['confluence']['enableLookups'] = "false"
default['atlassian']['confluence']['redirectPort'] = "8443"
default['atlassian']['confluence']['acceptCount'] = "100"
default['atlassian']['confluence']['connectionTimeout'] = "20000"
default['atlassian']['confluence']['disableUploadTimeout'] = "true"
default['atlassian']['confluence']['proxyPort'] = "443"
default['atlassian']['confluence']['scheme'] = "https"
default['atlassian']['confluence']['proxyName'] = node['fqdn']


# keystore settings
default['atlassian']['confluence']['update_keystore'] = false
default['atlassian']['confluence']['keytool_path'] = "#{node['atlassian']['confluence']['install_dir']}/jre/bin/keytool"
default['atlassian']['confluence']['keytool_cert_alias'] = "mycert"
default['atlassian']['confluence']['crt_file'] = "/root/cert.crt"
default['atlassian']['confluence']['keystore_file'] = "#{node['atlassian']['confluence']['install_dir']}/jre/lib/security/cacerts"
default['atlassian']['confluence']['keystore_pass'] = "changeit"

default['atlassian']['confluence']['update_server_xml'] = false
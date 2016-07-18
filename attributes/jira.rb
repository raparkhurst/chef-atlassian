# General / Database settings
default['atlassian']['jira']['database_type'] = "postgres"
default['atlassian']['jira']['database_port'] = "3306"
default['atlassian']['jira']['database_user'] = 'jira'
default['atlassian']['jira']['database_name'] = 'jira_db'
default['atlassian']['jira']['database_host'] = 'dbserver.example.com'
default['atlassian']['jira']['package'] = 'atlassian-jira-software-7.1.4-jira-7.1.4-x64.bin'
default['atlassian']['jira']['remote_url'] = 'https://www.atlassian.com/software/jira/downloads/binary'
default['atlassian']['jira']['answers_file'] = "jira_answers.varfile"
default['atlassian']['jira']['install_dir'] = "/opt/atlassian/jira"


# Response file answers
default['atlassian']['jira']['executeLauncherAction'] = "true"
default['atlassian']['jira']['installService'] = "true"
default['atlassian']['jira']['updateInstallationString'] = "false"
default['atlassian']['jira']['existingInstallationDir'] = "/opt/jira"
default['atlassian']['jira']['languageId'] = "en"


# server.xml settings
default['atlassian']['jira']['port'] = "8080"
default['atlassian']['jira']['maxThreads'] = "150"
default['atlassian']['jira']['minSpareThreads'] = "25"
default['atlassian']['jira']['connectionTimeout'] = "20000"
default['atlassian']['jira']['enableLookups'] = "false"
default['atlassian']['jira']['maxHttpHeaderSize'] = "8192"
default['atlassian']['jira']['protocol'] = "HTTP/1.1"
default['atlassian']['jira']['useBodyEncodingForURI'] = "true"
default['atlassian']['jira']['redirectPort'] = "8443"
default['atlassian']['jira']['acceptCount'] = "100"
default['atlassian']['jira']['disableUploadTimeout'] = "true"
default['atlassian']['jira']['proxyPort'] = "443"
default['atlassian']['jira']['scheme'] = "https"
default['atlassian']['jira']['contextPath'] = ""
default['atlassian']['jira']['proxyName'] = node['fqdn']


# keystore settings
default['atlassian']['jira']['update_keystore'] = false
default['atlassian']['jira']['keytool_path'] = "#{node['atlassian']['jira']['install_dir']}/jre/bin/keytool"
default['atlassian']['jira']['keytool_cert_alias'] = "mycert"
default['atlassian']['jira']['crt_file'] = "/root/cert.crt"
default['atlassian']['jira']['keystore_file'] = "#{node['atlassian']['jira']['install_dir']}/jre/lib/security/cacerts"
default['atlassian']['jira']['keystore_pass'] = "changeit"


default['atlassian']['jira']['update_server_xml'] = true
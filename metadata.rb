name             'atlassian'
maintainer       'Digital Synapse, LLC'
maintainer_email 'raparkhurst@digitalsynapse.io'
license          'All rights reserved'
description      'Installs/Configures atlassian'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.6.5'

depends "ds-base"
depends "jenkins"
depends "java"
depends "nginx"
depends "database"
depends "postgresql"
depends "mysql"

%w{ ubuntu debian rhel centos amazon }.each do |os|
  supports os
end

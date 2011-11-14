maintainer       "Pavel Snagovsky"
maintainer_email "paha01@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures users and groups"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

%w{redhat centos ubuntu amazon}.each do |os|
  supports os
end

name 'analgesic'
maintainer 'Denis Pischuhin'
maintainer_email 'pischuhin@gmail.com'
license 'MIT'
description 'Installs/Configures analgesic'
long_description 'Installs/Configures analgesic'
version '0.1.0'
chef_version '>= 14.0'
%w(aix amazon centos fedora freebsd debian oracle mac_os_x redhat suse opensuse opensuseleap ubuntu windows zlinux).each do |os|
  supports os
end

issues_url 'https://github.com/redj45/analgesic/issues'
source_url 'https://github.com/redj45/analgesic'

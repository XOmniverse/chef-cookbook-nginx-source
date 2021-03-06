name 'nginx-source'
maintainer 'Shawn Huckabay '
maintainer_email 'shawn.huckabay@gmail.com'
license 'All Rights Reserved'
description 'Installs Nginx from Source'
long_description 'Installs Nginx from Source'
version '0.3.1'
chef_version '>= 12.1' if respond_to?(:chef_version)
supports 'ubuntu', '16.04'
depends 'apt'
depends 'ohai'
issues_url 'https://github.com/XOmniverse/chef-cookbook-nginx-source'
source_url 'https://github.com/XOmniverse/chef-cookbook-nginx-source'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/nginx-source/issues'

# The `source_url` points to the development reposiory for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/nginx-source'

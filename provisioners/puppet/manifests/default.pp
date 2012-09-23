# Main settings. (Some of them should be loaded from a external file)
$candw_site_domain = "example.local"

$candw_database_user = "root"
$candw_database_password = "rootpass"
$candw_database_name = $candw_site_domain

$candw_vcsrepo_provider = "git"
$candw_vcsrepo_source = "git@github.com:acontia/context_easy.git"
$candw_vcsrepo_branch = "7.x-1.x-dev"


# Add a stage which precedes the main installation routine.
stage {"pre": before => Stage["main"]}

# Ensure apt updates before running the main installation routine.
class {'apt': stage => 'pre'}

# Services used to run Drupal.
class {'apache':  }
class { 'mysql::server': 
  config_hash => { 'root_password' => $candw_database_password }
}

# PHP and a bunch of PHP extensions.
package { 'php5': }
package { 'php5-cli': }
package { 'php-apc': }
package { 'php5-curl': }
package { 'php5-gd': }
package { 'php5-mcrypt': }
package { 'php5-memcache': }
package { 'php5-memcached': }
package { 'php5-mysql': }
package { 'php5-xsl': }

package { 'php-pear': }

phpundeprecate {'/etc/php5/conf.d/mcrypt.ini':
  file => '/etc/php5/conf.d/mcrypt.ini',
  require => Package['php5-mcrypt'],
}

# Configure Apache Virtual Hosts
$site_root = "/vagrant/site"
$site_docroot = "${site_root}/docroot"
$site_logroot = "${site_root}/logroot"

file { $site_root:
  ensure => directory
}

file { $site_docroot:
  ensure => directory
}

file { $site_logroot:
  ensure => directory
}

apache::vhost { $candw_site_domain:
    priority        => '10',
    vhost_name      => '*',
    port            => '80',
    docroot         => $site_docroot,
    logroot         => $site_logroot,
    serveradmin     => "admin@${candw_site_domain}",
    serveraliases   => ["www.${candw_site_domain}",],
}


# Import code from repository
vcsrepo { "vcsrepo_${candw_site_domain}":
  ensure   => latest,
  provider => git,
  source   => $candw_vcsrepo_source,
  path     => $site_docroot,
}


# Creates database
mysql::db { $candw_database_name:
  user     => $candw_database_user,
  password => $candw_database_password,
  host     => 'localhost',
  grant    => ['all'],
}

# Import database



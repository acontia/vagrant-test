# Add a stage which precedes the main installation routine.
stage {"pre": before => Stage["main"]}

# Ensure apt updates before running the main installation routine.
class {'apt': stage => 'pre'}

# Services used to run Drupal.
class {'apache':  }
package { 'mysql-server': }

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

# Configure Virtual Host                ]
$site_domain = 'example.com'
$site_docroot = "/vagrant/${site_domain}/docroot/"
$site_logroot = "/vagrant/${site_domain}/logroot/"

file { $site_docroot:
  ensure => directory
}

file { $site_logroot:
  ensure => directory
}

apache::vhost { $site_domain:
    priority        => '10',
    vhost_name      => '192.0.2.1',
    port            => '80',
    docroot         => $site_docroot,
    logroot         => $site_logroot,
    serveradmin     => 'admin@${site_domain}',
}


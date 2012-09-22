# Add a stage which precedes the main installation routine.
  stage {"pre": before => Stage["main"]}

# Ensure apt updates before running the main installation routine.
class {'apt': stage => 'pre'}

# Services used to run Drupal.
  package { 'apache2': }
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

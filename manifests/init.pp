# == Class: mod_auth_cas
class mod_auth_cas (
  $loginurl,
  $validateurl,
  $proxyvalidateurl,
  $certificatepath = $::mod_auth_cas::params::certificatepath,
  $path = '/cas',
  $version = 1,
  $debug = 'Off',
) inherits mod_auth_cas::params {

  # Validate parameters
  validate_re($debug, '^O(n|ff)$', '$debug must be On or Off')
  validate_integer($version)
  validate_absolute_path($certificatepath)
  validate_absolute_path($path)

  # Include basic apache machinery
  include apache

  # Call upon custom apache::mod
  apache::mod { 'auth_cas':
    package => $::mod_auth_cas::params::package,
  }

  $apache_user  = $::osfamily ? {
    'Debian' => 'www-data',
    default  => 'apache',
  }

  $apache_group = $::osfamily ? {
    'Debian' => 'www-data',
    default  => 'apache',
  }

  # Install site-specific config file
  file { 'auth_cas.conf':
    name    => "${::mod_auth_cas::params::configpath}/auth_cas.conf",
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('mod_auth_cas/auth_cas.conf.erb'),
    notify  => Service['httpd'],
    require => Package['httpd'],
  }

  # Prepare the CAS cache directory
  file { [ $path, "${path}/cache"] :
    ensure  => directory,
    owner   => 'root',
    group   => $apache_group,
    mode    => '0775',
    seluser => 'system_u',
    seltype => 'httpd_sys_rw_content_t',
    selrole => 'object_r',
  }

  # Don't create it, but do set security context
  file { "${path}/cache/.metadata":
    owner   => $apache_user,
    group   => $apache_group,
    mode    => '0600',
    seluser => 'system_u',
    seltype => 'httpd_sys_rw_content_t',
    selrole => 'object_r',
  }
}

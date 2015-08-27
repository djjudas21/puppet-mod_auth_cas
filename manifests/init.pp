# == Class: mod_auth_cas
class mod_auth_cas (
  $certificatepath = $::mod_auth_cas::params::certificatepath,
  $loginurl,
  $validateurl,
  $proxyvalidateurl,
  $path = '/cas',
  $version = 1,
  $debug = 'Off',
  $validateserver = 'On',
) {
  # Include basic apache machinery
  include apache

  # Call upon custom apache::mod
  apache::mod { 'auth_cas':
    package => $::mod_auth_cas::params::package,
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
    group   => 'apache',
    mode    => '0775',
    seluser => 'system_u',
    seltype => 'httpd_sys_rw_content_t',
    selrole => 'object_r',
  }

  # Don't create it, but do set security context
  file { "${path}/cache/.metadata":
    owner   => 'apache',
    group   => 'apache',
    mode    => '0600',
    seluser => 'system_u',
    seltype => 'httpd_sys_rw_content_t',
    selrole => 'object_r',
  }
}

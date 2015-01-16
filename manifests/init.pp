# == Class: mod_auth_cas
#
# Full description of class mod_auth_cas here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'mod_auth_cas':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Copyright
#
# Copyright 2015 Jonathan Gazeley, unless otherwise noted.
#
class mod_auth_cas (
  $cacert,
) {

  package {'mod_auth_cas': ensure => installed}

  file { 'auth_cas.conf':
    name    => '/etc/httpd/conf.d/auth_cas.conf',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/httpd/mod_auth_cas/auth_cas.conf',
    notify  => Service['httpd'],
    require => Package['httpd'],
    }

  # Prepare the CAS cache directory
  file { [ '/cas', '/cas/cache'] :
    ensure  => directory,
    owner   => 'root',
    group   => 'apache',
    mode    => '0775',
    seluser => 'system_u',
    seltype => 'httpd_sys_content_t',
    selrole => 'object_r',
  }

  # Don't create it, but do set security context
  file { '/cas/cache/.metadata':
    owner   => 'apache',
    group   => 'apache',
    mode    => '0600',
    seluser => 'system_u',
    seltype => 'httpd_sys_content_t',
    selrole => 'object_r',
  }
}

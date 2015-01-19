# == Class: mod_auth_cas
class mod_auth_cas (
  $certificatepath,
  $loginurl,
  $validateurl,
  $proxyvalidateurl,
  $path = '/cas',
  $version = 1,
) {

  package { 'mod_auth_cas':
    ensure => installed,
    name   => $::osfamily ? {
      'RedHat' => 'mod_auth_cas',
      'Debian' => 'libapache2-mod-auth-cas',
      default  => 'mod_auth_cas',
    },
  }

  file { 'auth_cas.conf':
    name    => $::osfamily ? {
      'RedHat' => '/etc/httpd/conf.d/auth_cas.conf',
      'Debian' => '/etc/apache2/conf-enabled/auth_cas.conf',
      default  => '/etc/httpd/conf.d/auth_cas.conf',
    },
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/httpd/mod_auth_cas/auth_cas.conf',
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
    seltype => 'httpd_sys_content_t',
    selrole => 'object_r',
  }

  # Don't create it, but do set security context
  file { "${path}/cache/.metadata":
    owner   => 'apache',
    group   => 'apache',
    mode    => '0600',
    seluser => 'system_u',
    seltype => 'httpd_sys_content_t',
    selrole => 'object_r',
  }
}

# == Class: mod_auth_cas
class mod_auth_cas (
  $certificatepath,
  $loginurl,
  $validateurl,
  $proxyvalidateurl,
  $path = '/cas',
  $version = 1,
) {
  # Include basic apache machinery
  include apache

  # Figure out the package name for our distro
  $package = $::osfamily ? {
    'RedHat' => 'mod_auth_cas',
    'Debian' => 'libapache2-mod-auth-cas',
    default  => 'mod_auth_cas',
  }

  # Call upon custom apache::mod
  apache::mod { 'auth_cas':
    package => $package,
  }

  # Install site-specific config file
  file { 'auth_cas.conf':
    name    => $::osfamily ? {
      'RedHat' => '/etc/httpd/conf.d/auth_cas.conf',
      'Debian' => '/etc/apache2/conf-enabled/auth_cas.conf',
      default  => '/etc/httpd/conf.d/auth_cas.conf',
    },
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

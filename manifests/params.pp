# Class parameters
class mod_auth_cas::params {

  # Default CA location
  $certificatepath = $::osfamily ? {
    'Debian' => '/etc/ssl/certs/ca-certificates.crt',
    'RedHat' => '/etc/pki/tls/certs/ca-bundle.crt',
    default  => '/etc/pki/tls/certs/ca-bundle.crt',
  }

  # Package name for our distro
  $package = $::osfamily ? {
    'RedHat' => 'mod_auth_cas',
    'Debian' => 'libapache2-mod-auth-cas',
    default  => 'mod_auth_cas',
  }

  # Config path for our distro
  $configpath = $::osfamily ? {
    'RedHat' => '/etc/httpd/conf.d',
    'Debian' => '/etc/apache2/mods-available',
    default  => '/etc/httpd/conf.d',
  }
}

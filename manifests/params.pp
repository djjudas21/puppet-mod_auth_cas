# Class parameters
class mod_auth_cas::params {

  # Default CA location
  $certificatepath = $::osfamily ? {
    'Debian' => '/etc/ssl/certs/ca-certificates.crt',
    'RedHat' => '/etc/pki/tls/certs/ca-bundle.crt',
    default  => '/etc/pki/tls/certs/ca-bundle.crt',
  }

}

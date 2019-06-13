# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include sqlcli
#
# @param [String] db_db_owner_password 
#   The password of the database owner user
#
class sqlcli (
  $version = '0.7.1',
) {

  #https://github.com/xo/usql/releases/download/v0.7.1/usql-0.7.1-linux-amd64.tar.bz2

  include 'archive'

  $install_path        = '/opt/usql'
  $package_name        = 'usql'
  $repository_url      = "https://github.com/xo/usql/releases/download/v${version}"
  $archive_name        = "${package_name}-${version}-linux-amd64.tar.bz2"
  $usql_package_source = "${repository_url}/${archive_name}"

  package {'bzip2':
    ensure => present,
  }

  package {'golang':
    ensure => present,
  }

  file{$install_path:
    ensure => directory,
  }

  exec {'/usr/bin/go get -u github.com/xo/usql':
    require     => Package['golang'],
    environment => ['GOPATH=/root/go'],
    timeout     => '1200',
    creates     => '/root/go/bin/usql'
  }

  -> file { "${install_path}/usql":
    ensure => link, 
    target => '/root/go/bin/usql',
  }


  /*
  -> archive { $archive_name:
    path         => "/tmp/${archive_name}",
    source       => $usql_package_source,
    extract      => true,
    extract_path => $install_path,
    creates      => "${install_path}/usql",
    cleanup      => true,
    require      => [Package['bzip2'],Package['libicu']],
  }*/

}

# This class installs the required tools to use sqlcli
#
# @summary This class installs the required tools to use sqlcli
#
# @example
#   include sqlcli
#
# @param [String] version 
#   Version of the usql instalation defaults to 0.7.1
#
class sqlcli (
  $version = '0.7.1',
) {

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


}

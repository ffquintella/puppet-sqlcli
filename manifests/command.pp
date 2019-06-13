# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   sqlcli::command { 'namevar': }
#
# @param [Hash] database_connection 
#   A hash containing the details to the database connection
#
# @option database_connection [String] db_type
#   The type of the database it can be mssql, mysql, oracle, pgsql
# @option database_connection [String] db_user
#   The username to connect to the database
# @option database_connection [String] db_pwd
#   The database password
# @option database_connection [String] db_hostname
#   The database hostname
# @option database_connection [String] db_port
#   The database port 
# @option database_connection [String] db_schema
#   The database schema
#
# @param [Boolean] run_once 
#   If the command is to be run only once
#
# @param [String] command 
#   If the command to be executed
#
define sqlcli::command(
  Hash $database_connection = undef,
  Boolean $run_once = true,
  String $command = $title,
) {

  Exec {
    path => ['/opt/usql','/usr/bin', '/sbin', '/bin', '/usr/sbin', '/usr/local/bin']
  }

  file{'/var/run/puppetlabs/.sqcli_ctrl':
    ensure => directory,
  }

  $usql_cmd = ''


  if $run_once {
    $hash = md5($command)
    $final_usql_cmd = "${usql_cmd}; touch /var/run/puppetlabs/.sqcli_ctrl/${hash}"
  }
  else {
    $hash = '--'
    $final_usql_cmd = $usql_cmd
  }

}

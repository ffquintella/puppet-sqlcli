# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   sqlcli::script { 'select * from foo': 
#      database_connection => { 
#             'db_type' => 'mssql',
#             'db_user' => 'tuser',
#             'db_pwd'  => '123',
#             'db_hostname' => 'superdb',
#             'db_port' => 1433,
#             'db_schema' => 'schm1',
#      },
#      script_file => '/tmp/script.sql',
#   }
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
# @option database_connection [String] db_name
#   The database schema
# @option database_connection [String] ccm_srvc (optional)
#   The ccm srvc dns record
# @option database_connection [String] ccm_key (optional)
#   The ccm key record to get 
# @option database_connection [String] ccm_env (optional)
#   The ccm environment 
# @option database_connection [String] ccm_api_key (optional)
#   The ccm api key record to get 
#
# @param [Boolean] run_once 
#   If the command is to be run only once
#
# @param [Boolean] use_ccm_integration 
#   If you wish to use ccm integration to store the passwords
#
# @param [String] script_file 
#   The path to the script file
#
define sqlcli::script (
  Hash $database_connection = undef,
  Boolean $run_once = true,
  Boolean $use_ccm_integration = false,
  String $script_file = $title,
) {


  Exec {
    path => ['/opt/usql','/usr/bin', '/sbin', '/bin', '/usr/sbin', '/usr/local/bin']
  }

  if !defined(File['/var/run/puppetlabs/.sqcli_ctrl']){
    file{'/var/run/puppetlabs/.sqcli_ctrl':
      ensure => directory,
    }
  }

  $db_type = $database_connection['db_type']
  $db_user = $database_connection['db_user']
  $db_pwd = $database_connection['db_pwd']
  $db_hostname = $database_connection['db_hostname']
  $db_port = $database_connection['db_port']
  $db_name = $database_connection['db_name']

  if $use_ccm_integration {
    $ccm_srvc = $database_connection['ccm_srvc']
    $ccm_key = $database_connection['ccm_key']
    $ccm_env = $database_connection['ccm_env']
    $ccm_api_key = $database_connection['ccm_api_key']
    if !defined(Class['ccm_cli::api']){
      class {'ccm_cli::api':
        ccm_srv_record => $ccm_srvc,
      }
    }
    $usql_cmd = "CCMPWD=$(/usr/share/ccm/ccm_reader.rb ${ccm_api_key} credential ${ccm_key} ${ccm_env}); usql ${db_type}://${db_user}:\$CCMPWD@${db_hostname}:${db_port}/${db_name} -f \"${script_file}\""
  }else{
    # usql mssql://user:pass@host:port/dbname
    $usql_cmd = "usql ${db_type}://${db_user}:${db_pwd}@${db_hostname}:${db_port}/${db_name} -f \"${script_file}\""
  }

  if $run_once {
    $hash = md5($usql_cmd)
    $final_usql_cmd = "${usql_cmd}; touch /var/run/puppetlabs/.sqcli_ctrl/${hash}"
  }
  else {
    $hash = '--'
    $final_usql_cmd = $usql_cmd
  }
  if $use_ccm_integration {
    exec { "ExecuteSqlScript_${$title}":
      command => $final_usql_cmd,
      cwd     => '/opt/usql',
      creates => "/var/run/puppetlabs/.sqcli_ctrl/${hash}",
      require => Class['ccm_cli::api'],
    }
  }else{
    exec { "ExecuteSqlScript_${$title}":
      command => $final_usql_cmd,
      cwd     => '/opt/usql',
      creates => "/var/run/puppetlabs/.sqcli_ctrl/${hash}",
    }
  }


}

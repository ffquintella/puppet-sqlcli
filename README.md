
# sqlcli

This module acts as a SQL client to allow the execution of comands on differente databases

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with sqlcli](#setup)
    * [What sqlcli affects](#what-sqlcli-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with sqlcli](#beginning-with-sqlcli)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This module acts as a SQL client to allow the execution of comands on differente databases

## Setup

### What sqlcli affects 

This module will install usql (https://github.com/xo/usql) to use it as it's base.

It will also install golang as it is needed.


### Beginning with sqlcli

To use the module yum must firts include de base class to be shure the instalation is done then you can use the defined types avaliable.

```
include sqlcli

```

## Usage

There defined types are described bellow:

Execute
This type executes a command

```
sqlcli::command { 'select * from foo': 
  database_connection => { 
          'db_type' => 'mssql',
          'db_user' => 'tuser',
          'db_pwd'  => '123',
          'db_hostname' => 'superdb',
          'db_port' => 1433,
          'db_schema' => 'schm1',
  },
  run_once = true,
}
```

```
sqlcli::script { '/tmp/script.sql': 
  database_connection => { 
          'db_type' => 'mssql',
          'db_user' => 'tuser',
          'db_pwd'  => '123',
          'db_hostname' => 'superdb',
          'db_port' => 1433,
          'db_schema' => 'schm1',
  },
  run_once = true,
}
```

## Reference

All the parameters are described in [doc/REFERENCES.md](https://github.com/ffquintella/puppet-sqlcli/blob/master/doc/REFERENCES.md)

## Limitations

TBD

## Development

We try to keep our modules as tested as possible and follow the lint sugestion. So before submitting any pull request, please run the unit tests and validation



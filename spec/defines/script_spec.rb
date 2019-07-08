require 'spec_helper'

describe 'sqlcli::script' do
  let(:title) { '/tmp/script.sql' }
  let(:params) do
    {
      database_connection: {
        db_type: 'mssql',
        db_user: 'test',
        db_pwd: 'test123',
        db_hostname: 'host1',
        db_port: '1433',
        db_name: 'test1',
        ccm_srvc: 'srvc.test.com',
        ccm_key: 'test:db1',
        ccm_env: 'Desenvolvimento',
        ccm_api_key: 'DSFGSDJGFDSHFDFSDF',
      },
      run_once: false,
      use_ccm_integration: true,
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_class('ccm_cli::api') }
      it { is_expected.to contain_file('/var/run/puppetlabs/.sqcli_ctrl') }
      it {
        is_expected.to contain_exec('ExecuteSqlScript_/tmp/script.sql')
          .with(
            'command' => 'CCMPWD=$(/usr/share/ccm/ccm_reader.rb DSFGSDJGFDSHFDFSDF credential test:db1 Desenvolvimento); usql mssql://test:$CCMPWD@host1:1433/test1 -f "/tmp/script.sql"',
            'cwd' => '/opt/usql',
          )
      }
    end
  end
end

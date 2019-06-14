require 'spec_helper'

describe 'sqlcli::command' do
  let(:title) { 'select * from boo' }
  let(:params) do
    {
      database_connection: {
        db_type: 'mssql',
        db_user: 'test',
        db_pwd: 'test123',
        db_hostname: 'host1',
        db_port: '1433',
        db_name: 'test1',
      },
      run_once: false,
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_file('/var/run/puppetlabs/.sqcli_ctrl') }
      it {
        is_expected.to contain_exec('ExecuteSqlCmd_select * from boo')
          .with(
            'command' => 'usql mssql://test:test123@host1:1433/test1 -c "select * from boo"',
            'cwd' => '/opt/usql',
          )
      }
    end
  end
end

require 'spec_helper'

describe 'sqlcli::command' do
  let(:title) { 'select * from boo' }
  let(:params) do
    {
      database_connection: {
        db_type: 'mssql',
        db_user: 'test',
        dp_pwd: 'test123',
        db_hostname: 'host1',
        db_port: '1433',
        db_schema: 'test1',
      },
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end

require 'spec_helper'

describe 'sqlcli' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:params) do
        {
          version: '0.7.1',
        }
      end

      it { is_expected.to compile }
      # it { is_expected.to contain_class('archive') }
      it { is_expected.to contain_package('golang') }
      it { is_expected.to contain_file('/opt/usql') }
      it { is_expected.to contain_file('/opt/usql/usql') }
    end
  end
end

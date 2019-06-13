require 'spec_helper'

describe 'sqlcli' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:params) do
        {
          version: '0.7.1',
        }

      it { is_expected.to compile }
      it { is_expected.to contain_class('archive') }
      it { is_expected.to contain_file('/opt/usql') }
    end
  end
end

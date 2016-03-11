require 'spec_helper'
describe 'mod_auth_cas' do

  context 'on RedHat' do

    let(:facts) do
      {
        operatingsystemrelease: '6.1',
        osfamily: 'RedHat'
      }
    end

    let(:params) do
      {
        loginurl: 'https://example.com/cas/login',
        proxyvalidateurl: nil,
        validateurl: 'https://example.com/cas/validate'
      }
    end
    
    it { should contain_class('mod_auth_cas') }

    it { should contain_file('/cas').with_group('apache') }

  end

end

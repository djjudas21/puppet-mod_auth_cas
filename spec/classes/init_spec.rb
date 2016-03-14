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
    
    it { should contain_file('/cas/cache').with_group('apache') }

    it do
      should contain_file('/cas/cache/.metadata').with({
        owner: 'apache',
        group: 'apache'
      })
    end
    
    it do
      should contain_file('auth_cas.conf').with({
        path: '/etc/httpd/conf.d/auth_cas.conf',
        content: /LoadModule\ ssl_module\ modules\/mod_ssl\.so/
      })
    end

  end

  context 'on Debian-based/Ubuntu' do

    let(:facts) do
      {
        operatingsystemrelease: '14.04',
        osfamily: 'Debian',
        operatingsystem: 'Ubuntu'
      }
    end

    let(:params) do
      {
        loginurl: 'https://example.com/cas/login',
        proxyvalidateurl: nil,
        validateurl: 'https://example.com/cas/validate'
      }
    end

    it { should contain_file('/cas').with_group('www-data') }

    it { should contain_file('/cas/cache').with_group('www-data') }

    it do
      should contain_file('/cas/cache/.metadata').with({
        owner: 'www-data',
        group: 'www-data'
      })
    end

    it do
      should contain_file('auth_cas.conf').with({
        path: '/etc/apache2/mods-available/auth_cas.conf',
        content: /LoadModule\ ssl_module\ \/usr\/lib\/apache2\/modules\/mod_ssl\.so/
      })
    end

  end

end

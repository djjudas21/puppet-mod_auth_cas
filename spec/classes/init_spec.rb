require 'spec_helper'
describe 'mod_auth_cas' do

  context 'with defaults for all parameters' do
    it { should contain_class('mod_auth_cas') }
  end
end

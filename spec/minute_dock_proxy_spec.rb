require 'spec_helper'
require 'vcr_helper'
require 'minute_dock_proxy'

describe MinuteDockProxy do
  describe '#list_projects' do
    it 'returns projects for the current account' do
      VCR.use_cassette('minute-dock-list-projects') do
        response = MinuteDockProxy.list_projects
        expect(response.values).not_to be_empty
      end
    end

    it 'raise error with invalid credentials'
  end
end

require 'spec_helper'
require 'support/requests/avatarable_spec'

describe 'Admin School Campus Picture' do

  before { as :admin }

  let(:school) { create(:school) }

  before do
    visit gaku.admin_school_path(school)
    click show_link
    @file_name = 'campus_picture'
  end

  it_behaves_like 'new avatar'


end

require 'rails_helper'

RSpec.describe 'the list feature', type: :feature do
  it 'lists examples' do
    e1 = create(:example)
    visit '/'
    expect(page).to have_content(e1.description[0..20])
    e2 = create(:example)
    visit '/'
    expect(page).to have_content(e1.description[0..20])
    expect(page).to have_content(e2.description[0..20])
  end
end

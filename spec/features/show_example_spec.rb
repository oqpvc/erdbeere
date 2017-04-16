require "rails_helper"

RSpec.describe "the show view of examples", type: :feature do
  it 'shows the whole description' do
    e = create(:example)
    visit examples_show_path(id: e.id)
    expect(page).to have_content(e.description)
  end
end

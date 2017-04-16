require "rails_helper"

def t(*args)
    I18n.translate!(*args)
end

RSpec.describe "the search and find", type: :feature do
  it 'displays the search site' do
    visit main_search_path
    expect(page).to have_content(t('main.search.title'))
  end

  it 'has a section for each structure' do
    ss = (1..10).map { |i| create(:structure) }
    visit main_search_path
    ss.each do |s|
      expect(page).to have_content(s.name)
    end
  end

  it 'throws an error if the form is submitted without content' do
    create(:structure)
    visit main_search_path
    within('.search-form') do
      click_button t('main.search.search_button')
    end
    expect(page).to have_content(t('examples.find.flash.no_search_params'))
  end

  it "tells you if it doesn't find anything" do
    s = create(:structure)
    p = create(:property, structure: s)
    visit main_search_path
    select(p.name, from: t('main.search.violates'))
    click_button t('main.search.search_button')
    expect(page).to have_content(t('examples.find.flash.nothing_found'))
  end

  it "tells you about logical impossibilities" do
    s = create(:structure)
    p = create(:property, structure: s)
    visit main_search_path
    select(p.name, from: t('main.search.violates'))
    select(p.name, from: t('main.search.satisfies'))
    click_button t('main.search.search_button')
    expect(page).to have_content(t('examples.violates_logic.i_found_the_following_contradiction'))
  end

  it "finds something it's supposed to find" do
    s = create(:structure)
    p = create(:property, structure: s)
    e = create(:example, structure: s)
    ExampleTruth.create({example: e, property: p, satisfied: true})
    visit main_search_path
    select(p.name, from: t('main.search.satisfies'))
    click_button t('main.search.search_button')
    expect(page).to have_content(e.description)
  end
end

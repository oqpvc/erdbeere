require 'rails_helper'

RSpec.describe 'seed data', type: :feature do
  it 'works' do
    load Rails.root.join('db', 'seeds.rb')
  end
end

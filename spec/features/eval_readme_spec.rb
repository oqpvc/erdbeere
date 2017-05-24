require 'rails_helper'

RSpec.describe 'README code snippets', type: :feature do
  it 'works' do
    code = File.read(Rails.root.join('README.md')).scan(/```ruby(.*?)```/m).join("\n")
    eval code
  end
end

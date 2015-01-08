require 'rails_helper'

describe 'assets:precompile' do
  before do
    Ena::Application.load_tasks
    Rake::Task['assets:clean'].invoke
  end

  it { expect { Rake::Task['assets:precompile'].invoke }.not_to raise_exception }
end

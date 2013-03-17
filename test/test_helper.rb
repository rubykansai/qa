ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'test/unit/rails/test_help'
require 'test/unit/rr'
require 'test/unit/notify'
require 'database_cleaner'

Dir[Rails.root.join("test/factories/**/*.rb")].each {|f| require f }

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

  # Add more helper methods to be used by all tests here...
  DatabaseCleaner.strategy = :truncation

  setup :setup_db
  def setup_db
    DatabaseCleaner.start
  end

  teardown :teardown_db
  def teardown_db
    DatabaseCleaner.clean
  end
end

module ControllerMacros
  def login_as(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(user)
    sign_in @user
    @user
  end

  def load_question_types
    question_types = [
                      :select,
                      :text,
                      :ruby_select,
                      :how_many_years,
                      :how_many_times,
                      :general_select,
                      :fee_select,
                     ]
    question_types.each do |question_type|
      FactoryGirl.create(question_type)
    end
  end
end

ActionController::TestCase.__send__(:include, Devise::TestHelpers)
ActionController::TestCase.__send__(:include, ControllerMacros)

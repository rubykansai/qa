require "test_helper"

class UserTest < ActiveSupport::TestCase

  class Validation < self
    setup
    def setup_data
      @user = User.new(name: "name",
                       email: "name@example.com",
                       password: "password")
    end

    def test_basic_user_is_valid
      assert_true(@user.valid?)
    end

    class Email < self
      def test_format
        @user.email = "..@example.com"
        assert_false(@user.valid?)
      end

      def test_uniqueness
        @other = @user.dup
        @other.name = "other"
        @other.email = "name@example.com"
        @user.save!
        assert_false(@other.valid?)
      end
    end
  end
end

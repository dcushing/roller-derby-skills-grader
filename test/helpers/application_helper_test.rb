require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
    test "full title helper" do
        assert_equal full_title, "Roller Derby Skills Grader"
        assert_equal full_title("Help"), "Help | Roller Derby Skills Grader"
        assert_equal full_title("About"), "About | Roller Derby Skills Grader"
        assert_equal full_title("Contact"), "Contact | Roller Derby Skills Grader"
    end
end
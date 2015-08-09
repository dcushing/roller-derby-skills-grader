require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
    def setup
        @user = users(:dany)
    end
    
    test "full title helper" do
        assert_equal full_title, "Roller Derby Skills Grader"
        assert_equal full_title("Help"), "Help | Roller Derby Skills Grader"
        assert_equal full_title("About"), "About | Roller Derby Skills Grader"
        assert_equal full_title("Contact"), "Contact | Roller Derby Skills Grader"
    end
    
    test "title helper displays user name in title when user" do
        assert_equal full_title(@user.display_name), "#{@user.display_name} | Roller Derby Skills Grader"
    end
end
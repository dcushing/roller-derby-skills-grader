require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
    include ApplicationHelper
    
    def setup
        @user = users(:dany)
    end
    
    test "non-skill profile display" do
        log_in_as @user
        get user_path(@user)
        assert_template 'users/show'
        assert_select 'title', full_title(@user.name)
        assert_select 'h1', text: @user.name
        assert_select 'h1', text: @user.derby_name
    end
    
    test "profile display skills" do
        log_in_as @user
        get user_path(@user)
        assert_match @user.skills.count.to_s, response.body
        @user.skills.each do |skill|
            assert_match skill.name, response.body
            assert_match skill.level.to_s, response.body
            assert_match skill.comments, response.body
        end
    end
end

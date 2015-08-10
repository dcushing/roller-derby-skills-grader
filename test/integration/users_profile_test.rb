require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
    include ApplicationHelper
    
    def setup
        @user = users(:dany)
        @other_user = users(:ruthless)
    end
    
    test "non-skill profile display" do
        log_in_as @user
        get user_path(@user)
        assert_template 'users/show'
        assert_select 'title', full_title(@user.display_name)
        assert_select 'h1', text: @user.display_name
        assert_select 'h2', text: @user.alternate_name
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
    
    test "all user types are true in profile" do
        log_in_as @user
        get user_path(@user)
        assert_template 'users/show'
        assert_select 'h2', @user.blocker
        assert_select 'h2', @user.jammer
        assert_select 'h2', @user.freshmeat
        assert_select 'h2', @user.ref
        assert_select 'h2', @user.nso
    end
    
    test "all user types are false in profile" do
        log_in_as @other_user
        get user_path(@other_user)
        assert_template 'users/show'
        assert_select 'h2', @user.blocker
        assert_select 'h2', @user.jammer
        assert_select 'h2', @user.freshmeat
        assert_select 'h2', @user.ref
        assert_select 'h2', @user.nso
    end    
end

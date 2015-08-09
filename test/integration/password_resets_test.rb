require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
    def setup
        ActionMailer::Base.deliveries.clear
        @user = users(:dany)
    end
    
    test "invalid email on password reset" do
        get new_password_reset_path
        assert_template 'password_resets/new'
        post password_resets_path, password_reset: { email: "" }
        assert_not flash.empty?
        assert_template 'password_resets/new'
    end
    
    test "valid email on password reset" do
        get new_password_reset_path
        assert_template 'password_resets/new'
        post password_resets_path, password_reset: { email: @user.email }
        assert_not_equal @user.reset_digest, @user.reload.reset_digest
        assert_equal 1, ActionMailer::Base.deliveries.size
        assert_not flash.empty?
        assert_redirected_to root_url
    end
    
    test "wrong email on password reset form" do
        get new_password_reset_path
        post password_resets_path, password_reset: { email: @user.email }
        user = assigns(:user)
        get edit_password_reset_path(user.reset_token, email: "") #error here - undefined method 'reset_token' for nil:NilClass
        #That error I was getting is fixed now by adding the second line of this test. Why do I need it?
        assert_redirected_to root_url
    end
    
    test "inactive user tries password reset" do
        get new_password_reset_path
        post password_resets_path, password_reset: { email: @user.email }
        user = assigns(:user)
        user.toggle!(:activated) #error here - undefined method 'toggle!' for nil:NilClass
        #Same as above--the error is now fixed by adding that post password_resets_path line. Why?
        get edit_password_reset_path(user.reset_token, email: user.email)
        assert_redirected_to root_url
        #user.toggle!(:activated)
    end
    
    test "password reset with right email but wrong token" do
        get new_password_reset_path
        post password_resets_path, password_reset: { email: @user.email }
        user = assigns(:user)
        get edit_password_reset_path('wrong token', email: user.email)
        assert_redirected_to root_url
    end
    
    test "password reset with right email and right token" do
        get new_password_reset_path
        post password_resets_path, password_reset: { email: @user.email }
        user = assigns(:user)
        get edit_password_reset_path(user.reset_token, email: user.email) #error here - undefined local variable or method 'user'
        assert_template 'password_resets/edit'
        assert_select "input[name=email][type=hidden][value=?]", user.email
    end
    
    test "invalid password and password confirmation" do
        get new_password_reset_path
        post password_resets_path, password_reset: { email: @user.email}
        user = assigns(:user)
        patch password_reset_path(user.reset_token), email: user.email, user: { password: "foobaz", password_confirmation: "barbaz" }
        assert_select 'div#error_explanation'
    end
    
    test "empty password" do
        get new_password_reset_path
        post password_resets_path, password_reset: { email: @user.email}
        user = assigns(:user)
        patch password_reset_path(user.reset_token), email: user.email, user: { password: "", password_confirmation: "" }
        assert_not flash.empty?
        assert_template 'password_resets/edit'
    end
    
    test "valid password and valid password confirmation" do
        get new_password_reset_path
        post password_resets_path, password_reset: { email: @user.email }
        user = assigns(:user)
        patch password_reset_path(user.reset_token), email: user.email, user: { password: "foobaz", password_confirmation: "foobaz" }
        assert is_logged_in?
        assert_not flash.empty?
        assert_redirected_to user
    end
    
    test "expired token" do
        get new_password_reset_path
        post password_resets_path, password_reset: { email: @user.email }
        @user = assigns(:user)
        @user.update_attribute(:reset_sent_at, 3.hours.ago)
        patch password_reset_path(@user.reset_token), email: @user.email, user: { password: "foobar", password_confirmation: "foobar" }
        assert_response :redirect
        follow_redirect!
        assert_match /expired/i, response.body
    end
end

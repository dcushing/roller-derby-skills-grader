require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
    
    def setup
        @user = users(:dany)
    end
    
    test "unsuccessful edit" do
        log_in_as(@user)
        get edit_user_path(@user)
        assert_template 'users/edit'
        patch user_path(@user), user: { name: "",
            derby_name: "",
            email: "foo@invalid",
            password: "foo",
            password_confirmation: "bar" }
        assert_template 'users/edit'
    end
    
    test "successful edit with friendly forwarding" do
        get edit_user_path(@user)
        log_in_as(@user)
        assert_redirected_to edit_user_path(@user)
        name = "Foo Bar"
        derby_name = "Bar Foo" 
        email = "foo@bar.com"
        patch user_path(@user), user: { name: name,
            derby_name: derby_name,
            email: email,
            password: "",
            password_confirmation: "" }
        assert_not flash.empty?
        assert_redirected_to @user
        @user.reload
        assert_equal name, @user.name
        assert_equal derby_name, @user.derby_name
        assert_equal email, @user.email
        assert_equal session[:forwarding_url], nil
    end
    
    test "update name" do
        log_in_as @user
        get edit_user_path(@user)
        name = "New Name"
        patch user_path(@user), user: { name: name }
        @user.reload
        assert_equal name, @user.name
    end
    
    test "update derby name" do
        log_in_as @user
        get edit_user_path(@user)
        derby_name = "New Derby Name"
        patch user_path(@user), user: { derby_name: derby_name }
        @user.reload
        assert_equal derby_name, @user.derby_name
    end
    
    test "update email" do
        log_in_as @user
        get edit_user_path(@user)
        email = "foo@bar.com"
        patch user_path(@user), user: { email: email }
        @user.reload
        assert_equal email, @user.email
    end
    
    test "update password" do
        log_in_as @user
        get edit_user_path(@user)
        password = "newpass"
        password_confirmation = "newpass"
        patch user_path(@user), user: { password: password, password_confirmation: password_confirmation }
        @user.reload
        assert is_logged_in?
    end
    
    test "update league" do
        log_in_as @user
        get edit_user_path(@user)
        league = "New League"
        patch user_path(@user), user: { league: league }
        @user.reload
        assert_equal league, @user.league
    end
    
    test "update skater types" do
        log_in_as @user
        get edit_user_path(@user)
        patch user_path(@user), user: { blocker: false, jammer: false, freshmeat: false, ref: false, nso: false }
        @user.reload
        assert_equal false, @user.blocker
        assert_equal false, @user.jammer
        assert_equal false, @user.freshmeat
        assert_equal false, @user.ref
        assert_equal false, @user.nso
    end
end

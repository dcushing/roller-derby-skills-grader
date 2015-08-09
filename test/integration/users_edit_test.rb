require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
    
    def setup
        @user = users(:dany)
    end
    
    test "unsuccessful edit" do
        log_in_as(@user)
        get edit_user_path(@user)
        assert_template 'users/edit'
        patch user_path(@user), user: { display_name: "",
            alternate_name: "",
            email: "foo@invalid",
            password: "foo",
            password_confirmation: "bar" }
        assert_template 'users/edit'
    end
    
    test "successful edit with friendly forwarding" do
        get edit_user_path(@user)
        log_in_as(@user)
        assert_redirected_to edit_user_path(@user)
        display_name = "Foo Bar"
        derby_name = "Bar Foo" 
        email = "foo@bar.com"
        patch user_path(@user), user: { display_name: display_name,
            alternate_name: alternate_name,
            email: email,
            password: "",
            password_confirmation: "" }
        assert_not flash.empty?
        assert_redirected_to @user
        @user.reload
        assert_equal display_name, @user.display_name
        assert_equal alternate_name, @user.alternate_name
        assert_equal email, @user.email
        assert_equal session[:forwarding_url], nil
    end
    
    test "update display_name" do
        log_in_as @user
        get edit_user_path(@user)
        display_name = "New Name"
        patch user_path(@user), user: { display_name: display_name }
        @user.reload
        assert_equal display_name, @user.display_name
    end
    
    test "update alternate_name" do
        log_in_as @user
        get edit_user_path(@user)
        alternate_name = "New Derby Name"
        patch user_path(@user), user: { alternate_name: alternate_name }
        @user.reload
        assert_equal alternate_name, @user.alternate_name
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

require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
    
    def setup
        ActionMailer::Base.deliveries.clear
    end
    
    test "invalid signup information" do
        get signup_path
        assert_no_difference 'User.count' do
            post users_path, user: { display_name: "", email: "user@invalid",
                password: "foo", password_confirmation: "bar" }
        end
        assert_template 'users/new'
    end
    
    test "valid signup information with alternate_name" do
        get signup_path
        assert_difference 'User.count', 1 do
            post_via_redirect users_path, user: { display_name: "Example User", alternate_name: "Example Derby Name", email: "user@rdsg.com", password: "password", password_confirmation: "password" }
        end
    end
    
    test "valid signup information without alternate_name" do
        get signup_path
        assert_difference 'User.count', 1 do
            post_via_redirect users_path, user: { display_name: "Example User", alternate_name: "", email: "user@rdsg.com", password: "password", password_confirmation: "password" }
        end
    end
    
    test "valid signup information with league" do
        get signup_path
        assert_difference 'User.count', 1 do
            post_via_redirect users_path, user: { display_name: "Example User", alternate_name: "", email: "user@rdsg.com", password: "password", password_confirmation: "password", league: "Example League" }
        end
    end
    
    test "valid signup information without league" do
        get signup_path
        assert_difference 'User.count', 1 do 
            post_via_redirect users_path, user: { display_name: "Example User", alternate_name: "", email: "user@rdsg.com", password: "password", password_confirmation: "password", league: "" }
        end
    end
    
    test "valid signup information with some skater types" do
        get signup_path
        assert_difference 'User.count', 1 do
            post_via_redirect users_path, user: { display_name: "Example User", alternate_name: "", email: "user@rdsg.com", password: "password", password_confirmation: "password", league: "", blocker: true, jammer: false, freshmeat: true, ref: false, nso: true }
        end
    end
    
    test "valid signup information with all skater types" do
        get signup_path
        assert_difference 'User.count', 1 do
            post_via_redirect users_path, user: { display_name: "Example User", alternate_name: "", email: "user@rdsg.com", password: "password", password_confirmation: "password", blocker: true, jammer: true, freshmeat: true, ref: true, nso: true }
        end
    end
    
    test "valid signup information with no skater types" do
        get signup_path
        assert_difference 'User.count', 1 do
            post_via_redirect users_path, user: { display_name: "Example User", alternate_name: "", email: "user@rdsg.com", password: "password", password_confirmation: "password", blocker: false, jammer: false, freshmeat: false, ref: false, nso: false }
        end
    end
    
    test "valid signup information with account activation" do
        get signup_path
        assert_difference 'User.count', 1 do
            post users_path, user: { display_name: "Example User", 
                email: "user@rdsg.com", 
                password: "password", 
                password_confirmation: "password" }
        end
        assert_equal 1, ActionMailer::Base.deliveries.size
        user = assigns(:user)
        assert_not user.activated?
        # Try to log in before activation
        log_in_as(user)
        assert_not is_logged_in?
        # Invalid activation token
        get edit_account_activation_path("invalid token")
        assert_not is_logged_in?
        #Valid token, wrong email
        get edit_account_activation_path(user.activation_token, email: "wrong")
        assert_not is_logged_in?
        #Valid activation token (finally)
        get edit_account_activation_path(user.activation_token, email: user.email)
        assert user.reload.activated?
        follow_redirect!
        assert_template 'users/show'
        assert is_logged_in?
    end
end

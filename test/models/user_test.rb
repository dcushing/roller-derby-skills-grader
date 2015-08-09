require 'test_helper'

class UserTest < ActiveSupport::TestCase
    def setup
        @user = users(:dany)
    end
    
    test "user should be valid" do
        assert @user.valid?
    end
    
    test "display_name should be present" do
        @user.display_name = ""
        assert_not @user.valid?
    end
    
    test "email should be present" do
        @user.email = ""
        assert_not @user.valid?
    end
    
    test "alternate_name does not have to be present" do
        @user.alternate_name = ""
        assert @user.valid?
    end
    
    test "display_name should not be too long" do
        @user.display_name = "a" * 51
        assert_not @user.valid?
    end
    
    test "alternate_name should not be too long" do
        @user.alternate_name = "a" * 31
        assert_not @user.valid?
    end
    
    test "email should not be too long" do
        @user.email = "a" * 255 + "@example.com"
        assert_not @user.valid?
    end
    
    test "email validation should accept valid addresses" do
        valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
            @user.email = valid_address
            assert @user.valid?, "#{valid_address.inspect} should be valid"
        end
    end
    
    test "email validation should not accept invalid addresses" do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example foo@bar_baz.com foo@bar+baz.com foo@bar..com]
        invalid_addresses.each do |invalid_address|
            @user.email = invalid_address
            assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
        end
    end
    
    test "email addresses should be unique" do
        duplicate_user = @user.dup
        duplicate_user.email = @user.email.upcase
        @user.save
        assert_not duplicate_user.valid?
    end
    
    test "password should be present" do
        @user.password = @user.password_confirmation = " " * 6
        assert_not @user.valid?
    end
    
    test "password should have a minimum length" do
        @user.password = @user.password_confirmation = "a" * 5
        assert_not @user.valid?
    end
    
    test "league should not be greater than fifty characters" do
        @user.league = "a" * 51
        assert_not @user.valid?
    end
    
    test "league should be optional" do
        @user.league = ""
        assert @user.valid?
    end
    
    test "authenticated? should return false for a user with nil digest" do
        assert_not @user.authenticated?(:remember, '')
    end
    
    test "associated skills should be destroyed" do
        @user.save
        @user.skills.create!(name: "backwards skating", level: 4, comments: "these are my comments")
        assert_difference 'Skill.count', -22 do
            @user.destroy
        end
    end
end

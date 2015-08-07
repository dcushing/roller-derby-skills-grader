require 'test_helper'

class SkillTest < ActiveSupport::TestCase
    def setup
        @user = users(:dany)
        @skill = @user.skills.build(name: "skating", level: 5, comments: "I am level 5/5 with my skating :)")
    end
    
    test "should be valid" do
        assert @skill.valid?
    end
    
    test "user id should be present" do
        @skill.user_id = nil
        assert_not @skill.valid?
    end
    
    test "name should be present" do
        @skill.name = ""
        assert_not @skill.valid?
    end
    
    test "name should be valid" do
        @skill.name = "a" * 51
        assert_not @skill.valid?
    end
    
    test "level should be present" do
        @skill.level = ""
        assert_not @skill.valid?
    end
    
    test "level should not be greater than five" do
        @skill.level = 6
        assert_not @skill.valid?
    end
    
    test "level should not be less than zero" do
        @skill.level = -1
        assert_not @skill.valid?
    end
    
    test "level should be between zero and five" do
        @skill.level = 3
        assert @skill.valid?
    end
    
end

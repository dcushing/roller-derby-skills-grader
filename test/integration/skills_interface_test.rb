require 'test_helper'

class SkillsInterfaceTest < ActionDispatch::IntegrationTest
    def setup
        @user = users(:dany)
    end
    
    test "invalid skill submission" do
        log_in_as(@user)
        get new_skill_path
        assert_no_difference 'Skill.count' do
            post skills_path, skill: { name: "", level: 6, comment: "" }
        end
        assert_select 'div#error_explanation'
    end
    
    test "valid skill submission" do
        log_in_as(@user)
        get new_skill_path
        name = "hockey stops"
        level = 4
        comments = "Almost there with my hockey stops"
        assert_difference 'Skill.count', 1 do
            post skills_path, skill: { name: name, level: level, comments: comments }
        end
        assert_redirected_to user_path(@user)
        follow_redirect!
        assert_match name, response.body
        assert_match level.to_s, response.body
    end
    
    test "delete a skill" do
        log_in_as(@user)
        get user_path(@user)
        assert_select 'a', text: 'delete'
        first_skill = @user.skills.first
        assert_difference 'Skill.count', -1 do
            delete skill_path(first_skill)
        end
    end
    
    test "sidebar skill count" do
        log_in_as(@user)
        get root_path
        assert_match "#{@user.skills.count} skills", response.body
    end
    
    test "sidebar skill count with no skills" do
        log_in_as(users(:unskilled))
        get root_path
        assert_match "0 skills", response.body
    end
    
end

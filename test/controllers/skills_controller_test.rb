require 'test_helper'

class SkillsControllerTest < ActionController::TestCase
    
    def setup
        @skill = skills(:skating)
    end
    
    test "should redirect create when not logged in" do
        assert_no_difference 'Skill.count' do
            post :create, micropost: { name: "plow stops", level: 2 }
        end
        assert_redirected_to login_url
    end
    
    test "should redirect destroy when not logged in" do
        assert_no_difference 'Skill.count' do
            delete :destroy, id: @skill
        end
        assert_redirected_to login_url
    end
    
    test "should redirect destroy for wrong skill" do
        log_in_as(users(:dany))
        skill = skills(:juking)
        assert_no_difference 'Skill.count' do
            delete :destroy, id: skill
        end
        assert_redirected_to root_url
    end
end

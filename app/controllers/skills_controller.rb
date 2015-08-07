class SkillsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :correct_user, only: :destroy
    
    def new
        @skill = Skill.new
    end
    
    def create
        @skill = current_user.skills.build(skill_params)
        if @skill.save
            flash[:success] = "Skill added to your list!"
            redirect_to user_path(current_user)
        else
            render 'new'
        end
    end
    
    def destroy
        @skill.destroy
        flash[:success] = "Skill deleted"
        redirect_to user_path
    end
    
    private
    
    def skill_params
        params.require(:skill).permit(:name, :level, :comments)
    end
    
    def correct_user
        @skill = current_user.skills.find_by(id: params[:id])
        redirect_to root_url if @skill.nil?
    end
end

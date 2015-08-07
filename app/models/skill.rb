class Skill < ActiveRecord::Base
    belongs_to :user
    validates :user_id, presence: true
    validates :name, presence: true, length: { maximum: 50 }
    validates :level, presence: true, inclusion: { within: 1..5 }
end

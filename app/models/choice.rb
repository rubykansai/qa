class Choice < ActiveRecord::Base
  belongs_to :question

  validates :question_id, presence: true
  validates(:position,
            presence: true,
            uniqueness: { scope: :question_id })
  validates :body, presence: true
end

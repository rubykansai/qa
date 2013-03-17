class QuestionType < ActiveRecord::Base
  validates :name, uniqueness: true
end

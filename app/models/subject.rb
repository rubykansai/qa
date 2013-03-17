class Subject < ActiveRecord::Base
  belongs_to :user
  has_many :questions, order: "position", dependent: :destroy
  has_many :answer_counters, dependent: :destroy

  validates :user_id, presence: true
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :max_respondents, numericality: { allow_nil: false, only_integer: true }

  def acceptable?
    acceptable_by_date? and acceptable_by_count?
  end

  def acceptable_by_date?
    (self.start_date..self.end_date).include?(Date.today)
  end

  def acceptable_by_count?
    self.max_respondents > self.answer_counters.count
  end
end

class Question < ActiveRecord::Base
  belongs_to :subject
  belongs_to :question_type
  has_many :choices, order: 'position', dependent: :destroy
  has_many :answers, dependent: :destroy

  validates(:position,
            numericality: { allow_nil: false, only_integer: true },
            uniqueness: { scope: :subject_id })
  validates :body, presence: true

  after_save :create_choices

  # TODO remove this method
  def self.N_(text)
    text
  end

  # TODO remove this method
  def _(text)
    text
  end

  RUBY_SELECT = {
    1 => N_('You cannot be interested in it.'),
    2 => N_('It was too difficult for you.'),
    3 => N_('You have understood it a little.'),
    4 => N_('It was interesting in you.'),
    5 => N_('It seems to be useful for you.'),
    6 => N_('Non-responding.'),
  }

  HOW_MANY_YEARS ={
    1 => N_('Less than 6 months.'),
    2 => N_('More than 6 months or Less than 1 year.'),
    3 => N_('More than 1 year or Less than 2 years.'),
    4 => N_('More than 2 years or Less than 3 years.'),
    5 => N_('More than 3 years or Less than 5 years.'),
    6 => N_('More than 5 years.'),
  }

  HOW_MANY_TIMES = {
    1 => N_('first time.'),
    2 => N_('2 times.'),
    3 => N_('3 times.'),
    4 => N_('4 times.'),
    5 => N_('5 times.'),
    6 => N_('More than 5 times or Less than 10 times.'),
    7 => N_('More than 10 times.'),
  }

  GENERAL_SELECT = {
    1 => N_('Lack something.'),
    2 => N_('Good enough.'),
    3 => N_('Very good.'),
    4 => N_('Non-responding.'),
  }

  FEE_SELECT = {
    1 => N_('Inexpensive.'),
    2 => N_('Reasonable.'),
    3 => N_('Expensive'),
    4 => N_('Non-responding.'),
  }

  # after_save
  def create_choices
    return if /\A(?:select|text)\z/ =~ question_type.name
    self.class.const_get(question_type.name.upcase.to_sym).each do |key, val|
      Choice.create!(:question_id => self.id,
                     :position => key,
                     :body => _(val))
    end
  rescue NameError => ex
    # must not happen!
    logger.error(ex.message)
    logger.error(ex.backtrace)
  end
end

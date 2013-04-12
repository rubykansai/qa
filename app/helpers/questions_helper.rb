module QuestionsHelper
  def select_question_type
    select('question', 'question_type_id',
           QuestionType.all(:select => 'id, name',
                            :order  => 'id').map{|v| [v.name, v.id]})
  end

  def show_choice_block?(question)
    ! (/text/ === question.question_type.name)
  end

  def explain_question_type
    QuestionType.all(:conditions => ["name not in (?, ?)", 'select', 'text'],
                     :order => "id").map do |qt|
      [qt.name,
       Question.const_get(qt.name.upcase).map{|key, label| [key, _(label)] }.sort_by(&:first)]
    end
  end
end

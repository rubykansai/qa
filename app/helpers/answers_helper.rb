module AnswersHelper
  def question_tag(question)
    case question.question_type.name
    when /select/, /how_many/
      list = Choice.all(:conditions =>["question_id = ?", question.id],
                        :order => ["position"]).map{|row|
        row_id = "question_#{row.question_id}_#{row.position}"
        [
         radio_button(:answer, "question_#{row.question_id}", row.position),
         label(:answer, row_id, _(row.body))
        ]
      }.map{|v|
        "<li>#{v.join('')}</li>"
      }
      "<ul class=\"choice-list\">#{list.join("")}</ul>"
    when /text/
      "<br />" + text_area(:answer, "question_#{question.id}", :size => '60x3')
    else
      raise 'must not happen!'
    end
  end

  def confirm_tag(item)
    question = item.question
    answer = item.body
    case question.question_type.name
    when /select/, /how_many/
      choice = Choice.all(:conditions => ["question_id = ? and position = ?",
                                          question.id, answer],
                          :order => 'position ASC')
      <<-TAG
#{question.body}
<ul>
  <li>#{_(choice[0].body)}</li>
</ul>
      TAG
    when /text/
      "#{question.body}<br /><div>#{answer}</div>"
    else
      raise 'must not happen!'
    end
  end

end

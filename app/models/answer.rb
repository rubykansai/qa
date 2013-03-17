class Answer < ActiveRecord::Base
  belongs_to :question

  def self.summary(question_id)
    # FIXME : bk here
    self.find_by_sql([<<-SQL, question_id])
SELECT
  a.body   AS body
, count(*) AS count
, c.body   AS label
FROM
  answers AS a
  JOIN
  choices AS c
    ON (a.question_id = c.question_id
        AND
        a.body = '' || c.position)
WHERE
  a.question_id = ?
GROUP BY
  a.body
, c.body
ORDER BY
  count ASC
        SQL
  end
end

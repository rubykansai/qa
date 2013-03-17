class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer :subject_id
      t.integer :question_type_id
      t.integer :position
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end

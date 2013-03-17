class CreateSubjects < ActiveRecord::Migration
  def self.up
    create_table :subjects do |t|
      t.integer :user_id
      t.string :name
      t.date :start_date
      t.date :end_date
      t.integer :max_respondents

      t.timestamps
    end
  end

  def self.down
    drop_table :subjects
  end
end

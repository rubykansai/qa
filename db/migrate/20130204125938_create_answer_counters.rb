class CreateAnswerCounters < ActiveRecord::Migration
  def self.up
    create_table :answer_counters do |t|
      t.integer :subject_id

      t.timestamps
    end
  end

  def self.down
    drop_table :answer_counters
  end
end

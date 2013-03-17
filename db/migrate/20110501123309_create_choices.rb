class CreateChoices < ActiveRecord::Migration
  def self.up
    create_table :choices do |t|
      t.integer :question_id
      t.integer :position
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :choices
  end
end

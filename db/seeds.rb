# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

question_types = [
                  "select",
                  "text",
                  "ruby_select",
                  "how_many_years",
                  "how_many_times",
                  "general_select",
                  "fee_select",
                 ].each do |type_name|
  QuestionType.create(:name => type_name)
end

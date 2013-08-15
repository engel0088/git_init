class CreateQuestionTypes < ActiveRecord::Migration
  def change
    create_table :question_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end

    ["textbox", "textarea", "date", "date and time", "time", "selection in scroll list", "selection with radio buttons", "Multi-choices"].each do |type|
       QuestionType.create(:name => type)
  	end

  end
end

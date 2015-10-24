class CreateSnippets < ActiveRecord::Migration
  def change
    create_table :snippets do |t|
      t.references :user, index: true, foreign_key: true
      t.text :body
      t.integer :word_count
      t.string :repo

      t.timestamps null: false
    end
  end
end

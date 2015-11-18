class ChangeSnippets < ActiveRecord::Migration
  def change
  	remove_column :snippets, :user_id
  	remove_column :snippets, :repo
  	add_column :snippets, :repo_id, :integer
  end
end
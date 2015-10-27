class AddCommitMessageToSnippets < ActiveRecord::Migration
  def change
    add_column :snippets, :commit_message, :text
  end
end

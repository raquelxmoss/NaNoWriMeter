class AddRepoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :repo, :string
  end
end

class AddWordCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :word_count, :integer
  end
end

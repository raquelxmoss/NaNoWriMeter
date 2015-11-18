class AddWordCountToRepo < ActiveRecord::Migration
  def change
  	add_column :repos, :word_count, :integer
  end
end

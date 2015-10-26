class AddLastSubmitToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_submit, :datetime
  end
end

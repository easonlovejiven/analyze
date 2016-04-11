class AddMarkeByHourAndDay < ActiveRecord::Migration
  def change
  	add_column :hour_messages, :hour_mark, :string
  	add_column :day_messages, :day_mark, :string
  	add_column :documents, :file_state, :integer, default: 0
  end
end

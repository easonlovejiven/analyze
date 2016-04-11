class CreateSumMessages < ActiveRecord::Migration
  def change
    create_table :sum_messages do |t|
      t.integer :post_id
      t.integer :impression_count
      t.integer :click_count
      t.integer :comment_count
      t.integer :praise_count
      t.integer :qq_share
      t.integer :wechat_share
      t.integer :weibo_share
      t.integer :genre

      t.timestamps null: false
    end
  end
end

ActiveRecord::Schema.define do
  
  create_table :users, :force => true do |t|
    t.string     :name
    t.string     :email
  end

  create_table :posts, :force => true do |t|
    t.string     :title
    t.text       :content
    t.references :user
  end
  
  create_table :comments, :force => true do |t|
    t.string     :body
    t.references :post
    t.references :user
  end
  
end
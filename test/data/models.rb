class User < ActiveRecord::Base

  validates_presence_of :email, :name

  has_many :posts

end

class Post < ActiveRecord::Base

  validates_presence_of :title, :content

  belongs_to :user
  has_many :comments

end

class Comment < ActiveRecord::Base

  validates_presence_of :body

  belongs_to :post
  belongs_to :user
  
end
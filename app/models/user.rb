# coding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :face,
  :styles => { :medium => "180x180#",
    :small => "80x80#",
    },
    :default_url => "/img/missing_face.png",
    :url => "/system/:class/:attachment/:id/:style/:id.:extension",
    :whiny => false

  has_many :posts

  def show_genre
    {1 => "主编", 2 => "值班编辑", 3 => "记者", 4 => "普通用户", 5 => "市场"}[self.genre]
  end

  def self.get_all_author
    # TODO: cache all_author
    Rails.cache.fetch("all_author/#{User.count}", expires_in: 10*60.seconds) do
      authors = User.where({:genre => [1, 2, 3]})
    end
  end

end

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic
  has_many :notifications, dependent: :destroy

  validates_presence_of :content
end

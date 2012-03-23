class EarlyUser < ActiveRecord::Base
  validates_presence_of :has_kids, :has_iPad, :email
end

class EarlyUser < ActiveRecord::Base
  validates_presence_of :has_kids, :owns_iPad, :email
end

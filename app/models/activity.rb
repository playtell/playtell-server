class Activity < ActiveRecord::Base
  has_one :book

  def as_json(options={})
    { :id => self.id,
      :title => self.title }
  end

end

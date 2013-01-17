class Activity < ActiveRecord::Base
  has_one :book, :dependent => :destroy

  def as_json(options={})
    { :id => self.id,
      :title => self.title }
  end

end

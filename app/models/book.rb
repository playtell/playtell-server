class Book < ActiveRecord::Base
  has_many :pages, :dependent => :destroy
  has_many :playdates
  belongs_to :activity, :dependent => :destroy
  
  def page_attributes=(page_attributes)
    page_attributes.each do |page_attribute|
      pages.build(page_attributes)
    end
  end
  
  def image_only?
    return true if self.image_only == 1
    return false
  end
  
end

class Activity < ActiveRecord::Base
  has_one :book, :dependent => :destroy

  def as_json(options={})
    is_book = !self.book.nil?
    a = { :id => self.id,
      :title => self.title,
      :is_book => is_book }
    a.merge(:book_id => self.book.id) unless !is_book
    return a
  end

end

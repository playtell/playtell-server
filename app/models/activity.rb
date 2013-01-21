class Activity < ActiveRecord::Base
  has_one :book, :dependent => :destroy
  has_one :game, :dependent => :destroy

  def as_json(options={})
    is_book = !self.book.nil?
    a = { :id => self.id,
      :title => self.title,
      :is_book => is_book }
    if is_book
      a.merge!(:book_id => self.book.id)
    else
      a.merge!(:game_id => self.game.client_id)
    end
    return a
  end

end

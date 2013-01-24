class Activity < ActiveRecord::Base
  has_one :book, :dependent => :destroy
  has_one :game, :dependent => :destroy
  
  after_create :set_toybox_order

  def book_attributes=(book_attributes)
    create_book(book_attributes.except(:num_pages))
    num_pages = book_attributes[:num_pages].to_i
    if book.pages.count != num_pages
      book.pages.delete_all
      num_pages.times do |page_num| 
        book.pages.create({:page_num => page_num+1, 
                           :page_text => ""})
      end
    end
  end
  
  def game_attributes=(game_attributes)
    create_game(game_attributes)
  end

  def set_toybox_order
    self.toybox_order = Activity.count+1
    save!
  end

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

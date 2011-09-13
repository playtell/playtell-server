class Cardgame < ActiveRecord::Base
  has_many :cards
  after_save :setup_game

  def setup_game
    c = Array.new(8)
    for i in 1..4
      for j in 1..2
        begin
          x = Random.rand(8)
        end while c[x] != nil
        c[x] = i 
      end
    end
    c.each_index { |x|
      self.cards.create ({:num => x, :value => c[x]})
    }
  end
  
  def all_facedown
    self.faceup1 = nil
    self.faceup2 = nil
  end
end

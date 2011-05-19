class Playdate
  attr_reader   :players
  attr_reader   :video_session_id
  attr_accessor :title
  attr_accessor :page_num
  
  def initialize(player, video_session_id)
    @players = []
    join(player)
    @video_session_id = video_session_id
  end
  
  def setActivity(title)
    @title = title
    @page_num = 1
  end
  
  def join(player_id)
    @players << player_id
  end
  
end
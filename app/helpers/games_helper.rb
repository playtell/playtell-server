module GamesHelper  
  def getPageImageFilePath(title, pageNum)
    File.join(title.parameterize, "page"+pageNum+".png")
  end
  
  def fellowPlayers()
    return User.all
  end
  
end


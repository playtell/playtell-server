module GamesHelper  
    def getImageFilePath(name)
    "https://ragatzi.s3.amazonaws.com/" + name;
  end
  
  def fellowPlayers()
    return User.all
  end
  
end


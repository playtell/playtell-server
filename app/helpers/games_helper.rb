module GamesHelper  
  def getPageImageFilePath(directory, pageNum)
    #for local storage
    #File.join(title.parameterize, "page"+pageNum+".png")
    
    #for S3 storage, e.g. https://ragatzi.s3.amazonaws.com/little-red-riding-hood-page1.png
    "https://ragatzi.s3.amazonaws.com/" + directory + "-" + "page" + pageNum + ".png"
  end
  
  def fellowPlayers()
    return User.all
  end
  
end


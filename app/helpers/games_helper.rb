module GamesHelper  
  def getPageImageFilePath(directory, pageNum) 
     #for S3 storage, e.g. https://ragatzi.s3.amazonaws.com/little-red-riding-hood-page1.png
     path = "https://ragatzi.s3.amazonaws.com/" + directory; 
     if pageNum > -1 
       path += "-" + "page" + pageNum.to_s
     end
     path += ".png"
  end

  def getImageFilePath(name)
    "https://ragatzi.s3.amazonaws.com/" + name;
  end
  
  def fellowPlayers()
    return User.all
  end
  
end


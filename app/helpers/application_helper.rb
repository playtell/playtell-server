module ApplicationHelper

#depricated
  def getPageImageFilePath(directory, pageNum) 
    #for S3 storage, e.g. https://ragatzi.s3.amazonaws.com/little-red-riding-hood-page1.png
    path = "https://ragatzi.s3.amazonaws.com/" + directory; 
    if (pageNum.to_i >= 0)
       path += "-" + "page" + pageNum
    end
    path += ".png"
  end

#depricated
  def getImageFilePath(name)
    "https://ragatzi.s3.amazonaws.com/" + name;
  end
  
  def getPage(directory, pageNum)
    "#{S3_BUCKET_NAME}/books/#{directory}/page#{pageNum}"
  end
  
  def fellowPlayers()
    return User.all
  end
end

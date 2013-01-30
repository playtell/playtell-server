module ApplicationHelper

#depricated
  def getPageImageFilePath(directory, pageNum) 
    if (pageNum.to_i > 0)
      "#{S3_BUCKET_NAME}/books/#{directory}/page#{pageNum}"
    elsif (pageNum.to_i == 0)
      "#{S3_BUCKET_NAME}/books/#{directory}/cover_front"
    end
  end

#depricated
  def getImageFilePath(name)
    "https://ragatzi.s3.amazonaws.com/" + name;
  end
  
  def fellowPlayers()
    return User.all
  end
end

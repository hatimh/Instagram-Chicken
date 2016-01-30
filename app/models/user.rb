class User < ActiveRecord::Base
  has_many :beats


  def get_user_competing_pictures(client)
    pictures = []
    user = client.user
    for media_item in client.user_recent_media
      media_item.tags.each do |tag|
        if tag =~ /^beatit_[a-z]+/ 
          pictures << Picture.new(media_item.images.low_resolution.url, 
                            media_item.images.thumbnail.url, 
                            media_item.images.standard_resolution.url,
                            media_item.likes)
        end
      end
    end
    pictures
  end 


  def get_user_winning_pictures(client)
    winning_pictures = []
    all_user_pictures = get_user_competing_pictures(client)
    all_user_pictures.each do |user_picture|
      picture_with_more_likes = Picture.get_picture_with_more_likes(client, user_picture.category)
      if picture_with_more_likes.user_name == user_picture.user_name
        winning_pictures << user_picture
      end 
    end 
    winning_pictures
  end 
end 
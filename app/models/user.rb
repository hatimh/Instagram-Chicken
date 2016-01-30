class User < ActiveRecord::Base
  has_many :beats


  def self.get_user_competing_pictures(client)
    pictures_competing = []
    #instagram_user = client.user
    for media_item in client.user_recent_media
      media_item.tags.each do |tag|
        if tag =~ /^beatit_[a-z]+/ 
          picture_with_tag = Picture.new(media_item.images.low_resolution.url, 
                            media_item.images.thumbnail.url, 
                            media_item.images.standard_resolution.url,
                            media_item.likes,
                            media_item.user.id)
          picture_with_tag.category = tag
          pictures_competing << picture
        end
      end
    end
    pictures_competing
  end 


  def self.get_user_winning_pictures(client)
    winning_pictures = []
    all_user_competing_pictures = get_user_competing_pictures(client)

     all_user_competing_pictures.each do |user_picture|
       picture_with_more_likes = Picture.get_picture_with_more_likes(client, user_picture.category)

       #Debug 
       pp picture_with_more_likes
    #   if picture_with_more_likes.user_id == user_picture.user_id
    #     winning_pictures << user_picture
    #   end 
      end 
    # winning_pictures
    nil
  end 
end 
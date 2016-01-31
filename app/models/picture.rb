class Picture

  BEAT_HASH_TAG = 'beatit _'

  attr_accessor :category
  attr_reader :low_resolution_url, :thumbnail_url, :standard_resolution_url, :likes

  def initialize(low_resolution_url, thumbnail_url, standard_resolution_url, likes, user_id)
    @low_resolution_url = low_resolution_url
    @thumbnail_url = thumbnail_url
    @standard_resolution_url = standard_resolution_url
    @likes = likes
    @user_id = user_id
  end

  def self.get_categories_hashtag(client)
    hashtags = []
    tags = client.tag_search(BEAT_HASH_TAG) 
    tags.each do |tag|
      if tag.name =~ /^beatit_[a-z]+/ 
        hashtags << tag.name
      end
    end 
    hashtags.uniq!
    hashtags
  end 

  def self.get_all_category_pictures_with_more_likes(client)
    hashtags = Picture.get_categories_hashtag(client)
    pictures = []
    hashtags.each do |hashtag|
      picture = get_picture_with_more_likes(client, hashtag)
      picture.category = hashtag
      pictures << picture
    end 
    pictures.sort!{|x,y| y.likes[:count] <=> x.likes[:count]}
    pictures
  end 
  def self.get_category_pictures(client, hashtag)
    instagram_pictures = client.tag_recent_media(hashtag).sort!{|x,y| y.likes[:count] <=> x.likes[:count]}
    puts "----"
    puts instagram_pictures.size
    puts "----"
    puts instagram_pictures
    instagram_pictures

  end
  def self.get_picture_with_more_likes(client, hashtag)
    instagran_pictures = client.tag_recent_media(hashtag).sort!{|x,y| y.likes[:count] <=> x.likes[:count]}
    if instagran_pictures
      picture = Picture.new(instagran_pictures[0].images.low_resolution.url, 
                            instagran_pictures[0].images.thumbnail.url, 
                            instagran_pictures[0].images.standard_resolution.url,
                            instagran_pictures[0].likes,
                            instagran_pictures[0].user.id)
      picture.category = hashtag
    end
    picture
  end

  # def self.user_pictures
  # end 
end
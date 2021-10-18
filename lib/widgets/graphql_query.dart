class Queries {
  static final String login = """
    query Login(\$login_link: String!, \$login_type: String!) {
      Login(login_link: \$login_link, login_type: \$login_type,) 
      {
          customer_id
          nick_name
          profile_photo_link
          profile_text
          point
          language
        }
    }
""";

  static final String checkNickname = """
    query check_nickname(\$nick_name: String!, \$customer_id: Int!) {
      check_nickname(nick_name: \$nick_name, customer_id: \$customer_id,) 
      {
          result
          msg
        }
    }
""";

  static final String photoListMap = """
    query photo_list_map(\$latitude1: String!, \$latitude2: String!,\$longitude1: String!,\$longitude2: String!) {
      photo_list_map(latitude1: \$latitude1, latitude2: \$latitude2,longitude1: \$longitude1, longitude2:\$longitude2) 
      {
          contents_id
          category_id
          contents_title
          location_link
          image_link
          main_text
          tags
          customer_id
          star_rating1
          star_rating2
          star_rating3
          star_rating4
          latitude
          longitude
          regist_date
        }
    }
""";

  static final String photoDetail = """
    query photo_detail(\$contents_id: Int!) {
      photo_detail(contents_id: \$contents_id) 
      {
          contents_id
          category_id
          contents_title
          nick_name
          image_link
          main_text
          regist_date
          star_rating1
          star_rating2
          star_rating3
          star_rating4
          bookmarks_count
          likes_count
          coments_count
          profile_photo_link
        }
    }
""";
}

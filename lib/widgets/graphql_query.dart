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
    query photo_detail(\$contents_id: Int!, \$customer_id: Int!) {
      photo_detail(contents_id: \$contents_id, customer_id: \$customer_id) 
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
          likes
          bookmarks
        }
    }
""";

/////////////////////////////////////////////////////////////////profile screen
  static final String mypageCount = """
    query mypage_count(\$customer_id: Int!) {
      mypage_count(customer_id: \$customer_id) 
      {
          contents_count
          bookmarks_count
          coments_count
        }
    }
""";

  static final String mypageContentsList = """
    query mypage_contents_list(\$customer_id: Int!) {
      mypage_contents_list(customer_id: \$customer_id) 
      {
          contents_id
          category_id
          contents_title
          location_link
          image_link
          main_text
          customer_id
          star_rating1
          star_rating2
          star_rating3
          star_rating4
          latitude
          longitude
        }
    }
""";

  static final String mypageComentsList = """
    query mypage_coments_list(\$customer_id: Int!) {
      mypage_coments_list(customer_id: \$customer_id) 
      {
          contents_id
          coments_id
          coments_text
          main_text
        }
    }
""";

  static final String mypageBookmarksList = """
    query mypage_bookmarks_list(\$customer_id: Int!) {
      mypage_bookmarks_list(customer_id: \$customer_id) 
      {
        bookmarks_id
        contents_id
        image_link
        }
    }
""";
}

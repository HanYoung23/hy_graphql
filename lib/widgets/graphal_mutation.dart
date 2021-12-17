class Mutations {
  static final String createCustomer = """
    mutation(\$login_link: String!, \$login_type: String!) {
      createCustomer(login_link : \$login_link, login_type : \$login_type) 
      {
          result
          msg
          msg2
        }
    }
""";

  static final String createNickname = """
    mutation(\$nick_name: String!, \$profile_photo_link: String!, \$customer_id: Int!) {
      createNickname(nick_name : \$nick_name, profile_photo_link : \$profile_photo_link, customer_id : \$customer_id) 
      {
          result
          msg
        }
    }
""";

  static final String checkNickname = """
    mutation(\$nick_name: String!,\$customer_id: Int!) {
      check_nickname(nick_name : \$nick_name, customer_id : \$customer_id) 
      {
          result
        }
    }
""";

  static final String createContents = """
    mutation(\$category_id: Int!, \$contents_title: String!,\$location_link: String!,\$image_link: String!,\$main_text: String!,\$tags: String!,\$customer_id: Int!,\$star_rating1: Int!,\$star_rating2: Int!,\$star_rating3: Int!,\$star_rating4: Int!,\$latitude: String!,\$longitude: String!) {
      createContents(category_id: \$category_id, contents_title: \$contents_title,location_link: \$location_link ,image_link: \$image_link ,main_text: \$main_text ,tags: \$tags ,customer_id: \$customer_id ,star_rating1: \$star_rating1 ,star_rating2: \$star_rating2 ,star_rating3: \$star_rating3 ,star_rating4: \$star_rating4 ,latitude: \$latitude ,longitude: \$longitude) 
      {
          result
          msg
        }
    }
""";

  static final String addLikes = """
    mutation(\$contents_id: Int!,\$customer_id: Int!) {
      add_likes(contents_id : \$contents_id, customer_id : \$customer_id) 
      {
          result
          msg
        }
    }
""";

  static final String addBookmarks = """
    mutation(\$contents_id: Int!,\$customer_id: Int!) {
      add_bookmarks(contents_id : \$contents_id, customer_id : \$customer_id) 
      {
          result
          msg
        }
    }
""";

  static final String createComents = """
    mutation(\$contents_id: Int!,\$customer_id: Int!, \$coment_text: String!, \$coments_id_link: Int!) {
      createComents(contents_id : \$contents_id, customer_id : \$customer_id, coment_text : \$coment_text, coments_id_link : \$coments_id_link)
      {
          result
          msg
        }
    }
""";

  static final String changeComent = """
    mutation(\$type: String!, \$coments_id: Int!, \$coment_text: String!) {
      change_coment(type : \$type, coments_id: \$coments_id, coment_text: \$coment_text)
      {
          result
          msg
        }
    }
""";

  static final String secession = """
    mutation(\$customer_id: Int!) {
      secession(customer_id : \$customer_id)
      {
          result
          msg
        }
    }
""";

  static final String changeProfile = """
    mutation(\$customer_id: Int!, \$profile_photo_link: String!, \$nick_name: String!, \$profile_text: String!) {
      change_profile(customer_id : \$customer_id, profile_photo_link : \$profile_photo_link, nick_name : \$nick_name, profile_text : \$profile_text)
      {
          result
          msg
        }
    }
""";

  static final String changeContents = """
    mutation(\$type: String!, \$contents_id: Int!, \$category_id: Int!, \$contents_title: String!, \$location_link : String!, \$image_link : String!, \$main_text : String!, \$tags : String!, \$star_rating1 : Int!, \$star_rating2 : Int!, \$star_rating3 : Int!, \$star_rating4 : Int!, \$latitude : String!, \$longitude : String! ) {
      change_contents(type : \$type, contents_id: \$contents_id, category_id: \$category_id, contents_title : \$contents_title, location_link:\$location_link, image_link:\$image_link, main_text:\$main_text, tags:\$tags, star_rating1:\$star_rating1,star_rating2:\$star_rating2,star_rating3:\$star_rating3,star_rating4:\$star_rating4, latitude:\$latitude, longitude:\$longitude)
      {
          result
          msg
        }
    }
""";

  static final String changeCheck = """
    mutation(\$type: String!, \$check_id: Int!) {
      change_check(type : \$type, check_id: \$check_id)
      {
          result
          msg
        }
    }
""";

  static final String deleteContents = """
    mutation(\$type: String!, \$contents_id: Int!) {
      change_contents(type : \$type, contents_id: \$contents_id)
      {
          result
          msg
        }
    }
""";

  static final String photoListMap = """
    mutation(\$latitude1: String!, \$latitude2: String!,\$longitude1: String!,\$longitude2: String!, \$category_id : Int!, \$date1 : Date!, \$date2 : Date!,) {
      photo_list_map(latitude1: \$latitude1, latitude2: \$latitude2,longitude1: \$longitude1, longitude2:\$longitude2, category_id:\$category_id, date1:\$date1, date2:\$date2, 
      )
      {
        results
        }
    }
""";

  static final String report = """
    mutation(\$customer_id: Int!, \$contents_id: Int!) {
      report(customer_id : \$customer_id, contents_id: \$contents_id)
      {
          result
          msg
        }
    }
""";

  static final String newPromotions = """
    mutation(
      \$title: String!, 
      \$image_link: String!,
      \$main_text: String!,
      \$location_link: String!,
      \$phone: String!,
      \$customer_id: Int!,
      \$ranges: Int!,
      \$promotions_count_total: Int!,
      \$business_name: String!,
      \$point_total: Int!,
      \$latitude: String!
      \$longitude: String!) {
      new_promotions(
        title: \$title, 
        image_link: \$image_link,
        main_text: \$main_text,
        location_link: \$location_link,
        phone: \$phone,
        customer_id: \$customer_id,
        ranges: \$ranges,
        promotions_count_total: \$promotions_count_total,
        business_name: \$business_name,
        point_total: \$point_total,
        latitude: \$latitude
        longitude: \$longitude) 
      {
          result
          msg
        }
    }
""";

  static final String changePromotions = """
    mutation(
      \$promotions_id: Int!, 
      \$title: String!, 
      \$image_link: String!,
      \$main_text: String!,
      \$location_link: String!,
      \$phone: String!,
      \$latitude: String!
      \$longitude: String!) {
      change_promotions(
        promotions_id: \$promotions_id, 
        title: \$title, 
        image_link: \$image_link,
        main_text: \$main_text,
        location_link: \$location_link,
        phone: \$phone,
        latitude: \$latitude
        longitude: \$longitude) 
      {
          result
          msg
        }
    }
""";

  static final String pausePromotions = """
    mutation(
      \$promotions_id: Int!) {
      pause_promotions(
        promotions_id: \$promotions_id) 
      {
          result
          msg
        }
    }
""";

  static final String delPromotions = """
    mutation(
      \$promotions_id: Int!,
      \$customer_id: Int!,
      ) {
      del_promotions(
        promotions_id: \$promotions_id,
        customer_id: \$customer_id
        ) 
      {
          result
          msg
        }
    }
""";
}

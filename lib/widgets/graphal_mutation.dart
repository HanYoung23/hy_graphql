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

  static final String secession = """
    mutation(\$customer_id: Int!) {
      secession(customer_id : \$customer_id)
      {
          result
          msg
        }
    }
""";
}

class Queries {
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
        }
    }
""";
}

class Mutations {
  static final String createContents = """
    mutation createContents(\$category_id: String!, \$contents_title: String!,\$location_link: String!,\$image_link: String!,\$main_text: String!,\$tags: String!,\$customer_id: String!,\$star_rating1: String!,\$star_rating2: String!,\$star_rating3: String!,\$star_rating4: String!,\$latitude: String!,\$longitude: String!) {
      createContents(category_id: \$category_id, contents_title: \$contents_title,location_link: \$location_link ,image_link: \$image_link ,main_text: \$main_text ,tags: \$tags ,customer_id: \$customer_id ,star_rating1: \$star_rating1 ,star_rating2: \$star_rating2 ,star_rating3: \$star_rating3 ,star_rating4: \$star_rating4 ,latitude: \$latitude ,longitude: \$longitude) 
      {
          result
          msg
        }
    }
""";
}

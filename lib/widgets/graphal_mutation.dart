class Mutations {
  static final String createContents = """
    mutation(\$category_id: Int!, \$contents_title: String!,\$location_link: String!,\$image_link: String!,\$main_text: String!,\$tags: String!,\$customer_id: Int!,\$star_rating1: Int!,\$star_rating2: Int!,\$star_rating3: Int!,\$star_rating4: Int!,\$latitude: String!,\$longitude: String!) {
      createContents(category_id: \$category_id, contents_title: \$contents_title,location_link: \$location_link ,image_link: \$image_link ,main_text: \$main_text ,tags: \$tags ,customer_id: \$customer_id ,star_rating1: \$star_rating1 ,star_rating2: \$star_rating2 ,star_rating3: \$star_rating3 ,star_rating4: \$star_rating4 ,latitude: \$latitude ,longitude: \$longitude) 
      {
          result
          msg
        }
    }
""";
}

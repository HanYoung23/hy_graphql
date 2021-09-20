class Queries {
  static final String mapPhotos = """
    query mapPhotos(\$latitude1: String!, \$latitude2: String!,\$longitude1: String!,\$longitude2: String!) {
      mapPhotos(latitude1: \$latitude1, latitude2: \$latitude2,longitude1: \$longitude1, longitude2:\$longitude2) {
        results {
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
    }
""";
}

// latitude1:지도남쪽끝위도, latitude2:지도북쪽끝위도, longitude1:지도서쪽끝경도, longitude2:지도동쪽끝경도	

// contents_id:사진아이디,
// category_id:카테고리번호,
// contents_title:장소이름,
// location_link:주소,
// image_link:사진주소,
// main_text:설명,
// tags:태그,
// customer_id:사용자아이디,
// star_rating1:점수1,
// star_rating2:점수2,
// star_rating3:점수3,
// star_rating4점수4,
// latitude:위도,
// longitude:경도
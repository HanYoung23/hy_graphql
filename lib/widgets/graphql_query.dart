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
    query photo_list_map(\$latitude1: String!, \$latitude2: String!,\$longitude1: String!,\$longitude2: String!, \$category_id : Int!, \$date1 : Date!, \$date2 : Date!, \$page: Int!) {
      photo_list_map(latitude1: \$latitude1, latitude2: \$latitude2,longitude1: \$longitude1, longitude2:\$longitude2, category_id:\$category_id, date1:\$date1, date2:\$date2, page:\$page)
      {
          count
          results
        }
    }
""";

  static final String photoListMapCount = """
    query photo_list_map(\$latitude1: String!, \$latitude2: String!,\$longitude1: String!,\$longitude2: String!, \$category_id : Int!, \$date1 : Date!, \$date2 : Date!, \$page: Int!) {
      photo_list_map(latitude1: \$latitude1, latitude2: \$latitude2,longitude1: \$longitude1, longitude2:\$longitude2, category_id:\$category_id, date1:\$date1, date2:\$date2, page:\$page)
      {
          count
        }
    }
""";

//   static final String photoListMapWhole = """
//     query photo_list_map(\$latitude1: String!, \$latitude2: String!,\$longitude1: String!,\$longitude2: String!, \$category_id : Int!, \$date1 : Date!, \$date2 : Date!) {
//       photo_list_map(latitude1: \$latitude1, latitude2: \$latitude2,longitude1: \$longitude1, longitude2:\$longitude2, category_id:\$category_id, date1:\$date1, date2:\$date2)
//       {
//           contents_id
//           category_id
//           contents_title
//           location_link
//           image_link
//           main_text
//           tags
//           customer_id
//           star_rating1
//           star_rating2
//           star_rating3
//           star_rating4
//           latitude
//           longitude
//           regist_date
//         }
//     }
// """;

  static final String promotionsList = """
    query promotions_list(\$latitude1: String!, \$latitude2: String!,\$longitude1: String!,\$longitude2: String!) {
      promotions_list(latitude1: \$latitude1, latitude2: \$latitude2,longitude1: \$longitude1, longitude2:\$longitude2)
      {
          promotions_id
          image_link
          main_text
          location_link 
        }
    }
""";

  static final String photoDetail = """
    query photo_detail(\$contents_id: Int!, \$customer_id: Int!) {
      photo_detail(contents_id: \$contents_id, customer_id: \$customer_id) 
      {
          customer_id
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
          tags
        }
    }
""";

  static final String photoDetailCounts = """
    query photo_detail(\$contents_id: Int!, \$customer_id: Int!) {
      photo_detail(contents_id: \$contents_id, customer_id: \$customer_id) 
      {
          bookmarks_count
          likes_count
          coments_count
          likes
          bookmarks
        }
    }
""";

  static final String photoDetailLikeCounts = """
    query photo_detail(\$contents_id: Int!, \$customer_id: Int!) {
      photo_detail(contents_id: \$contents_id, customer_id: \$customer_id) 
      {
          likes_count
          likes
        }
    }
""";

  static final String photoDetailBookmarkCounts = """
    query photo_detail(\$contents_id: Int!, \$customer_id: Int!) {
      photo_detail(contents_id: \$contents_id, customer_id: \$customer_id) 
      {
          bookmarks_count
          bookmarks
        }
    }
""";

  static final String photoDetailCommentCounts = """
    query photo_detail(\$contents_id: Int!, \$customer_id: Int!) {
      photo_detail(contents_id: \$contents_id, customer_id: \$customer_id) 
      {
          coments_count
        }
    }
""";

  static final String comentsList = """
    query coments_list(\$contents_id: Int!, \$sequence: Int!, \$page: Int!) {
      coments_list(contents_id: \$contents_id, sequence: \$sequence,page: \$page) 
      {
          count
          results
        }
    }
""";

  static final String comentsCount = """
    query coments_list(\$contents_id: Int!, \$sequence: Int!, \$page: Int!) {
      coments_list(contents_id: \$contents_id, sequence: \$sequence,page: \$page) 
      {
          count
        }
    }
""";

  static final String comentsNum = """
    query photo_detail(\$contents_id: Int!, \$customer_id: Int!) {
      photo_detail(contents_id: \$contents_id, customer_id: \$customer_id) 
      {
          coments_count
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

//   static final String mypagePageCount = """
//     query mypage_page_count(\$customer_id: Int!, \$page: Int!) {
//       mypage_contents_list(customer_id: \$customer_id, page:\$page)
//       {
//           count
//         }
//         mypage_coments_list(customer_id: \$customer_id, page: \$page)
//       {
//           count
//         }
//         mypage_bookmarks_list(customer_id: \$customer_id, page: \$page)
//       {
//         count
//         }
//     }
// """;

  static final String mypageContentsList = """
    query mypage_contents_list(\$customer_id: Int!, \$page: Int!) {
      mypage_contents_list(customer_id: \$customer_id, page:\$page) 
      {
          count
          results
        }
    }
""";

  static final String mypageContentsCount = """
    query mypage_contents_list(\$customer_id: Int!, \$page: Int!) {
      mypage_contents_list(customer_id: \$customer_id, page:\$page) 
      {
          count
        }
    }
""";

  static final String mypageComentsList = """
    query mypage_coments_list(\$customer_id: Int!,\$page: Int!) {
      mypage_coments_list(customer_id: \$customer_id, page: \$page) 
      {
          count
          results
        }
    }
""";

  static final String mypageComentsCount = """
    query mypage_coments_list(\$customer_id: Int!,\$page: Int!) {
      mypage_coments_list(customer_id: \$customer_id, page: \$page) 
      {
          count
        }
    }
""";

  static final String mypageBookmarksList = """
    query mypage_bookmarks_list(\$customer_id: Int!,\$page: Int!) {
      mypage_bookmarks_list(customer_id: \$customer_id, page: \$page) 
      {
        count
          results
        }
    }
""";
  static final String mypageBookmarksCount = """
    query mypage_bookmarks_list(\$customer_id: Int!,\$page: Int!) {
      mypage_bookmarks_list(customer_id: \$customer_id, page: \$page) 
      {
        count
        }
    }
""";

  static final String mypage = """
    query mypage(\$customer_id: Int!) {
      mypage(customer_id: \$customer_id) 
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

/////////////////////////////////////////////////////////////////settings screen

  static final String checkList = """
    query check_list(\$customer_id: Int!) {
      check_list(customer_id: \$customer_id) 
      {
          check_id
          id
          regist_date
          check
          type
        }
    }
""";

  static final String noticeList = """
    query notice_list(\$customer_id: Int!) {
      notice_list(customer_id: \$customer_id) 
      {
          check_id
          notice_id
          notice_title
          image_link
          notice_text
          regist_date
        }
    }
""";

  static final String notice = """
    query notice(\$notice_id: Int!) {
      notice(notice_id: \$notice_id) 
      {
          notice_id
          notice_title
          image_link
          notice_text
          regist_date
          edit_date
        }
    }
""";

  static final String versionCheck = """
    query version_check() {
      version_check() 
      {
          ios
          android
        }
    }
""";
}

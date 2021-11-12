import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_View/MainPages/map/edit_post_creation_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/material_popup.dart';
import 'package:letsgotrip/homepage.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';

class PostCupertinoBottomSheet extends StatelessWidget {
  final int contentsId;
  final Function refetchCallback;
  const PostCupertinoBottomSheet({
    Key key,
    @required this.contentsId,
    @required this.refetchCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
          document: gql(Mutations.deleteContents),
          update: (GraphQLDataProxy proxy, QueryResult result) {},
          onCompleted: (dynamic resultData) async {
            // print("🚨 change contents result : $resultData");
            if (resultData["change_contents"]["result"]) {
              Get.off(() => HomePage(), arguments: 2);
            }
          },
        ),
        builder: (RunMutation runMutation, QueryResult queryResult) {
          return CupertinoActionSheet(
              actions: <CupertinoActionSheetAction>[
                CupertinoActionSheetAction(
                  child: Text(
                    "게시물 수정",
                    style: TextStyle(
                      fontFamily: "NotoSansCJKkrRegular",
                      fontSize: ScreenUtil().setSp(20),
                      letterSpacing: ScreenUtil().setSp(letter_spacing_bottom),
                      color: app_blue_cupertino,
                    ),
                  ),
                  onPressed: () {
                    seeValue("customerId").then((customerId) {
                      Get.off(
                        () => queryAndEditPostCreationScreen(customerId),
                      );
                    });
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(
                    "삭제하기",
                    style: TextStyle(
                      fontFamily: "NotoSansCJKkrRegular",
                      fontSize: ScreenUtil().setSp(20),
                      letterSpacing: ScreenUtil().setSp(letter_spacing_bottom),
                      color: app_red_cupertino,
                    ),
                  ),
                  onPressed: () {
                    deletePostPopup(
                        context,
                        () => runMutation({
                              "type": "del",
                              "contents_id": contentsId,
                            }));
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text(
                  "취소",
                  style: TextStyle(
                    fontFamily: "NotoSansCJKkrRegular",
                    fontSize: ScreenUtil().setSp(20),
                    letterSpacing: ScreenUtil().setSp(letter_spacing_bottom),
                    color: app_blue_cupertino_cancel,
                  ),
                ),
                onPressed: () {
                  Get.back();
                },
              ));
        });
  }

  Query queryAndEditPostCreationScreen(customerId) {
    return Query(
        options: QueryOptions(
          document: gql(Queries.photoDetail),
          variables: {
            "contents_id": contentsId,
            "customer_id": int.parse(customerId),
          },
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading && result.data != null) {
            print("🚨 photodetail result : ${result.data["photo_detail"]}");
            Map resultData = result.data["photo_detail"];
            int categoryId = resultData["category_id"];
            String selectedCategory;
            String images = resultData["image_link"];
            List imageLink = images.split(",");
            String mainText = resultData["main_text"];
            String tags = resultData["tags"];
            String contentsTitle = resultData["contents_title"];
            List starRatingList = [
              resultData["star_rating1"],
              resultData["star_rating2"],
              resultData["star_rating3"],
              resultData["star_rating4"],
            ];

            switch (categoryId) {
              case 1:
                selectedCategory = "바닷가";
                break;
              case 2:
                selectedCategory = "액티비티";
                break;
              case 3:
                selectedCategory = "맛집";
                break;
              case 4:
                selectedCategory = "숙소";
                break;
              default:
            }

            Map mapData = {
              "contentsId": contentsId,
              "categoryId": categoryId,
              "selectedCategory": selectedCategory,
              "imageLink": imageLink,
              "mainText": mainText,
              "tags": tags,
              "contentsTitle": contentsTitle,
              "starRatingList": starRatingList,
            };
            return EditPostCreationScreen(
              mapData: mapData,
            );
          } else {
            return Container();
          }
        });
  }
}

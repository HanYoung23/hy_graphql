import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';

class CommentCupertinoBottomSheet extends StatelessWidget {
  final int comentsId;
  final String comentText;
  final Function refetchCallback;
  final Function editCommentCallback;
  const CommentCupertinoBottomSheet({
    Key key,
    @required this.comentsId,
    @required this.comentText,
    @required this.refetchCallback,
    @required this.editCommentCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
          document: gql(Mutations.changeComent),
          update: (GraphQLDataProxy proxy, QueryResult result) {},
          onCompleted: (dynamic resultData) async {
            print("🚨 change comment result : $resultData");
            if (resultData["change_coment"]["result"]) {
              refetchCallback();
              Get.back();
            }
          },
        ),
        builder: (RunMutation runMutation, QueryResult queryResult) {
          return CupertinoActionSheet(
              actions: <CupertinoActionSheetAction>[
                CupertinoActionSheetAction(
                  child: Text(
                    "댓글 수정하기",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(20),
                      letterSpacing: -0.48,
                      color: app_blue_cupertino,
                    ),
                  ),
                  onPressed: () {
                    editCommentCallback(comentsId, comentText);
                    Get.back();
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(
                    "삭제하기",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(20),
                      letterSpacing: -0.48,
                      color: app_red_cupertino,
                    ),
                  ),
                  onPressed: () {
                    editCommentCallback(null, null);
                    runMutation({
                      "type": "del",
                      "coments_id": comentsId,
                      "coment_text": comentText,
                    });
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text(
                  "취소",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(20),
                    letterSpacing: -0.48,
                    color: app_blue_cupertino_cancel,
                  ),
                ),
                onPressed: () {
                  editCommentCallback(null, null);
                  Get.back();
                },
              ));
        });
  }
}

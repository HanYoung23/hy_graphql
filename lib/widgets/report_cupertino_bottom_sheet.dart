import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/homepage.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';

class ReportCupertinoBottomSheet extends StatelessWidget {
  final int contentsId;
  const ReportCupertinoBottomSheet({
    Key key,
    @required this.contentsId,
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
              Get.offAll(() => HomePage(), arguments: 2);
            }
          },
        ),
        builder: (RunMutation runMutation, QueryResult queryResult) {
          return CupertinoActionSheet(
              actions: <CupertinoActionSheetAction>[
                CupertinoActionSheetAction(
                  child: Text(
                    "신고하기",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(20),
                      letterSpacing: -0.48,
                      color: app_red_cupertino,
                    ),
                  ),
                  onPressed: () {
                    // runMutation({
                    //   "type": "del",
                    //   "contents_id": contentsId,
                    // });
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
                  Get.back();
                },
              ));
        });
  }
}

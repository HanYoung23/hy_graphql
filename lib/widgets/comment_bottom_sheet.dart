import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';

class CommentBottomSheet extends StatefulWidget {
  final int contentsId;
  const CommentBottomSheet({Key key, @required this.contentsId})
      : super(key: key);

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final commentController = TextEditingController();
  bool isLeft = true;
  bool isValid = false;
  int sequence = 1;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(Queries.comentsList),
          variables: {
            "contents_id": widget.contentsId,
            "sequence": sequence,
          },
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading) {
            print("🚨 comments : $result");

            List comentsList = result.data["coments_list"];

            return SingleChildScrollView(
              child: Container(
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().screenHeight * 0.8,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    SizedBox(height: ScreenUtil().setSp(30)),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setSp(20)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text("댓글 333",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(16),
                                      letterSpacing: -0.4,
                                      fontWeight: FontWeight.bold)),
                              Spacer(),
                              Text("닫기",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(16),
                                      letterSpacing: -0.4,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: ScreenUtil().setSp(10)),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isLeft = true;
                                  });
                                },
                                child: Text("등록순",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(14),
                                        letterSpacing: -0.35,
                                        color: isLeft
                                            ? Colors.black
                                            : app_font_grey,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(width: ScreenUtil().setSp(10)),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isLeft = false;
                                  });
                                },
                                child: Text("최신순",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(14),
                                        letterSpacing: -0.35,
                                        color: !isLeft
                                            ? Colors.black
                                            : app_font_grey,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Query(options: options, builder: builder),
                    // commentForm(null, "nickname", "date", "content"),
                    comentsList.length == 0
                        ? Expanded(
                            child: Container(
                              child: Center(
                                child: Text(
                                  "텅 빈 공간이에요\n의견을 나눠보세요 :)",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(16),
                                      letterSpacing: -0.4,
                                      color: app_font_grey),
                                ),
                              ),
                            ),
                          )
                        : commentForm(null, "nickname", "date", "content"),
                    comentsList.length != 0 ? Spacer() : Container(),
                    textInput(context)
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Container textInput(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(ScreenUtil().setSp(20)),
        child: Mutation(
            options: MutationOptions(
                document: gql(Mutations.createComents),
                update: (GraphQLDataProxy proxy, QueryResult result) {},
                onCompleted: (dynamic resultData) {
                  print("🚨 resultData : $resultData");
                }),
            builder: (RunMutation runMutation, QueryResult queryResult) {
              return TextFormField(
                controller: commentController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  if (commentController.text.length > 0) {
                    setState(() {
                      isValid = true;
                    });
                  } else {
                    setState(() {
                      isValid = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 0, horizontal: ScreenUtil().setSp(10)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: app_grey_dark),
                  ),
                  hintText: '의견을 남겨보세요',
                  hintStyle: TextStyle(
                      color: Color.fromRGBO(188, 192, 193, 1),
                      fontSize: ScreenUtil().setSp(14)),
                  suffixIcon: InkWell(
                    onTap: () async {
                      String customerId = await storage.read(key: "customerId");
                      // if (isValid) {
                      //   runMutation({
                      //     "contents_id": widget.contentsId,
                      //     "customer_id": int.parse(customerId),
                      //     "coment_text": commentController.text,
                      //     // "coments_id_link": 1,
                      //   });
                      // }
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      width: ScreenUtil().setWidth(56),
                      height: ScreenUtil().setHeight(34),
                      margin: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(5),
                          horizontal: ScreenUtil().setWidth(8)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isValid
                            ? Color.fromRGBO(5, 138, 221, 1)
                            : Color.fromRGBO(5, 138, 221, 0.3),
                      ),
                      child: Center(
                          child: Text(
                        "입력",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.35,
                            color: Colors.white),
                      )),
                    ),
                  ),
                ),
              );
            }));
  }

  Column commentForm(
      String photo, String nickname, String date, String content) {
    return Column(
      children: [
        SizedBox(height: ScreenUtil().setSp(20)),
        Container(
          width: ScreenUtil().screenWidth,
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: ScreenUtil().setSp(35),
                height: ScreenUtil().setSp(35),
                decoration: photo == null
                    ? BoxDecoration(
                        color: app_grey,
                        borderRadius: BorderRadius.circular(50))
                    : BoxDecoration(
                        image: DecorationImage(image: NetworkImage(photo)),
                        borderRadius: BorderRadius.circular(50)),
              ),
              SizedBox(width: ScreenUtil().setSp(6)),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ScreenUtil().setSp(3)),
                      Row(
                        children: [
                          Text(
                            nickname,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(14),
                                letterSpacing: -0.35,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(width: ScreenUtil().setSp(10)),
                          Expanded(
                            child: Text(
                              date,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(14),
                                letterSpacing: -0.35,
                                color: app_font_grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenUtil().setSp(3)),
                      Text(
                        content,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            letterSpacing: -0.35),
                      ),
                      SizedBox(height: ScreenUtil().setSp(3)),
                      Text(
                        "답글 달기",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(12),
                            color: app_font_grey,
                            letterSpacing: -0.3),
                      ),
                    ],
                  ),
                ),
              ),
              Image.asset("assets/images/comment_toggle_button.png",
                  width: ScreenUtil().setSp(28), height: ScreenUtil().setSp(28))
            ],
          ),
        ),
        SizedBox(height: ScreenUtil().setSp(20)),
        Container(
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().setSp(1),
          color: app_grey,
        )
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/comment_cupertino_bottom_sheet.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';

class CommentBottomSheet extends StatefulWidget {
  final int contentsId;
  final Function callbackRefetch;
  const CommentBottomSheet(
      {Key key, @required this.contentsId, @required this.callbackRefetch})
      : super(key: key);

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final commentController = TextEditingController();
  FocusNode focusNode;
  bool isLeft = true;
  bool isValid = false;
  int replyCommentId = 0;
  String replyCommentNickname = "";

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(Queries.comentsList),
          variables: {
            "contents_id": widget.contentsId,
            "sequence": isLeft ? 1 : 2,
          },
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading) {
            // print("🚨 comments : ${result.data["coments_list"][0]}");

            List comentsList = result.data["coments_list"];

            return Container(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight * 0.9,
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
                            Text("댓글 ${comentsList.length}",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(16),
                                    letterSpacing: -0.4,
                                    fontWeight: FontWeight.bold)),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Text("닫기",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(16),
                                      letterSpacing: -0.4,
                                      fontWeight: FontWeight.bold)),
                            ),
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
                                refetch();
                              },
                              child: Text("등록순",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(14),
                                      letterSpacing: -0.35,
                                      color:
                                          isLeft ? Colors.black : app_font_grey,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(width: ScreenUtil().setSp(10)),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isLeft = false;
                                });
                                refetch();
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
                  SizedBox(height: ScreenUtil().setSp(4)),
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
                      : Container(
                          width: ScreenUtil().screenWidth,
                          height: ScreenUtil().screenHeight * 0.9 -
                              ScreenUtil().setSp(180) -
                              MediaQuery.of(context).viewInsets.bottom,
                          child: ListView(
                            children: comentsList.map((comment) {
                              String nickname = comment["nick_name"];
                              String profilePhotoLInk =
                                  comment["profile_photo_link"];
                              //
                              DateTime dateTime =
                                  DateTime.parse(comment["regist_date"]);
                              var formatter =
                                  new DateFormat('yyyy MMM dd, a h:m');
                              String date = formatter.format(dateTime);
                              //
                              String content = comment["coment_text"];
                              int comentsId = comment["coments_id"];
                              int comentsIdLink = comment["coments_id_link"];
                              int checkFlag = comment["check_flag"];

                              List replyList = [];
                              comentsList.map((e) {
                                if (e["coments_id_link"] == comentsId) {
                                  replyList.add(e);
                                }
                              }).toList();

                              return comentsIdLink == null
                                  ? Column(
                                      children: [
                                        commentForm(
                                            profilePhotoLInk,
                                            nickname,
                                            date,
                                            content,
                                            comentsId,
                                            comentsIdLink,
                                            refetch,
                                            checkFlag),
                                        Column(
                                          children: replyList.map((e) {
                                            String _nickname = e["nick_name"];
                                            String _profilePhotoLInk =
                                                e["profile_photo_link"];
                                            //
                                            DateTime _dateTime = DateTime.parse(
                                                e["regist_date"]);
                                            var formatter = new DateFormat(
                                                'yyyy MMM dd, a h:m');
                                            String _date =
                                                formatter.format(_dateTime);
                                            //
                                            String _content = e["coment_text"];
                                            int _comentsId = e["coments_id"];
                                            int _checkFlag = e["check_flag"];

                                            return commentReplyForm(
                                                _profilePhotoLInk,
                                                nickname,
                                                _nickname,
                                                _date,
                                                _content,
                                                comentsId,
                                                _comentsId,
                                                refetch,
                                                _checkFlag);
                                          }).toList(),
                                        )
                                      ],
                                    )
                                  : Container();
                            }).toList(),
                          ),
                        ),
                  comentsList.length != 0 ? Spacer() : Container(),
                  textInput(context, refetch),
                  SizedBox(height: ScreenUtil().setSp(20))
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Container textInput(BuildContext context, Function refetch) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
        child: Mutation(
            options: MutationOptions(
                document: gql(Mutations.createComents),
                update: (GraphQLDataProxy proxy, QueryResult result) {},
                onCompleted: (dynamic resultData) {
                  refetch();
                  widget.callbackRefetch();
                }),
            builder: (RunMutation runMutation, QueryResult queryResult) {
              return TextFormField(
                focusNode: focusNode,
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
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(14), letterSpacing: -0.35),
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
                      if (isValid) {
                        if (replyCommentId != 0) {
                          String inputValue = commentController.text;
                          int nicknameLength = replyCommentNickname.length + 1;
                          if (inputValue.substring(0, nicknameLength) ==
                              "@$replyCommentNickname") {
                            runMutation({
                              "contents_id": widget.contentsId,
                              "customer_id": int.parse(customerId),
                              "coment_text": commentController.text,
                              "coments_id_link": replyCommentId,
                            });
                          } else {
                            runMutation({
                              "contents_id": widget.contentsId,
                              "customer_id": int.parse(customerId),
                              "coment_text": commentController.text,
                              "coments_id_link": replyCommentId,
                            });
                          }
                        } else {
                          runMutation({
                            "contents_id": widget.contentsId,
                            "customer_id": int.parse(customerId),
                            "coment_text": commentController.text,
                            "coments_id_link": replyCommentId,
                          });
                        }

                        commentController.text = "";
                        setState(() {
                          replyCommentId = 0;
                          replyCommentNickname = "";
                          isValid = false;
                        });
                        FocusScope.of(context).unfocus();
                      }
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

  Column commentForm(String photo, String nickname, String date, String content,
      int comentsId, int comentsIdLink, Function refetch, int checkFlag) {
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
                        borderRadius: BorderRadius.circular(100))
                    : BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover, image: NetworkImage(photo)),
                        borderRadius: BorderRadius.circular(100)),
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
                      SizedBox(height: ScreenUtil().setSp(6)),
                      Text(
                        checkFlag != 2 ? content : "삭제된 댓글입니다.",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            color:
                                checkFlag != 2 ? Colors.black : app_font_grey,
                            letterSpacing: -0.35),
                      ),
                      SizedBox(height: ScreenUtil().setSp(8)),
                      InkWell(
                        onTap: () {
                          setState(() {
                            replyCommentId = comentsId;
                            replyCommentNickname = nickname;
                          });
                          commentController.text = "@$nickname ";
                          commentController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: commentController.text.length));
                          focusNode.requestFocus();
                        },
                        child: Text(
                          "답글 달기",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color: app_font_grey,
                              letterSpacing: -0.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) =>
                        CommentCupertinoBottomSheet(
                            comentsId: comentsId,
                            comentText: content,
                            refetchCallback: refetch),
                  );
                },
                child: Image.asset("assets/images/comment_toggle_button.png",
                    width: ScreenUtil().setSp(28),
                    height: ScreenUtil().setSp(28)),
              )
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

  Column commentReplyForm(
      String photo,
      String replyNickname,
      String nickname,
      String date,
      String content,
      int comentsId,
      int _comentsId,
      Function refetch,
      int _checkFlag) {
    String replyText =
        content.substring(replyNickname.length + 1, content.length);
    return Column(
      children: [
        SizedBox(height: ScreenUtil().setSp(20)),
        Container(
          width: ScreenUtil().screenWidth,
          padding: EdgeInsets.only(
              left: ScreenUtil().setSp(34), right: ScreenUtil().setSp(20)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: ScreenUtil().setSp(25),
                height: ScreenUtil().setSp(25),
                decoration: photo == null
                    ? BoxDecoration(
                        color: app_grey,
                        borderRadius: BorderRadius.circular(100))
                    : BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover, image: NetworkImage(photo)),
                        borderRadius: BorderRadius.circular(100)),
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
                      SizedBox(height: ScreenUtil().setSp(6)),
                      RichText(
                        text: TextSpan(
                            text: "@$replyNickname",
                            style: TextStyle(
                                letterSpacing: -0.35,
                                fontSize: ScreenUtil().setSp(14),
                                color: app_blue),
                            children: [
                              TextSpan(
                                text: _checkFlag != 2
                                    ? " $replyText"
                                    : " 삭제된 댓글입니다.",
                                style: TextStyle(
                                    letterSpacing: -0.35,
                                    color: _checkFlag != 2
                                        ? Colors.black
                                        : app_font_grey,
                                    fontSize: ScreenUtil().setSp(14)),
                              )
                            ]),
                      ),
                      SizedBox(height: ScreenUtil().setSp(8)),
                      InkWell(
                        onTap: () {
                          setState(() {
                            replyCommentId = comentsId;
                            replyCommentNickname = nickname;
                          });
                          commentController.text = "@$nickname ";
                          commentController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: commentController.text.length));
                          focusNode.requestFocus();
                        },
                        child: Text(
                          "답글 달기",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color: app_font_grey,
                              letterSpacing: -0.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) =>
                        CommentCupertinoBottomSheet(
                      comentsId: _comentsId,
                      comentText: content,
                      refetchCallback: refetch,
                    ),
                  );
                },
                child: Image.asset("assets/images/comment_toggle_button.png",
                    width: ScreenUtil().setSp(28),
                    height: ScreenUtil().setSp(28)),
              )
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

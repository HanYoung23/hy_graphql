import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/widgets/comment_cupertino_bottom_sheet.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';

class CommentBottomSheet extends StatefulWidget {
  final int contentsId;
  final int customerId;
  final int commentCount;
  const CommentBottomSheet(
      {Key key,
      @required this.contentsId,
      @required this.customerId,
      @required this.commentCount})
      : super(key: key);

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final commentController = TextEditingController();
  final ScrollController commentScrollController = ScrollController();

  FocusNode focusNode;
  bool isLeft = true;
  bool isValid = false;
  //
  int editCommentId;
  String editCommentText;
  int replyCommentId = 0;
  String replyCommentNickname = "";
  //
  // List commentPages = [1];
  //
  bool isRefreshing = false;
  //
  double lastCoord;
  //
  bool isBottom = false;

  commentEditCallback(commentId, commentText) {
    if (commentId != null) {
      setState(() {
        editCommentId = commentId;
        editCommentText = commentText;
      });
      commentController.text = commentText;
    } else {
      setState(() {
        replyCommentNickname = "";
      });
    }
  }

  // bool onCommentNotification(ScrollEndNotification t) {
  //   if (t.metrics.pixels > 0 && t.metrics.atEdge) {
  //     List newPages = commentPages;
  //     int lastPage = newPages.length;
  //     newPages.add(lastPage + 1);
  //     setState(() {
  //       commentPages = newPages;
  //     });
  //     // print("🚨 commentPages : $commentPages");
  //   } else {
  //     // print('I am at the start');
  //   }
  //   return true;
  // }

  refresh() {
    setState(() {
      isRefreshing = true;
    });
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        isRefreshing = false;
      });
    });
  }

  moveScroll() {
    if (isBottom) {
      commentScrollController
          .jumpTo(commentScrollController.position.maxScrollExtent);
      setState(() {
        isBottom = false;
      });
    } else if (lastCoord != null) {
      commentScrollController.jumpTo(lastCoord);
      setState(() {
        lastCoord = null;
      });
    }
  }

  // setCommentPages() {
  //   int comments = widget.commentCount;
  //   int pages = (comments / 30).ceil();
  //   List pageList = [];
  //   for (int i = 1; i < pages + 1; i++) {
  //     pageList.add(i);
  //   }
  //   setState(() {
  //     commentPages = pageList;
  //   });
  //   // print("🚨 commentPages : $commentPages");
  //   // print("🚨 pageList : $pageList");
  // }

  @override
  void dispose() {
    commentController.dispose();
    commentScrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // print("🚨 id : ${widget.contentsId}");
    focusNode = FocusNode();
    commentScrollController.addListener(() {
      if (commentScrollController.offset < refreshOffset) {
        // print("🚨 ${commentScrollController.offset}");
        Future.delayed(Duration(milliseconds: 200), () => refresh());
      }
    });
    // setCommentPages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight * 0.9,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Query(
            options: QueryOptions(
              document: gql(Queries.comentsList),
              variables: {
                "contents_id": widget.contentsId,
                "sequence": isLeft ? 1 : 2,
              },
            ),
            builder: (result, {refetch, fetchMore}) {
              if (!result.isLoading) {
                // print(
                //     "🚨 comments : ${result.data["coments_list"]["results"][0]}");

                List comentsList = result.data["coments_list"]["results"];
                // print("🚨 comments : $comentsList");
                return Column(
                  children: [
                    SizedBox(height: ScreenUtil().setSp(30)),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setSp(20)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              !isRefreshing
                                  ? Query(
                                      options: QueryOptions(
                                        document: gql(Queries.comentsNum),
                                        variables: {
                                          "contents_id": widget.contentsId,
                                          "customer_id": widget.customerId,
                                        },
                                      ),
                                      builder: (result, {refetch, fetchMore}) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          moveScroll();
                                        });

                                        if (!result.isLoading &&
                                            result.data != null) {
                                          Map resultData =
                                              result.data["photo_detail"];
                                          int comentsCount =
                                              resultData["coments_count"];
                                          return Text("댓글 $comentsCount",
                                              style: TextStyle(
                                                fontFamily: "NotoSansCJKkrBold",
                                                fontSize:
                                                    ScreenUtil().setSp(16),
                                                letterSpacing: ScreenUtil()
                                                    .setSp(letter_spacing),
                                              ));
                                        } else {
                                          return Container();
                                        }
                                      })
                                  : CupertinoActivityIndicator(),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Text("닫기",
                                    style: TextStyle(
                                      fontFamily: "NotoSansCJKkrBold",
                                      fontSize: ScreenUtil().setSp(16),
                                      letterSpacing:
                                          ScreenUtil().setSp(letter_spacing),
                                    )),
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
                                },
                                child: Text("등록순",
                                    style: TextStyle(
                                      fontFamily: "NotoSansCJKkrBold",
                                      fontSize: ScreenUtil().setSp(14),
                                      letterSpacing: ScreenUtil()
                                          .setSp(letter_spacing_small),
                                      color:
                                          isLeft ? Colors.black : app_font_grey,
                                    )),
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
                                      fontFamily: "NotoSansCJKkrBold",
                                      fontSize: ScreenUtil().setSp(14),
                                      letterSpacing: ScreenUtil()
                                          .setSp(letter_spacing_small),
                                      color: !isLeft
                                          ? Colors.black
                                          : app_font_grey,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setSp(4)),
                    // isRefreshing ? CupertinoActivityIndicator() : Container(),
                    comentsList.length == 0
                        ? Expanded(
                            child: Container(
                              child: Center(
                                child: Text(
                                  "텅 빈 공간이에요\n의견을 나눠보세요 :)",
                                  style: TextStyle(
                                      fontFamily: "NotoSansCJKkrRegular",
                                      fontSize: ScreenUtil().setSp(16),
                                      letterSpacing:
                                          ScreenUtil().setSp(letter_spacing),
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
                            child: !isRefreshing
                                ? commentsListView(comentsList, refetch)
                                : CupertinoActivityIndicator()),
                    comentsList.length != 0 ? Spacer() : Container(),
                    editCommentId == null
                        ? textInput(context, refetch)
                        : editTextInput(context, refetch),
                    // SizedBox(height: ScreenUtil().setSp(20)),
                    comentsList.length != 0 ? Spacer() : Container(),
                  ],
                );
              } else {
                return CupertinoActivityIndicator();
              }
            }));
  }

  ListView commentsListView(List comentsList, Function refetch) {
    return ListView(
        controller: commentScrollController,
        children: comentsList.map((comment) {
          String nickname = comment["nick_name"];
          String profilePhotoLInk = comment["profile_photo_link"];
          //
          DateTime dateTime = DateTime.parse(comment["edit_date"] == null
              ? comment["regist_date"]
              : comment["edit_date"]);
          var formatter = new DateFormat('yyyy MMM dd, a h:mm');
          String date = formatter.format(dateTime);
          //
          String content = comment["coment_text"];
          int commentCustomerId = comment["customer_id"];
          int comentsId = comment["coments_id"];
          int comentsIdLink = comment["coments_id_link"];
          int checkFlag = comment["check_flag"];

          List replyList = [];
          comentsList.map((e) {
            if (e["coments_id_link"] == comentsId && e["check_flag"] != 2) {
              replyList.add(e);
            }
          }).toList();

          return comentsIdLink == null
              ? Column(
                  children: [
                    (checkFlag == 2 && replyList.length == 0)
                        ? Container()
                        : commentForm(
                            commentCustomerId,
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
                        String _profilePhotoLInk = e["profile_photo_link"];
                        //
                        DateTime _dateTime = DateTime.parse(
                            e["edit_date"] == null
                                ? e["regist_date"]
                                : e["edit_date"]);
                        var formatter = new DateFormat('yyyy MMM dd, a h:mm');
                        String _date = formatter.format(_dateTime);
                        //
                        String _content = e["coment_text"];
                        int _commentCustomerId = comment["customer_id"];
                        int _comentsId = e["coments_id"];
                        int _checkFlag = e["check_flag"];

                        return commentReplyForm(
                            _commentCustomerId,
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
        }).toList());
  }

  Container textInput(BuildContext context, Function refetch) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
        child: Mutation(
            options: MutationOptions(
                document: gql(Mutations.createComents),
                update: (GraphQLDataProxy proxy, QueryResult result) {},
                onCompleted: (dynamic resultData) {
                  if (replyCommentId == 0 && editCommentId == null && isLeft) {
                    setState(() {
                      isBottom = true;
                    });
                  } else {
                    setState(() {
                      lastCoord = commentScrollController.offset;
                    });
                  }
                  setState(() {
                    replyCommentId = 0;
                    replyCommentNickname = "";
                    editCommentId = null;
                    isValid = false;
                  });
                  refetch();
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
                      replyCommentId = 0;
                      replyCommentNickname = "";
                      isValid = false;
                    });
                  }
                },
                style: TextStyle(
                    fontFamily: "NotoSansCJKkrRegular",
                    fontSize: ScreenUtil().setSp(14),
                    letterSpacing: ScreenUtil().setSp(letter_spacing_small)),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 0, horizontal: ScreenUtil().setSp(10)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: app_grey_dark),
                  ),
                  hintText: replyCommentNickname == "" ? '의견을 남겨보세요' : "",
                  hintStyle: TextStyle(
                      fontFamily: "NotoSansCJKkrRegular",
                      color: Color.fromRGBO(188, 192, 193, 1),
                      fontSize: ScreenUtil().setSp(14)),
                  prefixText: replyCommentNickname != ""
                      ? "@$replyCommentNickname"
                      : "",
                  suffixIcon: InkWell(
                    onTap: () async {
                      if (isValid) {
                        String inputText = commentController.text;
                        String commentText = replyCommentId != 0
                            ? inputText.substring(1, inputText.length)
                            : inputText;
                        runMutation({
                          "contents_id": widget.contentsId,
                          "customer_id": widget.customerId,
                          "coment_text": commentText,
                          "coments_id_link": replyCommentId,
                        });
                        commentController.text = "";
                        FocusScope.of(context).unfocus();
                      }
                    },
                    child: Container(
                      width: ScreenUtil().setSp(56),
                      height: ScreenUtil().setSp(34),
                      margin: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setSp(5),
                          horizontal: ScreenUtil().setSp(8)),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setSp(5)),
                        color: isValid
                            ? Color.fromRGBO(5, 138, 221, 1)
                            : Color.fromRGBO(5, 138, 221, 0.3),
                      ),
                      child: Center(
                          child: Text(
                        "입력",
                        style: TextStyle(
                            fontFamily: "NotoSansCJKkrBold",
                            fontSize: ScreenUtil().setSp(14),
                            letterSpacing:
                                ScreenUtil().setSp(letter_spacing_small),
                            color: Colors.white),
                      )),
                    ),
                  ),
                ),
              );
            }));
  }

  Container editTextInput(BuildContext context, Function refetch) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
        child: Mutation(
            options: MutationOptions(
                document: gql(Mutations.changeComent),
                update: (GraphQLDataProxy proxy, QueryResult result) {},
                onCompleted: (dynamic resultData) {
                  setState(() {
                    replyCommentId = 0;
                    replyCommentNickname = "";
                    editCommentId = null;
                    editCommentText = null;
                    isValid = false;
                    lastCoord = commentScrollController.offset;
                  });
                  refetch();
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
                    fontFamily: "NotoSansCJKkrRegular",
                    fontSize: ScreenUtil().setSp(14),
                    letterSpacing: ScreenUtil().setSp(letter_spacing_small)),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 0, horizontal: ScreenUtil().setSp(10)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: app_grey_dark),
                  ),
                  // hintText: '의견을 남겨보세요',
                  hintStyle: TextStyle(
                      fontFamily: "NotoSansCJKkrRegular",
                      color: Color.fromRGBO(188, 192, 193, 1),
                      fontSize: ScreenUtil().setSp(14)),
                  prefixText: replyCommentNickname != ""
                      ? "@$replyCommentNickname"
                      : "",
                  suffixIcon: InkWell(
                    onTap: () async {
                      String inputValue = commentController.text;
                      if (isValid) {
                        runMutation({
                          "type": "edit",
                          "coments_id": editCommentId,
                          "coment_text": inputValue,
                        });
                        commentController.text = "";
                        setState(() {
                          replyCommentId = 0;
                          replyCommentNickname = "";
                          editCommentId = null;
                          editCommentText = null;
                          isValid = false;
                        });
                        FocusScope.of(context).unfocus();
                      }
                    },
                    child: Container(
                      width: ScreenUtil().setSp(56),
                      height: ScreenUtil().setSp(34),
                      margin: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setSp(5),
                          horizontal: ScreenUtil().setSp(8)),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setSp(5)),
                        color: isValid
                            ? Color.fromRGBO(5, 138, 221, 1)
                            : Color.fromRGBO(5, 138, 221, 0.3),
                      ),
                      child: Center(
                          child: Text(
                        "수정",
                        style: TextStyle(
                            fontFamily: "NotoSansCJKkrBold",
                            fontSize: ScreenUtil().setSp(14),
                            letterSpacing:
                                ScreenUtil().setSp(letter_spacing_small),
                            color: Colors.white),
                      )),
                    ),
                  ),
                ),
              );
            }));
  }

  Column commentForm(
      int commentCustomerId,
      String photo,
      String nickname,
      String date,
      String content,
      int comentsId,
      int comentsIdLink,
      Function refetch,
      int checkFlag) {
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
                decoration: "$photo" == "null"
                    ? BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/profileSettings/thumbnail_default.png"),
                            fit: BoxFit.cover),
                      )
                    : BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover, image: NetworkImage(photo)),
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setSp(100)),
                      ),
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
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(14),
                              letterSpacing:
                                  ScreenUtil().setSp(letter_spacing_small),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(width: ScreenUtil().setSp(10)),
                          Expanded(
                            child: Text(
                              date,
                              style: TextStyle(
                                fontFamily: "NotoSansCJKkrRegular",
                                fontSize: ScreenUtil().setSp(14),
                                letterSpacing:
                                    ScreenUtil().setSp(letter_spacing_small),
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
                            fontFamily: "NotoSansCJKkrRegular",
                            fontSize: ScreenUtil().setSp(14),
                            color:
                                checkFlag != 2 ? Colors.black : app_font_grey,
                            letterSpacing:
                                ScreenUtil().setSp(letter_spacing_small)),
                      ),
                      SizedBox(height: ScreenUtil().setSp(8)),
                      InkWell(
                        onTap: () {
                          setState(() {
                            replyCommentId = comentsId;
                            replyCommentNickname = nickname;
                            // lastCoord = commentScrollController.offset;
                          });
                          commentController.text = " ";
                          commentController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: commentController.text.length));
                          focusNode.requestFocus();
                        },
                        child: Text(
                          "답글 달기",
                          style: TextStyle(
                              fontFamily: "NotoSansCJKkrRegular",
                              fontSize: ScreenUtil().setSp(12),
                              color: app_font_grey,
                              letterSpacing:
                                  ScreenUtil().setSp(letter_spacing_x_small)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (widget.customerId == commentCustomerId &&
                      checkFlag == 1) {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) =>
                          CommentCupertinoBottomSheet(
                              comentsId: comentsId,
                              comentText: content,
                              refetchCallback: refetch,
                              editCommentCallback: (id, text) =>
                                  commentEditCallback(id, text)),
                    );
                  }
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
      int commentCustomerId,
      String photo,
      String replyNickname,
      String nickname,
      String date,
      String content,
      int comentsId,
      int _comentsId,
      Function refetch,
      int _checkFlag) {
    String replyText = content.substring(0, content.length);
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
                decoration: "$photo" == "null"
                    ? BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/profileSettings/thumbnail_default.png"),
                            fit: BoxFit.cover),
                      )
                    : BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover, image: NetworkImage(photo)),
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setSp(100)),
                      ),
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
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(14),
                              letterSpacing:
                                  ScreenUtil().setSp(letter_spacing_small),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(width: ScreenUtil().setSp(10)),
                          Expanded(
                            child: Text(
                              date,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(14),
                                letterSpacing:
                                    ScreenUtil().setSp(letter_spacing_small),
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
                                fontFamily: "NotoSansCJKkrBold",
                                letterSpacing:
                                    ScreenUtil().setSp(letter_spacing_small),
                                fontSize: ScreenUtil().setSp(14),
                                color: app_blue),
                            children: [
                              TextSpan(
                                text: _checkFlag != 2
                                    ? " $replyText"
                                    : " 삭제된 댓글입니다.",
                                style: TextStyle(
                                    fontFamily: "NotoSansCJKkrRegular",
                                    letterSpacing: ScreenUtil()
                                        .setSp(letter_spacing_small),
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
                            // lastCoord = commentScrollController.offset;
                          });
                          commentController.text = " ";
                          commentController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: commentController.text.length));
                          focusNode.requestFocus();
                        },
                        child: Text(
                          "답글 달기",
                          style: TextStyle(
                              fontFamily: "NotoSansCJKkrRegular",
                              fontSize: ScreenUtil().setSp(12),
                              color: app_font_grey,
                              letterSpacing:
                                  ScreenUtil().setSp(letter_spacing_x_small)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (widget.customerId == commentCustomerId &&
                      _checkFlag == 1) {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) =>
                          CommentCupertinoBottomSheet(
                        comentsId: _comentsId,
                        comentText: content,
                        refetchCallback: refetch,
                        editCommentCallback: (id, text) =>
                            commentEditCallback(id, text),
                      ),
                    );
                    setState(() {
                      replyNickname = replyNickname;
                    });
                  }
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

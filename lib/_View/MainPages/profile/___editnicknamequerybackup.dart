// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:letsgotrip/constants/common_value.dart';
// import 'package:letsgotrip/widgets/graphql_query.dart';

// class ProfileEditNicknameScreen extends StatefulWidget {
//   final String nickname;
//   final Function setNickname;
//   final int customerId;
//   const ProfileEditNicknameScreen(
//       {Key key,
//       @required this.nickname,
//       @required this.setNickname,
//       @required this.customerId})
//       : super(key: key);

//   @override
//   _ProfileEditNicknameScreenState createState() =>
//       _ProfileEditNicknameScreenState();
// }

// class _ProfileEditNicknameScreenState extends State<ProfileEditNicknameScreen> {
//   final nicknameController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   final validChar = RegExp(r'^[ㄱ-ㅎ가-힣a-zA-Z0-9]+$');

//   Color enableColor = Color.fromRGBO(5, 138, 221, 1);
//   Color focusColor = Color.fromRGBO(211, 211, 211, 1);
//   Color errorColor = Color.fromRGBO(255, 49, 32, 1);
//   Color currentColor = Color.fromRGBO(211, 211, 211, 1);
//   String inputMessage = "";
//   XFile pickedImage;
//   bool isValid = false;
//   bool isAllFilled = false;
//   bool isQuery = false;
//   String inputText;

//   @override
//   void dispose() {
//     nicknameController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     nicknameController.text = widget.nickname;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("🚨🚨 $isQuery");
//     return SafeArea(
//       top: false,
//       bottom: false,
//       child: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             toolbarHeight: 0,
//             elevation: 0,
//             backgroundColor: Colors.white,
//             brightness: Brightness.light,
//           ),
//           resizeToAvoidBottomInset: false,
//           body: Container(
//             padding: EdgeInsets.all(ScreenUtil().setSp(20)),
//             child: Column(
//               children: [
//                 Container(
//                   width: ScreenUtil().screenWidth,
//                   height: ScreenUtil().setSp(44),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       InkWell(
//                           onTap: () {
//                             Get.back();
//                           },
//                           child: Image.asset("assets/images/arrow_back.png",
//                               width: ScreenUtil().setSp(arrow_back_size),
//                               height: ScreenUtil().setSp(arrow_back_size))),
//                       Text(
//                         "프로필 별명",
//                         style: TextStyle(
//                           fontFamily: "NotoSansCJKkrBold",
//                           fontSize: ScreenUtil().setSp(appbar_title_size),
//                           letterSpacing: ScreenUtil().setSp(letter_spacing),
//                         ),
//                       ),
//                       Query(
//                           options: QueryOptions(
//                             document: gql(Queries.checkNickname),
//                             variables: {
//                               "nick_name": inputText,
//                               "customer_id": widget.customerId,
//                             },
//                           ),
//                           builder: (result, {refetch, fetchMore}) {
//                             if (!result.isLoading && result.data != null) {
//                               Map resultData = result.data["check_nickname"];
//                               String resultValue = "${resultData["result"]}";

//                               return InkWell(
//                                 onTap: () {
//                                   if (resultValue == "true" && isQuery) {
//                                     widget.setNickname(nicknameController.text);
//                                     Get.back();
//                                   }
//                                 },
//                                 child: Container(
//                                   alignment: Alignment.centerRight,
//                                   child: Text(
//                                     "완료",
//                                     style: TextStyle(
//                                       fontFamily: "NotoSansCJKkrBold",
//                                       fontSize:
//                                           ScreenUtil().setSp(appbar_title_size),
//                                       letterSpacing:
//                                           ScreenUtil().setSp(letter_spacing),
//                                       color: resultValue == "true" && isQuery
//                                           ? Colors.black
//                                           : app_font_grey,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             } else {
//                               return Container(
//                                 alignment: Alignment.centerRight,
//                                 child: Text(
//                                   "완료",
//                                   style: TextStyle(
//                                     fontFamily: "NotoSansCJKkrBold",
//                                     fontSize:
//                                         ScreenUtil().setSp(appbar_title_size),
//                                     letterSpacing:
//                                         ScreenUtil().setSp(letter_spacing),
//                                     color: app_font_grey,
//                                   ),
//                                 ),
//                               );
//                             }
//                           })
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: ScreenUtil().setSp(30)),
//                 Row(mainAxisAlignment: MainAxisAlignment.start, children: [
//                   Image.asset(
//                       "assets/images/profileSettings/profile_nickname.png",
//                       width: ScreenUtil().setSp(66),
//                       height: ScreenUtil().setSp(20))
//                 ]),
//                 SizedBox(height: ScreenUtil().setSp(5)),
//                 Container(
//                     alignment: Alignment.bottomLeft,
//                     child: TextFormField(
//                       controller: nicknameController,
//                       cursorColor: Colors.black,
//                       keyboardType: TextInputType.text,
//                       onChanged: (value) {
//                         if (value.length > 0 && value.length < 13) {
//                           String typedData = value[value.length - 1];
//                           if (!validChar.hasMatch(typedData) ||
//                               typedData == " ") {
//                             setState(() {
//                               isValid = false;
//                               inputMessage = "별명은 한글, 영문, 숫자만 사용 가능합니다.";
//                               currentColor = errorColor;
//                             });
//                           } else if (nicknameController.text.length < 2) {
//                             setState(() {
//                               isValid = false;
//                               inputMessage = "";
//                               currentColor = focusColor;
//                             });
//                           } else if (nicknameController.text ==
//                               widget.nickname) {
//                             setState(() {
//                               isValid = false;
//                               inputMessage = "현재와 동일한 별명입니다.";
//                               currentColor = errorColor;
//                             });
//                           } else {
//                             setState(() {
//                               isValid = true;
//                               inputMessage = "";
//                               inputText = nicknameController.text;
//                               currentColor = focusColor;
//                             });
//                           }
//                         } else if (value.length > 12) {
//                           setState(() {
//                             isValid = false;
//                             inputMessage = "12자 이상은 사용 불가합니다.";
//                             currentColor = errorColor;
//                           });
//                         } else {
//                           setState(() {
//                             isValid = false;
//                             inputMessage = "";
//                             currentColor = focusColor;
//                           });
//                         }
//                         setState(() {
//                           isAllFilled = false;
//                           isQuery = false;
//                         });
//                       },
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 0, horizontal: ScreenUtil().setSp(10)),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: currentColor),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.black),
//                         ),
//                         hintText: '별명을 입력해주세요',
//                         hintStyle: TextStyle(
//                             fontFamily: "NotoSansCJKkrRegular",
//                             color: Color.fromRGBO(188, 192, 193, 1),
//                             letterSpacing:
//                                 ScreenUtil().setSp(letter_spacing_small),
//                             fontSize: ScreenUtil().setSp(14)),
//                         suffixIcon: InkWell(
//                           onTap: () {
//                             if (isValid && !isAllFilled) {
//                               FocusScope.of(context).unfocus();
//                               setState(() {
//                                 isQuery = true;
//                               });
//                             }
//                           },
//                           child: Container(
//                             width: ScreenUtil().setSp(56),
//                             height: ScreenUtil().setSp(34),
//                             margin: EdgeInsets.symmetric(
//                                 vertical: ScreenUtil().setSp(5),
//                                 horizontal: ScreenUtil().setSp(8)),
//                             decoration: BoxDecoration(
//                               borderRadius:
//                                   BorderRadius.circular(ScreenUtil().setSp(5)),
//                               color: isValid
//                                   ? Color.fromRGBO(5, 138, 221, 1)
//                                   : Color.fromRGBO(5, 138, 221, 0.3),
//                             ),
//                             child: Center(
//                                 child: Text(
//                               "적용",
//                               style: TextStyle(
//                                   fontFamily: "NotoSansCJKkrBold",
//                                   fontSize: ScreenUtil().setSp(14),
//                                   letterSpacing:
//                                       ScreenUtil().setSp(letter_spacing_small),
//                                   color: Colors.white),
//                             )),
//                           ),
//                         ),
//                       ),
//                     )),
//                 SizedBox(height: ScreenUtil().setSp(5)),
//                 SizedBox(width: ScreenUtil().setSp(10)),
//                 !isQuery || inputText == null
//                     ? Container(
//                         width: ScreenUtil().screenWidth,
//                         padding: EdgeInsets.only(left: ScreenUtil().setSp(10)),
//                         child: Text(
//                           "$inputMessage",
//                           style: TextStyle(
//                               fontFamily: "NotoSansCJKkrRegular",
//                               fontSize: ScreenUtil().setSp(14),
//                               letterSpacing:
//                                   ScreenUtil().setSp(letter_spacing_small),
//                               color: inputMessage != ""
//                                   ? currentColor
//                                   : Colors.transparent),
//                         ),
//                       )
//                     : Query(
//                         options: QueryOptions(
//                           document: gql(Queries.checkNickname),
//                           variables: {
//                             "nick_name": inputText,
//                             "customer_id": widget.customerId,
//                           },
//                         ),
//                         builder: (result, {refetch, fetchMore}) {
//                           if (!result.isLoading) {
//                             // print(
//                             //     "🚨 nickname edit result : ${result.data["check_nickname"]}");
//                             Map resultData = result.data["check_nickname"];
//                             String resultMessage = resultData["msg"];
//                             String resultValue = "${resultData["result"]}";

//                             return Container(
//                               width: ScreenUtil().screenWidth,
//                               padding:
//                                   EdgeInsets.only(left: ScreenUtil().setSp(10)),
//                               child: Text(
//                                 resultValue == "false"
//                                     ? "$resultMessage"
//                                     : "사용 가능한 별명입니다 :)",
//                                 style: TextStyle(
//                                     fontFamily: "NotoSansCJKkrRegular",
//                                     fontSize: ScreenUtil().setSp(14),
//                                     letterSpacing: ScreenUtil()
//                                         .setSp(letter_spacing_small),
//                                     color: resultValue == "false"
//                                         ? errorColor
//                                         : enableColor),
//                               ),
//                             );
//                           } else {
//                             return Container();
//                           }
//                         }),
//                 SizedBox(height: ScreenUtil().setSp(15)),
//                 Container(
//                   padding: EdgeInsets.only(left: ScreenUtil().setSp(10)),
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "한글 2~12자, 영문 대소문자, 숫자 2~20자에 한하여\n사용 가능합니다(혼용가능)",
//                     style: TextStyle(
//                       fontFamily: "NotoSansCJKkrRegular",
//                       letterSpacing: ScreenUtil().setSp(letter_spacing_small),
//                       fontSize: ScreenUtil().setSp(14),
//                       color: app_font_grey,
//                     ),
//                     overflow: TextOverflow.fade,
//                   ),
//                 ),
//                 Spacer(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

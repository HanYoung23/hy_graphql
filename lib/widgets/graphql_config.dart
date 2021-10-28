import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/constants/keys.dart';

class GraphQlConfig {
  static HttpLink _httpLink = HttpLink('$serverUrl');
  // static final AuthLink _authLink = AuthLink(
  //   getToken: () async => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
  // );

  // static final Link link = _authLink.concat(_httpLink);

  static ValueNotifier<GraphQLClient> initClient() {
    try {
      ValueNotifier<GraphQLClient> client = ValueNotifier(
        GraphQLClient(
          link: _httpLink, // authlink 가 없으면 그냥 진행, 있으면 link로 진행
          cache: GraphQLCache(),
        ),
      );
      return client;
    } catch (e) {
      print("🚨 http error : $e");
      return null;
    }
  }
}

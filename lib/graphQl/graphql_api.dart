import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(clientQuery);

GraphQLClient clientQuery = clientToQuery();

GraphQLClient clientToQuery() {
  final policies = Policies(
    fetch: FetchPolicy.networkOnly,
  );
  Link link = HttpLink(
    'https://hdmerchantbackend.herokuapp.com/graphql',
  );
  final WebSocketLink socketLink = WebSocketLink(
    'ws://hdmerchantbackend.herokuapp.com/graphql',
    config: const SocketClientConfig(
      parser: ResponseParser(),
      // autoReconnect: true,
      // inactivityTimeout: Duration(
      //   seconds: 30,
      // ),
      initialPayload: {
        'headers': {'Authorization': 'Bearer'},
      },
    ),
  );

  link = Link.split((request) => request.isSubscription, socketLink, link);

  return GraphQLClient(
      cache: GraphQLCache(
        store: HiveStore(),
      ),
      defaultPolicies: DefaultPolicies(
        watchQuery: policies,
        watchMutation: policies,
        query: policies,
        mutate: policies,
      ),
      link: AuthLink(
        getToken: () async {
          print("Getting Token 1");

          return 'Bearer ';
        },
      ).concat(
        link,
      )
      // .concat(
      //   WebSocketLink(
      //     'wss://hdmerchantbackend.herokuapp.com/graphql',
      //     config: const SocketClientConfig(
      //         autoReconnect: true,
      //         inactivityTimeout: Duration(
      //           seconds: 30,
      //         ),
      //         initialPayload: {
      //           'headers': {'Authorization': 'Bearer'},
      //         }),
      //   ),
      // ),
      );
}

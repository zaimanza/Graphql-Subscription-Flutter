import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(clientQuery);

GraphQLClient clientQuery = clientToQuery();

GraphQLClient clientToQuery() {
  final policies = Policies(
    fetch: FetchPolicy.networkOnly,
  );
  return GraphQLClient(
    // link: HttpLink(uri: 'https://hirodeli.herokuapp.com/graphql'),
    // cache: InMemoryCache(),

    cache: GraphQLCache(store: HiveStore()),
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
      HttpLink(
        'https://hdmerchantbackend.herokuapp.com/graphql',
      ),
    ),
  );
}

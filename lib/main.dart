import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import 'Providers/connectivity_provider.dart';
import 'const/no_glow.dart';
import 'graphQl/graphql_api.dart';
import 'graphQl/merchAuth/merch_log_in_out.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ConnectivityProvider>(
            create: (context) => ConnectivityProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController emailController = TextEditingController();
  bool isEmailEmpty = false;
  String passMutateData = "";

  bool isLoadingCircularOn = false;

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false)
        .startConnectionProvider();
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<ConnectivityProvider>(context, listen: false)
        .disposeConnectionProvider();
  }

  loginGqlCall(loginObj) async {
    setState(() {
      isLoadingCircularOn = true;
    });
    print("NEW NEW NEW");
    print(loginObj);
    QueryResult result;
    result = await clientQuery.mutate(
      MutationOptions(
        document: gql(addChannel),
        variables: loginObj,
      ),
    );

    if (result.hasException == true) {
      setState(() {
        isLoadingCircularOn = false;
      });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(result.exception!.graphqlErrors[0].message.toString()),
      //   ),
      // );
      print(result.exception!.graphqlErrors);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("There is an error."),
        ),
      );
    }

    if (result.data != null) {
      setState(() {
        isLoadingCircularOn = false;
      });
      print(result.data!["addChannel"].toString());
      passMutateData = result.data!["addChannel"].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Consumer<ConnectivityProvider>(
                builder: (context, connectivityProvider, __) {
              return ScrollConfiguration(
                behavior: NoGlow(),
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: IntrinsicHeight(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 30,
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: const ShapeDecoration(
                                      color: Color(0xFF4A4B4D),
                                      shape: StadiumBorder(),
                                    ),
                                    child: TextFormField(
                                      autofillHints: const [
                                        AutofillHints.email
                                      ],
                                      buildCounter: (BuildContext context,
                                              {required currentLength,
                                              maxLength,
                                              required isFocused}) =>
                                          null,
                                      maxLength: 320,
                                      onChanged: (value) {
                                        setState(() {
                                          isEmailEmpty = false;
                                        });
                                      },
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Name",
                                        hintStyle: TextStyle(
                                          color: Color(0xFFB6B7B7),
                                        ),
                                        contentPadding:
                                            EdgeInsets.only(left: 40),
                                      ),
                                    ),
                                  ),
                                  if (isEmailEmpty) ...[
                                    const Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Not a valid email. Email needs to contain '@' and '.'",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFE53935),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          const Color(0xFFE53935),
                                        ),
                                      ),
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();
                                        print("hi aiman");
                                        if (emailController.text.isNotEmpty) {
                                          Map<String, dynamic> loginObj = {};
                                          // check email
                                          setState(() {
                                            if (emailController.text.isEmpty) {
                                              isEmailEmpty = true;
                                            } else {
                                              isEmailEmpty = false;
                                              loginObj['addChannelName'] =
                                                  emailController.text;
                                            }
                                          });

                                          if (connectivityProvider
                                                  .connectionStatus ==
                                              true) {
                                            if (loginObj.isNotEmpty) {
                                              loginGqlCall(loginObj);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Email field is empty."),
                                                ),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "No internet connection."),
                                              ),
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text("Email field is empty."),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text("Send Name"),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  const Text("Mutation Data:"),
                                  Text(passMutateData),
                                  const Text("Subscription Data:"),
                                  Subscription(
                                    options: SubscriptionOptions(
                                      document: gql(channelAdded),
                                      variables: {
                                        "name": "aiman",
                                      },
                                    ),
                                    builder: (result) {
                                      if (result.isLoading) {
                                        print("DATA IS LOADING");
                                      }
                                      if (result.hasException) {
                                        print("DATA IS ERROR");
                                        print(result.exception);
                                      }
                                      if (result.data != null) {
                                        print("DATA IS DATA");
                                        print(result.data.toString());
                                        return Container(
                                          color: Colors.red,
                                          height: 10,
                                          width: 10,
                                        );
                                      }
                                      // if (result.data != null) {
                                      //   print("ada subscription");
                                      // }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                              if (isLoadingCircularOn == true) ...[
                                Center(
                                  child: Container(
                                    color: Colors.transparent,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                )
                              ],
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

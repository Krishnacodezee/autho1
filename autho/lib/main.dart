import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:oauth2/oauth2.dart' as oauth2;

void main() async {
  var client = await createClient();

  print(await client.read(Uri.http('example.com', 'protected-resources.txt')));

  await credentialsFile.writeAsString(client.credentials.toJson());
}

Future<void> redirect(Uri url) async {}

Future<Uri> listen(Uri url) async {
  return Uri();
  runApp(const MyApp());
}

final authorizationEndpoint =
    Uri.parse('http://example.com/oauth2/authorization');

final tokenEndpoint = Uri.parse('http://example.com/oauth2/token');

final identifier = 'my client identifier';

final secret = 'my client secret';

final credentialsFile = File('~/.myapp/credentials.json');

Future<oauth2.Client> createClient() async {
  var exists = await credentialsFile.exists();

  if (exists) {
    var credentials =
        oauth2.Credentials.fromJson(await credentialsFile.readAsString());
    return oauth2.Client(credentials, identifier: identifier, secret: secret);
  }

  var grant = oauth2.AuthorizationCodeGrant(
      identifier, authorizationEndpoint, tokenEndpoint,
      secret: secret);

  var authorizationUrl = grant.getAuthorizationUrl(redirectUrl);

  await redirect(authorizationUrl);

  var responseUrl = await listen(redirectUrl);
  return await grant.handleAuthorizationResponse(responseUrl.queryParameters);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OAuth Demo app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(onPressed: () {}, child: Text('button 1')),
            TextButton(onPressed: () {}, child: Text('button 2'))
          ],
        ),
      ),
    );
  }
}

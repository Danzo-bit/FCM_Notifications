import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//Add stream controller
final _messageStreamController = BehaviorSubject<RemoteMessage>();

//Define the background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
 await Firebase.initializeApp();

 if (kDebugMode) {
   print("Handling a background message: ${message.messageId}");
   print('Message data: ${message.data}');
   print('Message notification: ${message.notification?.title}');
   print('Message notification: ${message.notification?.body}');
 }
}

Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
 //initialization
 await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
 );

 //Request permission
 final messaging = FirebaseMessaging.instance;

final settings = await messaging.requestPermission(
 alert: true,
 announcement: false,
 badge: true,
 carPlay: false,
 criticalAlert: false,
 provisional: false,
 sound: true,
);

 if (kDebugMode) {
   print('Permission granted: ${settings.authorizationStatus}');
 }
 // Register with FCM
 String? token;
 const vapidKey = "BH2kATjOsEJ8Kt8T2EcaElzKInQBOqm9VqpblGNvJNYe9x5T_BscfdhH1X77_rwSKa5nYzZz3XQNpxbBGLf4nPE";

  if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
   token = await messaging.getToken(
     vapidKey: vapidKey,
   );
 } else {
   token = await messaging.getToken();
 }

if (kDebugMode) {
  print('Registration Token=$token');
}
 //Set up foreground message handler

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
   if (kDebugMode) {
     print('Handling a foreground message: ${message.messageId}');
     print('Message data: ${message.data}');
     print('Message notification: ${message.notification?.title}');
     print('Message notification: ${message.notification?.body}');
   }

   _messageStreamController.sink.add(message);
  });
 
 //Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

 runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
              primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Firebase Cloud Messaging'),
    );
  }
}

//adds a subscriber to the stream controller in the
// State widget and displays the last message on the widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 String _lastMessage = "";

 _MyHomePageState() {
   _messageStreamController.listen((message) {
     setState(() {
       if (message.notification != null) {
         _lastMessage = 'Received a notification message:'
             '\nTitle=${message.notification?.title},'
             '\nBody=${message.notification?.body},'
             '\nData=${message.data}';
       } else {
         _lastMessage = 'Received a data message: ${message.data}';
       }
     });
   });
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text(widget.title),
     ),
     body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           Text('Last message from Firebase Messaging:',
               style: Theme.of(context).textTheme.titleLarge),
           Text(_lastMessage, style: Theme.of(context).textTheme.bodyLarge),
         ],
       ),
     ),
   );
 }
}

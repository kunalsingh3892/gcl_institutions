import 'dart:async';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grewal/screens/add_question/enter_question.dart';
import 'package:grewal/screens/add_question/question_chapter_select.dart';
import 'package:grewal/screens/add_support.dart';
import 'package:grewal/screens/batch_list.dart';
import 'package:grewal/screens/change_password.dart';
import 'package:grewal/screens/chapter_overview.dart';
import 'package:grewal/screens/chapter_select.dart';

import 'package:grewal/screens/chapters_list.dart';
import 'package:grewal/screens/create_batch.dart';
import 'package:grewal/screens/create_mcq.dart';
import 'package:grewal/screens/create_ticket.dart';
import 'package:grewal/screens/dashboard.dart';
import 'package:grewal/screens/home_page.dart';
import 'package:grewal/screens/institute_test_list.dart';
import 'package:grewal/screens/institute_test_list_performance.dart';
import 'package:grewal/screens/intro_screens.dart';
import 'package:grewal/screens/leaderboard.dart';
import 'package:grewal/screens/mts.dart';
import 'package:grewal/screens/notifications.dart';
import 'package:grewal/screens/open_pdf.dart';
import 'package:grewal/screens/overall_performance.dart';
import 'package:grewal/screens/overall_performance_details.dart';
import 'package:grewal/screens/sample.dart';
import 'package:grewal/screens/settings.dart';
import 'package:grewal/screens/sign_otp_verification.dart';
import 'package:grewal/screens/sign_up.dart';
import 'package:grewal/screens/splash.dart';
import 'package:grewal/screens/static_screens/privacy_policy.dart';
import 'package:grewal/screens/static_screens/refund_policies.dart';
import 'package:grewal/screens/static_screens/t_c.dart';
import 'package:grewal/screens/student_list.dart';
import 'package:grewal/screens/support_detail.dart';
import 'package:grewal/screens/support_list.dart';
import 'package:grewal/screens/test_list.dart';
import 'package:grewal/screens/ticket_details.dart';
import 'package:grewal/screens/ticket_list.dart';
import 'package:grewal/screens/update_profile.dart';
import 'package:grewal/screens/videos_screen/answer_key.dart';
import 'package:grewal/screens/videos_screen/create_test.dart';
import 'package:grewal/screens/videos_screen/create_test_new.dart';
import 'package:grewal/screens/videos_screen/question_view.dart';
import 'package:grewal/screens/videos_screen/stu_list.dart';
import 'package:grewal/screens/videos_screen/student_summary.dart';
import 'package:grewal/screens/videos_screen/students_summary.dart';
import 'package:grewal/screens/videos_screen/test_dash.dart';
import 'package:grewal/screens/videos_screen/videos.dart';
import 'package:grewal/screens/videos_screen/videos_detail.dart';
import 'package:grewal/screens/view_performance.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/reset_password.dart';
import 'screens/get_otp.dart';
import 'screens/login_with_logo.dart';
import 'screens/otp_verification.dart';
import 'screens/plan.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'screens/test_correct.dart';
import 'screens/view_test.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(MyApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });

}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loggedIn = false;
  int id = 0;
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  static final facebookAppEvents = FacebookAppEvents();
  void initState() {
    super.initState();

    //  _checkLoggedIn();
  }

  Map<int, Color> color =
  {
    50:Color.fromRGBO(136,14,79, .1),
    100:Color.fromRGBO(136,14,79, .2),
    200:Color.fromRGBO(136,14,79, .3),
    300:Color.fromRGBO(136,14,79, .4),
    400:Color.fromRGBO(136,14,79, .5),
    500:Color.fromRGBO(136,14,79, .6),
    600:Color.fromRGBO(136,14,79, .7),
    700:Color.fromRGBO(136,14,79, .8),
    800:Color.fromRGBO(136,14,79, .9),
    900:Color.fromRGBO(136,14,79, 1),
  };


/*  _checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _isLoggedIn = prefs.getBool('logged_in');
    if (_isLoggedIn == true) {
      setState(() {
        _loggedIn = _isLoggedIn;
      });
    } else {
      setState(() {
        _loggedIn = false;
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xff017EFF, color);
    return MaterialApp(
      title: 'GCL for Institutions',
      navigatorObservers: <NavigatorObserver>[observer],
      theme: ThemeData(
        primarySwatch: colorCustom,
        visualDensity: VisualDensity.adaptivePlatformDensity,

      ),

      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return PageTransition(
              child: SplashScreen(),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/intro-screens':
            return PageTransition(
              child: IntroScreens(),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/login-with-logo':
            return PageTransition(
              child: LoginWithLogo(),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/reset-password':
            var obj = settings.arguments;
            return PageTransition(
              child: RestPassword(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/change-password':
            return PageTransition(
              child: ChangePassword(),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/get-otp':
            var obj = settings.arguments;
            return PageTransition(
              child: GetOTP(),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;

          case '/otp-verification':
            var obj = settings.arguments;
            return PageTransition(
              child: OTPVerification(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/sign-otp-verification':
            var obj = settings.arguments;
            return PageTransition(
              child: SignOTPVerification(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;

          case '/plan':
            var obj = settings.arguments;
            return PageTransition(
              child: MyPlan(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/sign-up':
            var obj = settings.arguments;
            return PageTransition(
              child: SignIn("yes"),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;



          case '/dashboard':
            return PageTransition(
              child: Dashboard(),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/home-page':
            return PageTransition(
              child: HomePage(),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/settings':
            return PageTransition(
              child: Settings(),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/update-profile':
            return PageTransition(
              child: UpdateProfile("yes"),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;

          case '/chapters-list':
            return PageTransition(
              child: ChapterList("yes"),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/chapter-overview':
            var obj = settings.arguments;
            return PageTransition(
              child: ChapterOverview(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
            case '/create-mcq':
            var obj = settings.arguments;
            return PageTransition(
              child: CreateMCQ(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/create-ticket':
            var obj = settings.arguments;
            return PageTransition(
              child: CreateTicket(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/test-list':
            var obj = settings.arguments;
            return PageTransition(
              child: TestList(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/institute-test-list':
            //var obj = settings.arguments;
            return PageTransition(
              child: InstituteTestList("yes"),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/ticket-list':
            var obj = settings.arguments;
            return PageTransition(
              child: TicketList(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/ticket-details':
            var obj = settings.arguments;
            return PageTransition(
              child: TicketDetails(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/test-correct':
            var obj = settings.arguments;
            return PageTransition(
              child: StartMCQ(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/view-test':
            var obj = settings.arguments;
            return PageTransition(
              child: ViewMCQ(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/view-performance':
            var obj = settings.arguments;
            return PageTransition(
              child: ViewPerformance(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/open-pdf':
            var obj = settings.arguments;
            return PageTransition(
              child: Viewer(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/sample':
            var obj = settings.arguments;
            return PageTransition(
              child: ViewPerformanceChart(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;


          case '/chapter-select':
           // var obj = settings.arguments;
            return PageTransition(
              child: ChapterListScreen(),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/support-list':
          //  var obj = settings.arguments;
            return PageTransition(
              child: SupportList("yes"),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;

          case '/support-detail':
            var obj = settings.arguments;
            return PageTransition(
              child: SupportOverview(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;

          case '/add-support':
            var obj = settings.arguments;
            return PageTransition(
              child: AddSupport(),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;

          case '/overall-performance':
            var obj = settings.arguments;
            return PageTransition(
              child: OverAllPerformance(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/overall-performance-details':
            var obj = settings.arguments;
            return PageTransition(
              child: OverAllDetails(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/videos':
            var obj = settings.arguments;
            return PageTransition(
              child: VideosList(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/videos-detail':
            var obj = settings.arguments;
            return PageTransition(
              child: VideoDetail(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/privacy-policy':
            return PageTransition(
              child: Privacy(),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/refund-policies':
            return PageTransition(
              child: Refund(),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/t-c':
            var obj = settings.arguments;
            return PageTransition(
              child: TAndC(),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;

          case '/t-c':
            var obj = settings.arguments;
            return PageTransition(
              child: TAndC(),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/mts':
            var obj = settings.arguments;
            return PageTransition(
              child: MTS(),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;

          case '/notifications':
            var obj = settings.arguments;
            return PageTransition(
              child: NotificationsPage(),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/batch-list':
            var obj = settings.arguments;
            return PageTransition(
              child: BatchList("yes"),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
            case '/create-batch':
            var obj = settings.arguments;
            return PageTransition(
              child: AddBatch(),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;

          case '/student-list':
            var obj = settings.arguments;
            return PageTransition(
              child: StudentList(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;

          case '/leaderboard':
            var obj = settings.arguments;
            return PageTransition(
              child: LeaderBoard("yes"),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;

          case '/institute-test-list-performance':
            var obj = settings.arguments;
            return PageTransition(
              child: InstituteTestListPerformance(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/question-view':
            var obj = settings.arguments;
            return PageTransition(
              child: QuestionView(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;

          case '/create-test':
            var obj = settings.arguments;
            return PageTransition(
              child: CreateQuestion(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/create-test-new':
            var obj = settings.arguments;
            return PageTransition(
              child: CreateQuestionNew(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;

          case '/stu-list':
            var obj = settings.arguments;
            return PageTransition(
              child: StudentListTwo(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;

          case '/test-dash':
            var obj = settings.arguments;
            return PageTransition(
              child: TestDash(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;

          case '/answer-key':
            var obj = settings.arguments;
            return PageTransition(
              child: ReViewMCQ(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;

          case '/students-summary':
            var obj = settings.arguments;
            return PageTransition(
              child: StudentSummary(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/question-chapter-select':

            return PageTransition(
              child: AddQuestionFirst(),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;
          case '/enter-question':
            var obj = settings.arguments;
            return PageTransition(
              child: AddQuestionSecond(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;

          case '/student-summary':
            var obj = settings.arguments;
            return PageTransition(
              child: Summary(argument: obj),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
            break;

          default:
            return null;
        }
      },
      home: Scaffold(
        body: homeOrLog(),
      ),
    );

  }

  Widget homeOrLog() {
   return FutureBuilder(
      future: facebookAppEvents.getAnonymousId(),
      builder: (context, snapshot) {
        final id = snapshot.data ?? '???';
        print('Anonymous ID: $id');
        return SplashScreen();
      },
    );

  }
}

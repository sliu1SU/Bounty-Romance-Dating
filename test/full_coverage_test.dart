
import 'package:bounty_romance/common/data.dart';
import 'package:bounty_romance/common/firebase_options.dart';
import 'package:bounty_romance/common/router.dart';
import 'package:bounty_romance/common/nav_notifier.dart';
import 'package:bounty_romance/widget_profile.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:bounty_romance/common/db.dart';
import 'package:bounty_romance/main.dart';
import 'package:bounty_romance/all_profiles_page.dart';
import 'package:bounty_romance/login_page.dart';
import 'package:bounty_romance/registration_page.dart';
import 'package:bounty_romance/upload_image_page.dart';
import 'package:bounty_romance/home_nav_bar.dart';
import 'package:bounty_romance/user_profile_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'full_coverage_test.mocks.dart';

// Mock Firebase
@GenerateMocks([FireStoreService])

void main() {
  // Create a mock FirebaseAuth instance
  final FireStoreService mockFireStoreService = MockFireStoreService();

  testWidgets('login page: tap clear icon', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: LoginPage(),
    ));
    expect(find.byType(LoginPage), findsOneWidget);

    // test email filed: tap clear icon
    await tester.enterText(find.byKey(const Key('email')), 'Hello');
    expect(find.text('Hello'), findsOneWidget);
    await tester.tap(find.descendant(
      of: find.byKey(const Key('email')),
      matching: find.byIcon(Icons.clear),
    ));
    await tester.pump();
    expect(find.text('Hello'), findsNothing);

    // test email filed: tap clear icon
    await tester.enterText(find.byKey(const Key('password')), 'Hello');
    expect(find.text('Hello'), findsOneWidget);
    await tester.tap(find.descendant(
      of: find.byKey(const Key('password')),
      matching: find.byIcon(Icons.clear),
    ));
    await tester.pump();
    expect(find.text('Hello'), findsNothing);
  });

  testWidgets('login page: form validation', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: LoginPage(),
    ));
    expect(find.byType(LoginPage), findsOneWidget);

    await tester.enterText(find.byKey(const Key('email')), 'Hello');
    await tester.enterText(find.byKey(const Key('password')), '123a');

    expect(find.text('Please enter a valid email'), findsNothing);
    expect(find.text('Password should be at least 6 characters'), findsNothing);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password should be at least 6 characters'), findsOneWidget);
  });

  testWidgets('login page: click signup', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));
    expect(find.byType(LoginPage), findsOneWidget);

    expect(find.byType(RegistrationPage), findsNothing);
    Finder signup = find.text('Sign up');
    expect(signup, findsOneWidget);

    await tester.tap(signup);
    await tester.pumpAndSettle();
    expect(find.byType(RegistrationPage), findsOneWidget);
  });

  testWidgets('registration page: tap clear icon', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: RegistrationPage(),
    ));
    expect(find.byType(RegistrationPage), findsOneWidget);

    // test nickname filed: tap clear icon
    await tester.enterText(find.byKey(const Key('nickname')), 'Hello');
    expect(find.text('Hello'), findsOneWidget);
    await tester.tap(find.descendant(
      of: find.byKey(const Key('nickname')),
      matching: find.byIcon(Icons.clear),
    ));
    await tester.pump();
    expect(find.text('Hello'), findsNothing);

    // test email filed: tap clear icon
    await tester.enterText(find.byKey(const Key('email')), 'Hello');
    expect(find.text('Hello'), findsOneWidget);
    await tester.tap(find.descendant(
      of: find.byKey(const Key('email')),
      matching: find.byIcon(Icons.clear),
    ));
    await tester.pump();
    expect(find.text('Hello'), findsNothing);

    // test email filed: tap clear icon
    await tester.enterText(find.byKey(const Key('password')), 'Hello');
    expect(find.text('Hello'), findsOneWidget);
    await tester.tap(find.descendant(
      of: find.byKey(const Key('password')),
      matching: find.byIcon(Icons.clear),
    ));
    await tester.pump();
    expect(find.text('Hello'), findsNothing);
  });

  testWidgets('upload image page', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: UploadImage(defaultImgUrl: '',)
    ));
    expect(find.byType(UploadImage), findsOneWidget);
  });

  test('Nav Notifier Test', () {
    NavNotifier navNotifier = NavNotifier();

    expect(navNotifier.currentIndex, 0);

    navNotifier.changeNavBar(1);

    expect(navNotifier.currentIndex, 1);

    bool listenerCalled = false;
    navNotifier.addListener(() {
      listenerCalled = true;
    });

    navNotifier.notifyListeners();

    expect(listenerCalled, isTrue);
  });

  test('UserInfoModel Test', () {
    // create a UserInfoModel instance
    UserInfoModel userInfo = UserInfoModel(
      id: '1',
      name: 'John',
      email: 'john@example.com',
      age: '30',
      intro: 'A brief intro',
      gender: 1,
      avatar: 'avatar_url',
      city: 'New York',
    );

    expect(userInfo.id, '1');
    expect(userInfo.name, 'John');
    expect(userInfo.email, 'john@example.com');
    expect(userInfo.age, '30');
    expect(userInfo.intro, 'A brief intro');
    expect(userInfo.gender, 1);
    expect(userInfo.avatar, 'avatar_url');
    expect(userInfo.city, 'New York');

    // test generateEmpty function
    UserInfoModel emptyUserInfo = UserInfoModel.generateEmpty();
    expect(emptyUserInfo.id, '');
    expect(emptyUserInfo.name, '');
    expect(emptyUserInfo.email, '');
    expect(emptyUserInfo.age, '');
    expect(emptyUserInfo.intro, '');
    expect(emptyUserInfo.gender, 0);
    expect(emptyUserInfo.avatar, '');
    expect(emptyUserInfo.city, '-');

    // test toMap function
    Map<String, dynamic> userInfoMap = userInfo.toMap();
    expect(userInfoMap['id'], '1');
    expect(userInfoMap['name'], 'John');
    expect(userInfoMap['email'], 'john@example.com');
    expect(userInfoMap['age'], '30');
    expect(userInfoMap['intro'], 'A brief intro');
    expect(userInfoMap['gender'], 1);
    expect(userInfoMap['avatar'], 'avatar_url');
    expect(userInfoMap['city'], 'New York');
  });

  // test all profile page widget
  testWidgets('AllProfilePage: no user Test', (WidgetTester tester) async {
    when(mockFireStoreService.getUsers()).thenAnswer((_) async => Future.value([]));
    when(mockFireStoreService.getCurrentUid()).thenAnswer((_) => "0");
    // Build the widget
    // await tester.pumpWidget(
    //   Provider.value<FireStoreService>(
    //     value: mockFireStoreService,
    //     child: const MaterialApp(home: AllProfilesPage(),),
    //   )
    // );

    await tester.pumpWidget(
        MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => NavNotifier(),
              ),
              Provider(create: (context) => mockFireStoreService),
            ],
            child: const MaterialApp(home: AllProfilesPage()),
        )
    );

    await tester.pumpAndSettle();
    // validate
    expect(find.text('No user found!'), findsOneWidget);
    expect(find.byType(AllProfilesPage), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(find.byType(PageView), findsNothing);
  });

  // test all profile page widget - has users
  testWidgets('AllProfilePage: one user Test', (WidgetTester tester) async {
    UserInfoModel user = UserInfoModel(
        id: '0',
        name: 'Kimmy',
        email: 'test1@gmail.com',
        age: '29',
        intro: 'love me',
        gender: 0,
        avatar: '',
        city: ''
    );
    when(mockFireStoreService.getUsers()).thenAnswer((_) async => Future.value([user]));
    when(mockFireStoreService.getCurrentUid()).thenAnswer((_) => "0");

    await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => NavNotifier(),
            ),
            Provider(create: (context) => mockFireStoreService),
          ],
          child: const MaterialApp(home: AllProfilesPage()),
        )
    );
    await tester.pumpAndSettle();

    // validate
    expect(find.text('Kimmy'), findsOneWidget);
    expect(find.text('29'), findsOneWidget);
    expect(find.byType(AllProfilesPage), findsOneWidget);
    expect(find.byType(PageView), findsNothing);
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);


    // // tap the profile
    await tester.tap(find.byType(Card));
    await tester.pumpAndSettle();
    expect(find.byType(UserProfilePage), findsOneWidget);
    expect(find.byType(UserProfile), findsOneWidget);
  });
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:twitterapp/services/userauth.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.fromIterable([
      _mockUser,
    ]);
  }
}

void main() {
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  final UserAuth auth = UserAuth(auth: mockFirebaseAuth);
  setUp(() {});
  tearDown(() {});

  test("emit occurs", () async {
    expectLater(auth.user, emitsInOrder([_mockUser]));
  });

  test("create account", () async {
    when(
      mockFirebaseAuth.createUserWithEmailAndPassword(
          email: "2@gmail.com", password: "111111"),
    ).thenAnswer((realInvocation) => null);

    expect(await auth.createNewUser(email: "2@gmail.com", password: "111111"),
        "Success");
  });

  test("create account exception", () async {
    when(
      mockFirebaseAuth.createUserWithEmailAndPassword(
          email: "2@gmail.com", password: "111111"),
    ).thenAnswer((realInvocation) => throw FirebaseAuthException(
        message: "You screwed up", code: 'create user did not work'));

    expect(await auth.createNewUser(email: "2@gmail.com", password: "111111"),
        "create user did not work");
  });

  test("sign in", () async {
    when(
      mockFirebaseAuth.signInWithEmailAndPassword(
          email: "2@gmail.com", password: "111111"),
    ).thenAnswer((realInvocation) => null);

    expect(await auth.signIn(email: "2", password: "111111"), "Success");
  });

  test("sign in exception", () async {
    when(
      mockFirebaseAuth.signInWithEmailAndPassword(
          email: "2@gmail.com", password: "111111"),
    ).thenAnswer((realInvocation) => throw FirebaseAuthException(
        message: "You screwed up", code: 'sign in did not work'));

    expect(await auth.signIn(email: "2@gmail.com", password: "111111"),
        "sign in did not work");
  });

  test("sign out", () async {
    when(
      mockFirebaseAuth.signOut(),
    ).thenAnswer((realInvocation) => null);

    expect(await auth.signOut(), "Success");
  });

  test("create account exception", () async {
    when(
      mockFirebaseAuth.signOut(),
    ).thenAnswer((realInvocation) => throw FirebaseAuthException(
        message: "You screwed up", code: 'sign out did not work'));

    expect(await auth.signOut(), "sign out did not work");
  });
}

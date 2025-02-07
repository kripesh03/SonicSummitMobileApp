import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_summit_mobile_app/features/auth/domain/entity/auth_entity.dart';

void main() {
  const auth1 = AuthEntity(
    userId: "1234567890",
    email: "John",
    bio: "Doe",
    profilePicture: "https://example.com/johndoe.jpg",
    username: "johndoe",
    password: "john1234",
  );

  const auth2 = AuthEntity(
    userId: "1234567890",
    email: "John",
    bio: "Doe",
    profilePicture: "https://example.com/johndoe.jpg",
    username: "johndoe",
    password: "john1234",
  );

  test('Test: Two AuthEntity objects with the same values should be equal', () {
    expect(auth1, auth2);
  });
}

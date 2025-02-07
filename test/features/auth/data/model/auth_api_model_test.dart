import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_summit_mobile_app/features/auth/data/model/auth_api_model.dart';
import 'package:sonic_summit_mobile_app/features/auth/domain/entity/auth_entity.dart';

void main() {
  group('AuthApiModel Tests', () {
    final json = {
      '_id': '123',
      'username': 'falano',
      'email': 'Doe@gmail.com',
      'profilePicture': 'profile.jpg',
      'bio': 'hello',
      'password': 'password123',
    };

    test('should convert from JSON correctly', () {
      final model = AuthApiModel.fromJson(json);

      expect(model.id, '123');
      expect(model.username, 'falano');
      expect(model.email, 'Doe@gmail.com');
      expect(model.profilePicture, 'profile.jpg');
      expect(model.bio, 'hello');
      expect(model.password, 'password123');
    });

    test('should convert to JSON correctly', () {
      final model = AuthApiModel.fromJson(json);
      final convertedJson = model.toJson();

      expect(convertedJson['_id'], '123');
      expect(convertedJson['email'], 'Doe@gmail.com');
      expect(convertedJson['profilePicture'], 'profile.jpg');
      expect(convertedJson['bio'], 'hello');
      expect(convertedJson['username'], 'falano');
      expect(convertedJson['password'], 'password123');
    });

    test('should convert between Entity and Model correctly', () {
      const entity = AuthEntity(
        userId: '123',
        email: 'Doe@gmail.com',
        bio: 'hello',
        profilePicture: 'profile.jpg',
        username: 'falano',
        password: 'password123',
      );

      final model = AuthApiModel.fromEntity(entity);
      final convertedEntity = model.toEntity();

      expect(convertedEntity, equals(entity));
    });
  });
}

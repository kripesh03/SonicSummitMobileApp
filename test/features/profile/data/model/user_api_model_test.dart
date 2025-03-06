import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_summit_mobile_app/features/profile/data/model/user_api_model.dart';
import 'package:sonic_summit_mobile_app/features/profile/domain/entity/user_entity.dart';

void main() {
  group('UserApiModel Tests', () {
    final json = {
      '_id': '123',
      'username': 'john_doe',
      'email': 'john.doe@example.com',
      'bio': 'Developer at Sonic Summit',
      'profilePicture': 'http://example.com/profile.jpg',
    };

    test('should convert from JSON correctly', () {
      final model = UserApiModel.fromJson(json);

      expect(model.id, '123');
      expect(model.username, 'john_doe');
      expect(model.email, 'john.doe@example.com');
      expect(model.bio, 'Developer at Sonic Summit');
      expect(model.profilePicture, 'http://example.com/profile.jpg');
    });

    test('should convert to JSON correctly', () {
      final model = UserApiModel.fromJson(json);
      final convertedJson = model.toJson();

      expect(convertedJson['_id'], '123');
      expect(convertedJson['username'], 'john_doe');
      expect(convertedJson['email'], 'john.doe@example.com');
      expect(convertedJson['bio'], 'Developer at Sonic Summit');
      expect(convertedJson['profilePicture'], 'http://example.com/profile.jpg');
    });

    
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_summit_mobile_app/features/profile/data/model/user_api_model.dart';
import 'package:sonic_summit_mobile_app/features/profile/data/dto/get_user_dto.dart';
import 'package:sonic_summit_mobile_app/features/profile/domain/entity/user_entity.dart';

void main() {
  group('GetUserDTO Tests', () {
    final Map<String, dynamic> json = {
      'user': {
        '_id': '123',
        'username': 'JohnDoe',
        'email': 'johndoe@example.com',
        'bio': 'This is the user bio.',
        'profilePicture': 'https://example.com/profile.jpg',
      },
    };


    test('should correctly serialize to JSON', () {
      final user = UserApiModel(
        id: '123',
        username: 'JohnDoe',
        email: 'johndoe@example.com',
        bio: 'This is the user bio.',
        profilePicture: 'https://example.com/profile.jpg',
      );
      final getUserDTO = GetUserDTO(user: user);
      final serializedJson = getUserDTO.toJson();

      // Validate that the serialized JSON matches the expected format
      expect(serializedJson['user']['_id'], '123');
      expect(serializedJson['user']['username'], 'JohnDoe');
      expect(serializedJson['user']['email'], 'johndoe@example.com');
      expect(serializedJson['user']['bio'], 'This is the user bio.');
      expect(serializedJson['user']['profilePicture'], 'https://example.com/profile.jpg');
    });

    test('should convert UserApiModel to UserEntity correctly', () {
      final userApiModel = UserApiModel(
        id: '123',
        username: 'JohnDoe',
        email: 'johndoe@example.com',
        bio: 'This is the user bio.',
        profilePicture: 'https://example.com/profile.jpg',
      );
      final userEntity = userApiModel.toEntity();

      // Validate that the UserApiModel is correctly converted to UserEntity
      expect(userEntity.id, '123');
      expect(userEntity.username, 'JohnDoe');
      expect(userEntity.email, 'johndoe@example.com');
      expect(userEntity.bio, 'This is the user bio.');
      expect(userEntity.profilePicture, 'https://example.com/profile.jpg');
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_summit_mobile_app/app/di/di.dart';
import 'package:sonic_summit_mobile_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:sonic_summit_mobile_app/features/profile/presentation/view_model/profile_bloc.dart';
import 'package:sonic_summit_mobile_app/features/profile/presentation/view_model/profile_state.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger the event to load the user profile after fetching the userId
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Fetch userId from SharedPreferences
      final tokenSharedPrefs = getIt<TokenSharedPrefs>();
      final result = await tokenSharedPrefs.getUserId();

      result.fold(
        (failure) {
          // Handle failure (e.g., show an error message)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to load userId: ${failure.message}')),
          );
        },
        (userId) {
          if (userId.isNotEmpty) {
            // If userId is retrieved successfully, trigger the event to load the profile
            BlocProvider.of<ProfileBloc>(context)
                .add(LoadProfile(userId: userId));
          } else {
            // Handle case where userId is not found
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No userId found')),
            );
          }
        },
      );
    });

    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Your Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  debugPrint('Profile state: $state'); // Debug log
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.error.isNotEmpty) {
                    return Center(child: Text('Error: ${state.error}'));
                  } else if (state.user == null) {
                    return const Center(child: Text('No Profile Found'));
                  } else {
                    final user = state.user!;
                    final profileImageUrl = user.profilePicture != null &&
                            user.profilePicture!.isNotEmpty
                        ? 'http://10.0.2.2:3000/images/${user.profilePicture}'
                        : null;

                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: profileImageUrl != null
                              ? NetworkImage(profileImageUrl)
                              : null,
                          child: profileImageUrl == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.username ?? 'Username not available',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Email: ${user.email ?? 'Email not available'}'),
                        const SizedBox(height: 8),
                        Text('Bio: ${user.bio ?? 'Bio not available'}'),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: const Text('My Orders'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

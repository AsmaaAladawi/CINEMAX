import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/di/injection.dart';
import 'package:flutter_application_1/features/onboarding/pages/onboarding_page.dart';
import 'package:flutter_application_1/features/privacy_policy/privacy_policy_page.dart';
import 'package:flutter_application_1/features/profile/data/model/profile_model.dart';
import 'package:flutter_application_1/features/profile/ui/widget/logout_dialog.dart';
import 'package:flutter_application_1/features/profile/ui/widget/profile_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/navigation/bottom_nav_handler.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';
import 'package:flutter_application_1/core/widgets/app_bottom_nav.dart';
import 'package:flutter_application_1/features/profile/logic/profile_cubit.dart';
import 'package:flutter_application_1/features/profile/logic/profile_state.dart';
import 'package:flutter_application_1/features/edit_profile/ui/edit_profile_page.dart';
import 'package:flutter_application_1/features/notifications/ui/notifications_page.dart';
import 'package:flutter_application_1/features/language/ui/language_page.dart';
import 'package:flutter_application_1/features/country/ui/country_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static Route route() => MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<ProfileCubit>()..load(),
          child: const ProfilePage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: AppBottomNav(
        currentIndex: 3,
        onTap: (i) => handleBottomNav(context, current: 3, index: i),
      ),
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) => switch (state) {
            ProfileLoading() => const Center(
                child: CircularProgressIndicator(color: AppColors.accent)),
            ProfileError(:final message) => Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () => context.read<ProfileCubit>().load(),
                    child: const Text('Retry'),
                  ),
                ]),
              ),
            ProfileSuccess() => _Content(profile: state.profile),
          },
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final ProfileModel profile;
  const _Content({required this.profile});

  void _soon(BuildContext context) => ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('Coming soon')));

  Future<void> _openEdit(BuildContext context) async {
    final changed = await Navigator.push<bool>(context, EditProfilePage.route(profile));
    if (changed == true && context.mounted) context.read<ProfileCubit>().load();
  }

  Future<void> _clearCache(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();
    final messenger = ScaffoldMessenger.of(context);
    await cubit.clearCache();
    messenger.showSnackBar(const SnackBar(content: Text('Cache cleared')));
  }

  Future<void> _logout(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();
    final nav = Navigator.of(context);
    if (!await showLogoutDialog(context)) return;
    await cubit.logout();
    nav.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const OnboardingPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Center(
            child: Text('Profile',
                style: TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: profile.avatarUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    if (profile.email.isNotEmpty)
                      Text(profile.email,
                          style: const TextStyle(color: AppColors.grey, fontSize: 12)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _openEdit(context),
                icon: const Icon(Icons.edit_square, color: AppColors.accent, size: 20),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Premium Member',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: 2),
                      Text('New movies are coming for you,\nDownload Now!',
                          style: TextStyle(color: Colors.white, fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ProfileSection(title: 'Account', children: [
          ProfileTile(
              icon: Icons.person_outline_rounded,
              title: 'Member',
              onTap: () => _openEdit(context)),
          ProfileTile(
              icon: Icons.lock_outline_rounded,
              title: 'Change Password',
              onTap: () => _soon(context)),
        ]),
        ProfileSection(title: 'General', children: [
          ProfileTile(
              icon: Icons.notifications_none_rounded,
              title: 'Notification',
              onTap: () => Navigator.push(context, NotificationsPage.route())),
          ProfileTile(
              icon: Icons.language_rounded,
              title: 'Language',
              onTap: () => Navigator.push(context, LanguagePage.route())),
          ProfileTile(
              icon: Icons.public_rounded,
              title: 'Country',
              onTap: () => Navigator.push(context, CountryPage.route())),
          ProfileTile(
              icon: Icons.delete_outline_rounded,
              title: 'Clear Cache',
              onTap: () => _clearCache(context)),
        ]),
        ProfileSection(title: 'More', children: [
          ProfileTile(
              icon: Icons.shield_outlined,
              title: 'Legal and Policies',
              onTap: () => Navigator.push(context, PrivacyPolicyPage.route())),
          ProfileTile(
              icon: Icons.help_outline_rounded,
              title: 'Help & Feedback',
              onTap: () => _soon(context)),
          ProfileTile(
              icon: Icons.info_outline_rounded,
              title: 'About Us',
              onTap: () => _soon(context)),
        ]),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: OutlinedButton(
            onPressed: () => _logout(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accent,
              side: const BorderSide(color: AppColors.accent),
              shape: const StadiumBorder(),
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('Log Out'),
          ),
        ),
      ],
    );
  }
}
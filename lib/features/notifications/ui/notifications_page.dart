import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/di/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';
import 'package:flutter_application_1/core/widgets/page_header.dart';
import 'package:flutter_application_1/features/notifications/logic/notifications_cubit.dart';
import 'package:flutter_application_1/features/notifications/logic/notifications_state.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static Route route() => MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<NotificationsCubit>()..load(),
          child: const NotificationsPage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Notification'),
            Expanded(
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                        child: CircularProgressIndicator(color: AppColors.accent));
                  }
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Message Notifications',
                            style: TextStyle(color: AppColors.grey, fontSize: 10)),
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Show Notifications',
                                style: TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                          Switch(
                            value: state.enabled,
                            activeColor: AppColors.accent,
                            onChanged: (v) =>
                                context.read<NotificationsCubit>().toggle(v),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white12),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Exceptions',
                            style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
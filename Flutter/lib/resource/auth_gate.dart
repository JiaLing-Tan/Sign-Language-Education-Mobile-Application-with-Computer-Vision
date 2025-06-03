import 'package:fingo/layout/layout.dart';
import 'package:fingo/provider/user_provider.dart';
import 'package:fingo/resource/CRUD/student_controller.dart';
import 'package:fingo/screen/home_screen.dart';
import 'package:fingo/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../provider/class_provider.dart';
import 'auth_method.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          final session = snapshot.hasData ? snapshot.data!.session : null;
          if (session != null) {

            return BottomLayout();
          } else {
            return LoginScreen();
          }
        });
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';

class Authentication {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmailPassword(String email,
      String password) async {
    return await _supabase.auth.signInWithPassword(
        email: email, password: password);
  }

  Future<String?> signUpWithEmailPassword(String email,
      String password) async {
    final AuthResponse response = await _supabase.auth.signUp(
        password: password,
        email: email,
        data: {'signup_complete': false}
    );

    final String? userId = response.user?.id;

    if (userId != null) {
      await _supabase.auth.signOut();
    }

    return userId;
  }

  Future<AuthResponse?> completeSignUp(String email, String password) async {
    return await signInWithEmailPassword(email, password);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  String? getCurrentUserEmail(){
    final session = _supabase.auth.currentSession;
    final user = session?.user;

    return user?.email;
  }

  String? getCurrentUserId(){
    final session = _supabase.auth.currentSession;
    final user = session?.user;

    return user?.id;
  }

}
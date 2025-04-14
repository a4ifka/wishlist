import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/feature/data/models/user_model.dart';
import 'package:wishlist/main.dart';

abstract class UserRemoteDataSources {
  Future<AuthResponse> signInUser(String email, String password);
  Future<AuthResponse> signUpUser(String email, String password);
  Future<UserModel> getUserInfo(String uuid);
  Future<void> updateUserInfo(String name);
  Future<void> createUser(UserModel userModel);
  Future<void> signOutUser();
}

class UserRemoteDataSourcesImpl extends UserRemoteDataSources {
  final SupabaseClient supabaseClient;

  UserRemoteDataSourcesImpl({required this.supabaseClient});

  @override
  Future<AuthResponse> signInUser(String email, String password) async {
    return await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<AuthResponse> signUpUser(String email, String password) async {
    return await supabaseClient.auth.signUp(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOutUser() async {
    return await supabaseClient.auth.signOut();
  }

  @override
  Future<UserModel> getUserInfo(String uuid) async {
    final response = await supabaseClient
        .from('users_info')
        .select()
        .eq('uuid', Supabase.instance.client.auth.currentUser!.id)
        .single();
    return UserModel.fromJson(response);
  }

  @override
  Future<void> createUser(UserModel userModel) async {
    await supabaseClient.from('users_info').insert({
      'uuid': userModel.uuid,
      'name': userModel.name,
    }).select();
  }

  @override
  Future<void> updateUserInfo(String name) async {
    final List<Map<String, dynamic>> data = await supabaseClient
        .from("users_info")
        .update({
          'name': name,
        })
        .eq('uuid', supabase.auth.currentUser!.id)
        .select();
    print('data --> $data');
    return;
  }
}

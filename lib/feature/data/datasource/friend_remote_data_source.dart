import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/feature/data/models/friend_model.dart';
import 'package:wishlist/feature/data/models/room_model.dart';
import 'package:wishlist/feature/data/models/user_model.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';

abstract class FriendRemoteDataSource {
  Future<List<UserModel>> searchUsers(String query);
  Future<String> sendFriendRequest(String senderId, String receiverId);
  Future<List<FriendModel>> getFriendRequests(String userId);
  Future<void> respondToFriendRequest(String requestId, bool accept);
  Future<List<UserModel>> getFriends(String userId);
  Future<void> removeFriend(String userId, String friendId);
  Future<List<UserModel>> loadFriends(String userId);
  Future<List<RoomModel>> getRoomsFriend(String uuid);
}

class FriendRemoteDataSourceImpl extends FriendRemoteDataSource {
  final SupabaseClient supabaseClient;

  FriendRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<FriendModel>> getFriendRequests(String userId) async {
    final response = await supabaseClient
        .from('friend_requset')
        .select()
        .or('sender_id.eq.$userId,receiver_id.eq.$userId');

    return response.map((friends) => FriendModel.fromJson(friends)).toList();
  }

  @override
  Future<List<UserModel>> getFriends(String userId) async {
    // Получаем все принятые запросы, где пользователь участвует
    final response = await supabaseClient
        .from('friend_requset')
        .select()
        .eq('status', 'accepted')
        .or('sender_id.eq.$userId,receiver_id.eq.$userId');

    // Собираем ID всех друзей
    final requests = response as List;
    final friendIds = requests
        .map(
            (e) => e['sender_id'] == userId ? e['receiver_id'] : e['sender_id'])
        .toSet()
        .toList();

    // Получаем информацию о друзьях
    final friendsResponse = await supabaseClient
        .from('users_info')
        .select()
        .inFilter('user_id', friendIds);

    return friendsResponse
        .map((request) => UserModel.fromJson(request))
        .toList();
  }

  @override
  Future<void> respondToFriendRequest(String requestId, bool accept) async {
    if (!accept) {
      // Просто обновляем статус запроса, если отклоняем
      await supabaseClient
          .from('friend_requset')
          .update({'status': 'rejected'}).eq('id', requestId);
      return;
    }

    final requestResponse = await supabaseClient
        .from('friend_requset')
        .select()
        .eq('id', requestId)
        .single();

    final request = requestResponse;
    final senderId = request['sender_id'] as String;
    final receiverId = request['receiver_id'] as String;

    final senderInfo = await _getUserInfo(senderId);
    final receiverInfo = await _getUserInfo(receiverId);

    await _addFriendToUser(
      userId: senderId,
      friendUsername: receiverInfo.name,
      friendUuid: receiverId,
    );

    // Обновляем друзей у получателя
    await _addFriendToUser(
      userId: receiverId,
      friendUsername: senderInfo.name,
      friendUuid: senderId,
    );

    // Обновляем статус запроса
    await supabaseClient
        .from('friend_requset')
        .update({'status': 'accepted'}).eq('id', requestId);
    // await supabaseClient
    //     .from('friend_requset')
    //     .update({'status': accept ? 'accepted' : 'rejected'})
    //     .eq('id', requestId)
    //     .select();
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    final response =
        await supabaseClient.from('users_info').select().eq('name', query);

    return response.map((users) => UserModel.fromJson(users)).toList();
  }

  @override
  Future<String> sendFriendRequest(String senderId, String receiverId) async {
    final response = await supabaseClient.from('friend_requset').insert({
      'sender_id': senderId,
      'receiver_id': receiverId,
      'status': 'pending',
    }).select();
    return response.toString();
  }

  Future<void> _addFriendToUser({
    required String userId,
    required String friendUsername,
    required String friendUuid,
  }) async {
    // Получаем текущий список друзей
    final currentFriendsResponse = await supabaseClient
        .from('users_info')
        .select('friend')
        .eq('uuid', userId)
        .single();

    final currentFriendsData = currentFriendsResponse;
    List<dynamic> friendsList = currentFriendsData['friend'] ?? [];

    // Проверяем, нет ли уже такого друга
    final friendExists = friendsList.any((friend) =>
        friend['uuid'] == friendUuid && friend['name'] == friendUsername);

    if (!friendExists) {
      // Добавляем нового друга
      friendsList.add({
        'name': friendUsername,
        'uuid': friendUuid,
      });

      // Обновляем запись в базе данных
      final updateResponse = await supabaseClient
          .from('users_info')
          .update({'friend': friendsList}).eq('uuid', userId);

      if (updateResponse.error != null) {
        throw Exception(updateResponse.error!.message);
      }
    }
  }

  Future<UserEntity> _getUserInfo(String userId) async {
    final response = await supabaseClient
        .from('users_info')
        .select()
        .eq('uuid', userId)
        .single();

    return UserEntity(
      uuid: response['uuid'],
      name: response['name'],
      id: 0,
    );
  }

  @override
  Future<void> removeFriend(String userId, String friendId) async {
    // Получаем текущий список друзей пользователя
    final userResponse = await supabaseClient
        .from('users_info')
        .select('friend')
        .eq('uuid', userId)
        .single();

    final friends = (userResponse['friend'] as List)
        .where((friend) => friend['uuid'] != friendId)
        .toList();

    // Обновляем список друзей пользователя
    await supabaseClient
        .from('users_info')
        .update({'friend': friends}).eq('uuid', userId);

    // Также удаляем пользователя из списка друзей друга (если нужно)
    final friendResponse = await supabaseClient
        .from('users_info')
        .select('friends')
        .eq('user_id', friendId)
        .single();

    final friendFriends = (friendResponse['friend'] as List)
        .where((friend) => friend['uuid'] != userId)
        .toList();

    await supabaseClient
        .from('users_info')
        .update({'friend': friendFriends}).eq('uuid', friendId);
  }

  @override
  Future<List<UserModel>> loadFriends(String userId) async {
    final response = await supabaseClient
        .from('users_info')
        .select('friend')
        .eq('uuid', userId)
        .single();

    final friendsJson = response['friend'] as List<dynamic>? ?? [];

    if (friendsJson.isEmpty) return [];

    final friendIds =
        friendsJson.map<String>((friend) => friend['uuid'] as String).toList();

    final friendsInfoResponse = await supabaseClient
        .from('users_info')
        .select()
        .inFilter('uuid', friendIds);

    return (friendsInfoResponse as List)
        .map((e) => UserModel(
              uuid: e['uuid'],
              name: e['name'],
              id: e['id'],
            ))
        .toList();
  }

  @override
  Future<List<RoomModel>> getRoomsFriend(String uuid) async {
    final response =
        await supabaseClient.from('rooms').select().eq('owner', uuid);

    return response.map((room) => RoomModel.fromJson(room)).toList();
  }
}

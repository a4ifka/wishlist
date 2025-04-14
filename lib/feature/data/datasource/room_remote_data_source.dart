import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/feature/data/models/room_model.dart';

abstract class RoomRemoteDataSource {
  Future<List<RoomModel>> getRoomsByUser();
  Future<RoomModel> getRoomById(String roomId);
  Future<List<Map<String, dynamic>>> createRoom(RoomModel room);
  Future<void> updateRoom(RoomModel room);
  Future<void> deleteRoom(String roomId);
  RealtimeChannel listenToUserOrdersChanges(
      String channel, void Function() callback);
}

class RoomRemoteDataSourceImpl implements RoomRemoteDataSource {
  final SupabaseClient supabaseClient;

  RoomRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<RoomModel>> getRoomsByUser() async {
    final response = await supabaseClient
        .from('rooms')
        .select()
        .eq('owner', supabaseClient.auth.currentUser!.id);

    return response.map((room) => RoomModel.fromJson(room)).toList();
  }

  @override
  Future<RoomModel> getRoomById(String roomId) async {
    final response =
        await supabaseClient.from('rooms').select().eq('id', roomId).single();

    return RoomModel.fromJson(response);
  }

  @override
  Future<List<Map<String, dynamic>>> createRoom(RoomModel room) async {
    List<Map<String, dynamic>> data =
        await supabaseClient.from('rooms').insert({
      'name': room.name,
      'is_public': room.isPublic,
    }).select();
    return data;
  }

  @override
  Future<void> updateRoom(RoomModel room) async {
    await supabaseClient.from('rooms').update(room.toJson()).eq('id', room.id);
  }

  @override
  Future<void> deleteRoom(String roomId) async {
    await supabaseClient.from('rooms').delete().eq('id', roomId);
  }

  @override
  RealtimeChannel listenToUserOrdersChanges(
      String channel, void Function() callback) {
    var listen = supabaseClient
        .channel('public:$channel')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: channel,
            callback: (payload) => callback)
        .subscribe();
    print('listen --> $listen');
    return listen;
  }
}

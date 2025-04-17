import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/feature/data/models/wish_model.dart';
import 'package:wishlist/main.dart';

abstract class WishRemoteDataSource {
  Future<List<WishModel>> getWishesByRoom(int roomId);
  Future<WishModel> getWishById(String wishId);
  Future<List<Map<String, dynamic>>> createWish(WishModel wish);
  Future<void> updateWish(WishModel wish);
  Future<void> deleteWish(String wishId);
  Future<void> fulfillWish(int wishId, String userId);
  Future<int> getMyBooking();
  Future<int> getCompleted();
  RealtimeChannel listenToUserOrdersChanges(
      String channel, void Function() callback);
}

class WishRemoteDataSourceImpl implements WishRemoteDataSource {
  final SupabaseClient supabaseClient;

  WishRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<WishModel>> getWishesByRoom(int roomId) async {
    final response =
        await supabaseClient.from('wishes').select().eq('room_id', roomId);

    return response.map((medicines) => WishModel.fromJson(medicines)).toList();
  }

  @override
  Future<WishModel> getWishById(String wishId) async {
    final response =
        await supabaseClient.from('wishes').select().eq('id', wishId).single();

    return WishModel.fromJson(response);
  }

  @override
  Future<List<Map<String, dynamic>>> createWish(WishModel wish) async {
    List<Map<String, dynamic>> data =
        await supabaseClient.from('wishes').insert({
      'name': wish.name,
      'room_id': wish.roomId,
      'url': wish.url,
      'url2': wish.url2,
      'url3': wish.url3,
      'price': wish.price,
      'image_url': wish.imageUrl,
      'is_fulfilled': wish.isFulfilled,
      'fulfilled_by': wish.fulfilledBy,
    }).select();
    return data;
  }

  @override
  Future<void> updateWish(WishModel wish) async {
    await supabaseClient.from('wishes').update(wish.toJson()).eq('id', wish.id);
  }

  @override
  Future<void> deleteWish(String wishId) async {
    await supabaseClient.from('wishes').delete().eq('id', wishId);
  }

  @override
  Future<void> fulfillWish(int wishId, String userId) async {
    await supabaseClient.from('wishes').update({
      'is_fulfilled': true,
      'fulfilled_by': userId,
    }).eq('id', wishId);
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

  @override
  Future<int> getCompleted() async {
    final myRooms = await supabaseClient
        .from('rooms')
        .select('id')
        .eq('owner', supabase.auth.currentUser!.id);
    final roomIds = myRooms.map((room) => room['id'] as int).toList();
    final response = await supabaseClient
        .from('wishes')
        .select()
        .inFilter('room_id', roomIds)
        .eq('is_fulfilled', true);
    print('23495834905349058          ${response.length}');
    return response.length;
  }

  @override
  Future<int> getMyBooking() async {
    final response = await supabaseClient
        .from('wishes')
        .select()
        .eq('fulfilled_by', supabase.auth.currentUser!.id);

    return response.length;
  }
}

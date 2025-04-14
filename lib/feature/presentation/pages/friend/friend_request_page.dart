import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/feature/domain/entities/friend_entity.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_state.dart';
import 'package:wishlist/feature/presentation/widgets/request_list_item.dart';
import 'package:wishlist/feature/presentation/widgets/segment_request.dart';
import 'package:wishlist/main.dart';

class FriendRequestPage extends StatefulWidget {
  const FriendRequestPage({super.key});

  @override
  State<FriendRequestPage> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  int? groupValue = 0;
  @override
  Widget build(BuildContext context) {
    final currentUserId = supabase.auth.currentUser?.id ?? '';
    context.read<FriendCubit>().fetchFriendRequests(currentUserId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Запросы'),
      ),
      body: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CupertinoSlidingSegmentedControl<int>(
                groupValue: groupValue,
                thumbColor: const Color(0xFF78C4A4),
                backgroundColor: Colors.white,
                children: {0: buildSegment('Входящие'), 1: buildSegment('Мои')},
                onValueChanged: (groupValue) {
                  setState(() => this.groupValue = groupValue);
                }),
          ]),
          Expanded(
            child: BlocBuilder<FriendCubit, FriendState>(
              builder: (context, state) {
                if (state is FriendRequestsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FriendError) {
                  return Center(child: Text(state.message));
                } else if (state is FriendRequestsLoaded) {
                  final currentUserId = supabase.auth.currentUser?.id ?? '';
                  if (groupValue == 0) {
                    List<FriendEntity> filteredList = state.requests
                        .where((friend) =>
                            friend.receiverId != null &&
                            friend.receiverId == currentUserId &&
                            friend.status == 'pending')
                        .toList();
                    return ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (ctx, index) => RequestListItem(
                              text: filteredList[index].senderId,
                              onAccept: () {
                                context
                                    .read<FriendCubit>()
                                    .setRespondToFriendRequest(
                                        filteredList[index].id.toString(), true)
                                    .then((_) => context
                                        .read<FriendCubit>()
                                        .fetchFriends(currentUserId));
                              },
                              onCancel: () {
                                context
                                    .read<FriendCubit>()
                                    .setRespondToFriendRequest(
                                        filteredList[index].id.toString(),
                                        false)
                                    .then((_) => context
                                        .read<FriendCubit>()
                                        .fetchFriends(currentUserId));
                              },
                            ));
                  }
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// BlocBuilder<FriendCubit, FriendState>(
//               builder: (context, state) {
//                 if (state is FriendRequestsLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (state is FriendError) {
//                   return Center(child: Text(state.message));
//                 } else if (state is FriendRequestsLoaded) {
//                   final requests = state.requests
//                       .where((r) =>
//                           r.receiverId == currentUserId &&
//                           r.status == 'pending')
//                       .toList();

//                   if (requests.isEmpty) {
//                     return Center(child: Text('No pending requests'));
//                   }
//                   return ListView.builder(
//                     itemCount: requests.length,
//                     itemBuilder: (context, index) {
//                       final request = requests[index];
//                       return FutureBuilder<UserEntity>(
//                         future: _getUserInfo(request.senderId),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return ListTile(
//                               title: Text('Loading...'),
//                             );
//                           }
//                           if (snapshot.hasError || !snapshot.hasData) {
//                             return ListTile(
//                               title: Text('Error loading user'),
//                             );
//                           }
//                           final user = snapshot.data!;
//                           return ListTile(
//                             title: Text(user.name),
//                             subtitle: const Text('Sent'),
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(Icons.check, color: Colors.green),
//                                   onPressed: () {
//                                     context
//                                         .read<FriendCubit>()
//                                         .setRespondToFriendRequest(
//                                             request.receiverId, true)
//                                         .then((_) => context
//                                             .read<FriendCubit>()
//                                             .fetchFriendRequests(
//                                                 currentUserId));
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.close, color: Colors.red),
//                                   onPressed: () {
//                                     context
//                                         .read<FriendCubit>()
//                                         .setRespondToFriendRequest(
//                                             request.senderId, false)
//                                         .then((_) => context
//                                             .read<FriendCubit>()
//                                             .fetchFriendRequests(
//                                                 currentUserId));
//                                   },
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   );
//                 }
//               },
//             ),

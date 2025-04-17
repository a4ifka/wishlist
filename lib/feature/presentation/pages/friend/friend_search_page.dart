import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_state.dart';
import 'package:wishlist/main.dart';

class FriendSearchPage extends StatelessWidget {
  FriendSearchPage({super.key});

  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск друзкй'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert),
            onPressed: () {
              Navigator.pushNamed(context, '/request-friend');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/list-friend');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by username',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    context
                        .read<FriendCubit>()
                        .searchUsers(_searchController.text);
                  },
                ),
              ),
              onSubmitted: (value) {
                context.read<FriendCubit>().searchUsers(value);
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<FriendCubit, FriendState>(
              builder: (context, state) {
                if (state is FriendSearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FriendError) {
                  return Center(child: Text(state.message));
                } else if (state is FriendSearchSuccess) {
                  return ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      return ListTile(
                        title: Text(user.name),
                        trailing: IconButton(
                          onPressed: () {
                            final currentUserId = supabase.auth.currentUser?.id;
                            if (currentUserId != null) {
                              context.read<FriendCubit>().sentFriendRequest(
                                    currentUserId,
                                    user.uuid,
                                  );
                            }
                          },
                          icon: Icon(Icons.person_add),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('нету'));
                }
              },
            ),
          ),
          BlocListener<FriendCubit, FriendState>(
            listener: (context, state) {
              if (state is FriendActionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Запрос отправлен')),
                );
              } else if (state is FriendError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: const SizedBox(),
          ),
        ],
      ),
    );
  }
}

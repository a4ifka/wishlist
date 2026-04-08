import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/feature/presentation/cubit/wish_cubit/wish_cubit.dart';
import 'package:wishlist/feature/presentation/widgets/book_wish_list_item.dart';
import 'package:wishlist/l10n/app_localizations.dart';
import 'package:wishlist/main.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({super.key});

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  static const _purple = Color(0xFF6D57FC);

  bool _initialized = false;
  Map<String, dynamic>? _room;
  bool _loading = true;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final roomId = ModalRoute.of(context)!.settings.arguments as int;
      _loadRoom(roomId);
    }
  }

  Future<void> _loadRoom(int roomId) async {
    try {
      final response = await supabase
          .from('rooms')
          .select()
          .eq('id', roomId)
          .single();
      if (!mounted) return;
      setState(() {
        _room = response;
        _loading = false;
      });
      context.read<WishCubit>().fetchWishesByRoom(roomId);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: _purple)),
      );
    }

    if (_error != null || _room == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.errorServer)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _room!['name'] as String,
          style: const TextStyle(
            color: _purple,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: _purple),
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<WishCubit, WishState>(
        builder: (context, state) {
          if (state is WishesLoaded) {
            if (state.wishes.isEmpty) {
              return Center(child: Text(l10n.noWishesYet));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: state.wishes.length,
              itemBuilder: (context, index) =>
                  BookWishListItem(product: state.wishes[index]),
            );
          }
          return Center(child: Text(l10n.loading));
        },
      ),
    );
  }
}

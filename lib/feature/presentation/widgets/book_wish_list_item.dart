import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/feature/domain/entities/wish_entity.dart';
import 'package:wishlist/feature/presentation/cubit/wish_cubit/wish_cubit.dart';
import 'package:wishlist/main.dart';

class BookWishListItem extends StatelessWidget {
  final WishEntity product;

  const BookWishListItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final isBooked = product.isFulfilled;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6D57FC).withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Фото ────────────────────────────────────────────────
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFF6F5F8),
                      child: const Center(
                        child: Icon(
                          Icons.card_giftcard_rounded,
                          size: 40,
                          color: Color(0xFFC7B5FA),
                        ),
                      ),
                    ),
                  ),
                  if (isBooked)
                    Container(
                      color: const Color(0xFF6D57FC).withValues(alpha: 0.72),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Забронировано',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // ── Инфо + кнопка ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Nunito',
                      color: Color(0xFF1A1A2E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${product.price.toStringAsFixed(0)} ₽',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito',
                      color: Color(0xFF6D57FC),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 34,
                    child: isBooked
                        ? Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F5F8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: Text(
                                'Занято',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Nunito',
                                  color: Color(0xFFC7B5FA),
                                ),
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              context.read<WishCubit>().markAsFulfilled(
                                    product.id,
                                    supabase.auth.currentUser!.id,
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6D57FC),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Забронировать',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

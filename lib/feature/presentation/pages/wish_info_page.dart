import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wishlist/feature/domain/entities/wish_entity.dart';

class WishInfoPage extends StatefulWidget {
  const WishInfoPage({super.key});

  @override
  State<WishInfoPage> createState() => _WishInfoPageState();
}

class _WishInfoPageState extends State<WishInfoPage> {
  static const _purple = Color.fromRGBO(109, 87, 252, 1);

  @override
  Widget build(BuildContext context) {
    final wish = ModalRoute.of(context)!.settings.arguments as WishEntity;

    final urls = [wish.url, wish.url2, wish.url3]
        .where((u) => u.isNotEmpty)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Шапка ──────────────────────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset('assets/back.svg'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        wish.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _purple,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Картинка ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: wish.imageUrl.isNotEmpty
                      ? Image.network(
                          wish.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                          errorBuilder: (_, __, ___) =>
                              _imagePlaceholder(hasError: true),
                        )
                      : _imagePlaceholder(),
                ),
              ),

              const SizedBox(height: 16),

              // ── Цена + декор ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 223, 135, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            '₽ ${wish.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(199, 181, 250, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Image.asset('assets/personpup.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Где купить ─────────────────────────────────────────
              if (urls.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Где можно приобрести',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...urls.map((url) => _UrlTile(name: wish.name, url: url)),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder({bool hasError = false}) {
    return Container(
      width: double.infinity,
      height: 220,
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(
          hasError ? Icons.broken_image_outlined : Icons.image_outlined,
          size: 56,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _UrlTile extends StatelessWidget {
  final String name;
  final String url;

  const _UrlTile({required this.name, required this.url});

  Future<void> _open() async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: InkWell(
        onTap: _open,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(247, 247, 249, 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Color.fromRGBO(115, 115, 155, 1),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      url,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Image.asset('assets/open.png', height: 24, width: 24),
            ],
          ),
        ),
      ),
    );
  }
}

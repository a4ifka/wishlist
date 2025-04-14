import 'package:flutter/material.dart';
import 'package:wishlist/feature/presentation/widgets/wb_parser.dart';

class ParserPage extends StatefulWidget {
  const ParserPage({super.key});

  @override
  State<ParserPage> createState() => _ParserPageState();
}

class _ParserPageState extends State<ParserPage> {
  final TextEditingController _articleController = TextEditingController();
  String? _imageUrl;
  bool _isLoading = false;

  Future<void> _fetchImage() async {
    setState(() {
      _isLoading = true;
      _imageUrl = null;
    });

    final article = _articleController.text.trim();
    if (article.isNotEmpty) {
      final imageUrl = await WBParser.getProductImage(article);
      setState(() {
        _imageUrl = imageUrl;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WB Image Parser')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _articleController,
              decoration: const InputDecoration(
                labelText: 'Введите артикул WB',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchImage,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Получить изображение'),
            ),
            const SizedBox(height: 32),
            if (_imageUrl != null)
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Изображение товара:',
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Image.network(_imageUrl!, fit: BoxFit.contain),
                      ),
                    ]),
              )
            else if (_isLoading == false && _articleController.text.isNotEmpty)
              const Text('Изображение не найдено',
                  style: TextStyle(color: Colors.red))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _articleController.dispose();
    super.dispose();
  }
}

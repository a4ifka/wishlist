import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wishlist/core/marketplace_type.dart';
import 'package:wishlist/feature/domain/entities/wish_entity.dart';
import 'package:wishlist/feature/presentation/cubit/product_cubit/product_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/wish_cubit/wish_cubit.dart';

class AddWishPage extends StatefulWidget {
  const AddWishPage({super.key});

  @override
  State<AddWishPage> createState() => _AddWishPageState();
}

class _AddWishPageState extends State<AddWishPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _linkController = TextEditingController();
  final _marketInputController = TextEditingController();

  XFile? _selectedImage;
  Uint8List? _imageBytes;
  String? _parsedImageUrl;

  bool _isMarketplaceMode = false;
  MarketplaceType _selectedMarketplace = MarketplaceType.wildberries;

  final _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _linkController.dispose();
    _marketInputController.dispose();
    super.dispose();
  }

  /// Определяет, является ли ввод полной ссылкой.
  bool get _inputIsUrl => _marketInputController.text.contains('://');

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _selectedImage = picked;
        _imageBytes = bytes;
        _parsedImageUrl = null; // галерея перекрывает распознанное фото
      });
    }
  }

  void _onParsePressed() {
    final input = _marketInputController.text.trim();
    if (input.isEmpty) return;
    FocusScope.of(context).unfocus();

    if (_inputIsUrl) {
      context.read<ProductCubit>().parseByUrl(input);
    } else {
      context.read<ProductCubit>().parseByArticle(input, _selectedMarketplace);
    }
  }

  void _onProductLoaded(BuildContext context, ProductLoaded state) {
    final p = state.product;
    _nameController.text = p.name;
    if (p.price > 0) {
      _priceController.text = p.price.toStringAsFixed(
        p.price == p.price.truncate() ? 0 : 2,
      );
    }
    // Заполняем ссылку если был введён не URL (артикул WB)
    if (!_inputIsUrl) {
      final article = _marketInputController.text.trim();
      _linkController.text =
          'https://www.wildberries.ru/catalog/$article/detail.aspx';
    } else {
      _linkController.text = _marketInputController.text.trim();
    }
    setState(() {
      _parsedImageUrl = p.imageUrl;
      _imageBytes = null;
      _selectedImage = null;
    });
  }

  void _onSave(int roomId) {
    if (!_formKey.currentState!.validate()) return;

    final hasImage = _imageBytes != null || _parsedImageUrl != null;
    if (!hasImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Добавьте фото подарка')),
      );
      return;
    }

    final wish = WishEntity(
      id: 0,
      roomId: roomId,
      name: _nameController.text.trim(),
      url: _linkController.text.trim(),
      url2: '',
      url3: '',
      imageUrl: _parsedImageUrl ?? '',
      price: double.tryParse(_priceController.text.trim()) ?? 0,
      isFulfilled: false,
    );

    if (_imageBytes != null) {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${_selectedImage!.name}';
      context.read<WishCubit>().addWishWithImage(wish, _imageBytes!, fileName);
    } else {
      // Используем URL от маркетплейса напрямую
      context.read<WishCubit>().addWish(wish);
    }
  }

  InputDecoration _field(String hint) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(focused: true),
      errorBorder: _border(),
      focusedErrorBorder: _border(focused: true),
    );
  }

  OutlineInputBorder _border({bool focused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: focused
            ? const Color(0xFF6D57FC)
            : const Color.fromRGBO(155, 121, 246, 1),
        width: focused ? 2 : 1.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roomId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(title: const Text('Создать подарок')),
      body: BlocListener<WishCubit, WishState>(
        listener: (context, state) {
          if (state is WishLoaded) {
            Navigator.pop(context);
          } else if (state is WishError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // ---- Переключатель режима ----
                _ModeToggle(
                  isMarketplace: _isMarketplaceMode,
                  onChanged: (v) => setState(() {
                    _isMarketplaceMode = v;
                    context.read<ProductCubit>().reset();
                  }),
                ),
                const SizedBox(height: 20),

                // ---- Блок маркетплейса ----
                if (_isMarketplaceMode) ...[
                  _MarketplaceBlock(
                    controller: _marketInputController,
                    selectedMarketplace: _selectedMarketplace,
                    showMarketplaceSelector: !_inputIsUrl,
                    onMarketplaceChanged: (v) =>
                        setState(() => _selectedMarketplace = v),
                    onInputChanged: (_) => setState(() {}),
                    onParsePressed: _onParsePressed,
                  ),
                  const SizedBox(height: 12),
                  BlocConsumer<ProductCubit, ProductState>(
                    listener: (context, state) {
                      if (state is ProductLoaded) {
                        _onProductLoaded(context, state);
                      }
                    },
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (state is ProductLoaded && state.product.price == 0) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Text(
                            'Название и фото загружены. Укажите цену вручную.',
                            style: TextStyle(color: Color(0xFF888888), fontSize: 12),
                          ),
                        );
                      }
                      if (state is ProductError) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red, fontSize: 13),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 4),
                ],

                // ---- Название ----
                TextFormField(
                  controller: _nameController,
                  decoration: _field('Название'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Введите название' : null,
                ),
                const SizedBox(height: 16),

                // ---- Цена ----
                TextFormField(
                  controller: _priceController,
                  decoration: _field('Цена').copyWith(prefixText: '₽ '),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Укажите цену';
                    if (double.tryParse(v) == null) return 'Некорректная цена';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ---- Фото ----
                _ImagePicker(
                  imageBytes: _imageBytes,
                  parsedImageUrl: _parsedImageUrl,
                  onTap: _pickImage,
                ),
                const SizedBox(height: 16),

                // ---- Ссылка ----
                TextFormField(
                  controller: _linkController,
                  decoration: _field('Ссылка на товар'),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 24),

                // ---- Кнопка сохранения ----
                ElevatedButton(
                  onPressed: () => _onSave(roomId),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF6D57FC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Создать подарок',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _ModeToggle extends StatelessWidget {
  final bool isMarketplace;
  final ValueChanged<bool> onChanged;

  const _ModeToggle({required this.isMarketplace, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0EEFF),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _Tab(
            label: 'Из маркетплейса',
            active: isMarketplace,
            onTap: () => onChanged(true),
          ),
          _Tab(
            label: 'Вручную',
            active: !isMarketplace,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF6D57FC) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: active ? Colors.white : const Color(0xFF888888),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _MarketplaceBlock extends StatelessWidget {
  final TextEditingController controller;
  final MarketplaceType selectedMarketplace;
  final bool showMarketplaceSelector;
  final ValueChanged<MarketplaceType> onMarketplaceChanged;
  final ValueChanged<String> onInputChanged;
  final VoidCallback onParsePressed;

  const _MarketplaceBlock({
    required this.controller,
    required this.selectedMarketplace,
    required this.showMarketplaceSelector,
    required this.onMarketplaceChanged,
    required this.onInputChanged,
    required this.onParsePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          onChanged: onInputChanged,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            hintText: 'Ссылка или артикул',
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                  color: Color.fromRGBO(155, 121, 246, 1), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                  color: Color.fromRGBO(155, 121, 246, 1), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide:
                  const BorderSide(color: Color(0xFF6D57FC), width: 2),
            ),
          ),
        ),
        if (showMarketplaceSelector) ...[
          const SizedBox(height: 12),
          _MarketplaceSelector(
            selected: selectedMarketplace,
            onChanged: onMarketplaceChanged,
          ),
        ],
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onParsePressed,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: Color(0xFF6D57FC)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Найти товар',
              style: TextStyle(
                  color: Color(0xFF6D57FC), fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------

class _MarketplaceSelector extends StatelessWidget {
  final MarketplaceType selected;
  final ValueChanged<MarketplaceType> onChanged;

  const _MarketplaceSelector(
      {required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Chip(
          label: 'Wildberries',
          active: selected == MarketplaceType.wildberries,
          onTap: () => onChanged(MarketplaceType.wildberries),
        ),
        const SizedBox(width: 8),
        _Chip(
          label: 'Ozon',
          active: selected == MarketplaceType.ozon,
          onTap: () => onChanged(MarketplaceType.ozon),
        ),
        const SizedBox(width: 8),
        _Chip(
          label: 'Яндекс',
          active: selected == MarketplaceType.yandexMarket,
          onTap: () => onChanged(MarketplaceType.yandexMarket),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _Chip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF6D57FC)
              : const Color(0xFFF0EEFF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: active ? Colors.white : const Color(0xFF6D57FC),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _ImagePicker extends StatelessWidget {
  final Uint8List? imageBytes;
  final String? parsedImageUrl;
  final VoidCallback onTap;

  const _ImagePicker({
    required this.imageBytes,
    required this.parsedImageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(246, 245, 248, 1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color.fromRGBO(155, 121, 246, 1),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: _buildImage(),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imageBytes != null) {
      return Image.memory(imageBytes!, fit: BoxFit.cover, width: double.infinity);
    }
    if (parsedImageUrl != null) {
      return Image.network(
        parsedImageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate_outlined,
            size: 48, color: Color.fromRGBO(155, 121, 246, 1)),
        SizedBox(height: 8),
        Text(
          'Добавить фото',
          style: TextStyle(
              color: Color.fromRGBO(155, 121, 246, 1), fontSize: 16),
        ),
      ],
    );
  }
}

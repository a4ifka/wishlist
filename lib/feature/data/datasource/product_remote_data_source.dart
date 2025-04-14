// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

abstract class ProductRemoteDataSource {
  Future<String?> getProductImage(String article);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  @override
  Future<String?> getProductImage(String article) async {
    try {
      final url = 'https://wbninja.ru/parser/?s=$article';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        final imageElement = document.querySelector('a[target="_blank"] img');

        if (imageElement != null) {
          return imageElement.attributes['src'];
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error parsing WB product: $e');
    }
  }
}

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class WBParser {
  static Future<String?> getProductImage(String article) async {
    try {
      final url = 'https://wbninja.ru/parser/?s=$article';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        final imageElement = document.querySelector('a[target="_blank"] img');

        if (imageElement != null) {
          final imageUrl = imageElement.attributes['src'];
          return imageUrl;
        }
      }
      return null;
    } catch (e) {
      print('Error parsing WB product: $e');
      return null;
    }
  }
}

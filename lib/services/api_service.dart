import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // Base URL for the API
  final String _baseUrl = 'https://dummyjson.com/products';

  // Function to fetch products from the API
  Future<List<Product>> fetchProducts() async {
    // Send a GET request to the API
    final response = await http.get(Uri.parse(_baseUrl));

    // Check if the response status is 200 (OK)
    if (response.statusCode == 200) {
      // Parse the JSON response and extract the 'products' list
      final List productsJson = jsonDecode(response.body)['products'];

      // Convert each JSON object in the list to a Product model
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception with an error message
      throw Exception('Failed to load products');
    }
  }
}

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

/// `ProductViewModel` is a ChangeNotifier that handles fetching and managing
/// the list of products. It interacts with an API service to load product data
/// and provides state information such as loading status and error messages.
class ProductViewModel extends ChangeNotifier {
  // Instance of ApiService to fetch product data from the API.
  final ApiService _apiService = ApiService();

  // Private list of products that will be managed by the ViewModel.
  List<Product> _products = [];

  // Private boolean indicating if data is currently being loaded.
  bool _loading = false;

  // Private string to store any error messages that occur during data fetching.
  String _errorMessage = '';

  /// Public getter to access the list of products.
  List<Product> get products => _products;

  /// Public getter to check if the ViewModel is currently loading data.
  bool get loading => _loading;

  /// Public getter to access the error message, if any.
  String get errorMessage => _errorMessage;

  /// Fetches the list of products from the API. The method sets the loading
  /// state to true while the data is being fetched, and notifies listeners
  /// when the data is successfully loaded or if an error occurs.
  Future<void> fetchProducts() async {
    // Set loading to true and clear any previous error messages.
    _loading = true;
    _errorMessage = '';

    // Notify listeners to update the UI with the current loading state.
    notifyListeners();

    try {
      // Attempt to fetch products from the API.
      _products = await _apiService.fetchProducts();
    } catch (e) {
      // If an error occurs, store the error message.
      _errorMessage = 'Failed to load products: ${e.toString()}';
    } finally {
      // Set loading to false after the operation completes (either success or failure).
      _loading = false;

      // Notify listeners to update the UI with the new data or error message.
      notifyListeners();
    }
  }
}

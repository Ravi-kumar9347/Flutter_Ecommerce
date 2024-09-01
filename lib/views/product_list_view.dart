import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';
import 'product_details_view.dart';
import '../models/product.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

/// A StatelessWidget that displays a list of products fetched from the API.
/// The widget listens to changes in the ProductViewModel using the Consumer.
class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductViewModel>(
        builder: (context, viewModel, child) {
          // Show a loading indicator while the data is being fetched.
          if (viewModel.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          // Display an error message if fetching data fails.
          else if (viewModel.errorMessage.isNotEmpty) {
            return Center(child: Text(viewModel.errorMessage));
          }
          // Display the list of products once the data is successfully fetched.
          else {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: [
                // Display the header text "Products".
                const Padding(
                  padding: EdgeInsets.only(top: 36.0, left: 24.0),
                  child: Text(
                    'Products',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                // Display a subtitle "Super Summer Sale".
                const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Super Summer Sale',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Color(0xFF9B9B9B),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                // Build a list of ProductItem widgets.
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: viewModel.products.length,
                  itemBuilder: (context, index) {
                    final product = viewModel.products[index];
                    return ProductItem(product: product);
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

/// A StatelessWidget that represents a single product item in the list.
/// This widget displays the product's image, title, rating, brand, and price.
class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({Key? key, required this.product}) : super(key: key);

  /// A helper method to shorten the product title to two words.
  String getShortTitle(String title) {
    List<String> words = title.split(' ');
    if (words.length > 2) {
      return words.sublist(0, 2).join(' ');
    } else {
      return title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the ProductDetailsView when the product item is tapped.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsView(product: product),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Display the product image with an optional discount badge.
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: MediaQuery.of(context).size.height / 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0.0),
                    image: DecorationImage(
                      image: NetworkImage(product.thumbnail),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // If the product has a discount, show the discount percentage.
                if (product.discountPercentage > 0)
                  Positioned(
                    left: 2.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        '-${product.discountPercentage.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8.0),
            // Display product details such as rating, brand, title, and price.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Display the rating with stars and the number of reviews.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RatingBarIndicator(
                        rating: product.rating,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        "(${product.reviews.length})",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  // Display the product brand.
                  Text(
                    product.brand,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFF9B9B9B),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  // Display the shortened product title.
                  Text(
                    getShortTitle(product.title),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  // Display the original price if there's a discount, and the final price.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (product.discountPercentage > 0)
                        Text(
                          '${product.price.toStringAsFixed(2)}\$',
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Color(0xFF9B9B9B),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        // Calculate the final price after discount.
                        '${(product.price - (product.price * product.discountPercentage / 100)).toStringAsFixed(2)}\$',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
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

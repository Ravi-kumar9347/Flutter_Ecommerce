import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/product.dart';

class ProductDetailsView extends StatelessWidget {
  final Product product;

  const ProductDetailsView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 40.0, right: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row containing back button, category title, and share button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                IconButton(
                  iconSize: 24.0,
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                ),
                // Category title
                Text(
                  product.category.substring(0, 1).toUpperCase() +
                      product.category.substring(1),
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w500),
                ),
                // Share button
                IconButton(
                  iconSize: 24.0,
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // Implement share functionality
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Horizontal list of product images
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.2,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: product.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Image.network(
                      product.images.isNotEmpty
                          ? product.images[index]
                          : product
                              .thumbnail, // Display image if available, else thumbnail
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Product brand, title, rating, and price section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Column displaying brand, title, and rating
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand name
                    Text(
                      product.brand,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    // Product title
                    Text(
                      product.title,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF9B9B9B)),
                    ),
                    const SizedBox(height: 2),
                    // Rating bar and review count
                    Row(
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
                          "(${product.reviews.length})", // Display number of reviews
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Column displaying the product price after discount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Final price after applying discount
                    Text(
                      '\$${(product.price - (product.price * product.discountPercentage / 100)).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Product description
            Text(
              product.description,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF222222),
              ),
            ),
            const Spacer(),

            // 'Add to Cart' button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implement add to cart functionality
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                child: const Text(
                  'ADD TO CART',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

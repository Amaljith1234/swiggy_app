import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/favorites_provider.dart';


class FavoriteButton extends StatefulWidget {
  final String restaurantId;

  const FavoriteButton({
    Key? key,
    required this.restaurantId,
  }) : super(key: key);

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;  // ✅ Track favorite status

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  /// ✅ Check if the restaurant is already a favorite
  Future<void> _checkIfFavorite() async {
    final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
    await favoriteProvider.fetchFavoriteFoods();

    setState(() {
      isFavorite = favoriteProvider.favoriteFoods
          .any((restaurant) => restaurant.id == widget.restaurantId);
    });
  }

  /// ✅ Toggle favorite with restaurant ID
  Future<void> _toggleFavorite() async {
    final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);

    try {
      await favoriteProvider.addAndRemoveToFavorites(widget.restaurantId, context);

      setState(() {
        isFavorite = !isFavorite;  // Toggle the status
      });

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update favorite status: $error'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.black,
      ),
      onPressed: _toggleFavorite,  // ✅ Trigger toggle
    );
  }
}

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../models/category.dart';
import '../widgets/category_tile.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Category> categories = [
    Category(
        name: 'Zwykłe',
        questions: ['Pytanie 1', 'Pytanie 2', 'Pytanie 3'],
        challenges: ['Wyzwanie 1', 'Wyzwanie 2', 'Wyzwanie 3']
    ),
    Category(
        name: 'Impreza',
        questions: ['Impreza Pytanie 1', 'Impreza Pytanie 2'],
        challenges: ['Impreza Wyzwanie 1', 'Impreza Wyzwanie 2']
    ),
    Category(
        name: 'Ekstremalne',
        isLocked: true,
        questions: ['Ekstremalne Pytanie 1'],
        challenges: ['Ekstremalne Wyzwanie 1']
    ),
    Category(
        name: 'Ostre',
        isLocked: true,
        questions: ['Ostre Pytanie 1'],
        challenges: ['Ostre Wyzwanie 1']
    ),
  ];
  void showLockedCategoryAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Zablokowana Kategoria"),
          content: Text("Ta kategoria jest dostępna po subskrypcji."),
          actions: <Widget>[
            TextButton(
              child: Text("Zamknij"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Subskrybuj"),
              onPressed: () {
                Navigator.of(context).pop();
                purchaseSubscription();
              },
            ),
          ],
        );
      },
    );
  }

  void purchaseSubscription() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      // Obsługa błędu: Sklep nie jest dostępny
      return;
    }

    const Set<String> _kIds = {'premium_category_subscription'};
    final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      // Obsługa błędu: ID produktów nie znaleziono
      return;
    }

    List<ProductDetails> products = response.productDetails;
    final ProductDetails productDetails = products[0];
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pytania i Wyzwania')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category.name),
            trailing: category.isLocked ? Icon(Icons.lock) : null,
            onTap: () {
              if (!category.isLocked) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen(category: category)),
                );
              } else {
                showLockedCategoryAlert(context);
              }
            },
          );
        },
      ),
    );
  }
}


import 'package:flutter/material.dart';

void main() {
  runApp(const AuburnBrewApp());
}

// Sets up the app and its main theme
class AuburnBrewApp extends StatelessWidget {
  const AuburnBrewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auburn Brew',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B4513),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
        useMaterial3: true,
      ),
      home: const OrderPage(),
    );
  }
}

// Stores the name, price, and icon for each menu item
class MenuItem {
  final String name;
  final double price;
  final IconData icon;

  const MenuItem(this.name, this.price, this.icon);
}

// StatefulWidget allows the screen to update when items are selected
class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // Menu items available for ordering
  final List<MenuItem> menu = [
    const MenuItem('Coffee', 3.50, Icons.coffee),
    const MenuItem('Latte', 5.00, Icons.local_cafe),
    const MenuItem('Cappuccino', 4.50, Icons.coffee_maker),
    const MenuItem('Muffin', 3.00, Icons.bakery_dining),
  ];

  // Tracks selected products and the extra option
  final Set<int> selectedItems = {};
  bool addWhippedCream = false;

  // Calculates the total based on the current selections
  double get total {
    double amount = 0;

    for (int index in selectedItems) {
      amount += menu[index].price;
    }

    if (addWhippedCream && selectedItems.isNotEmpty) {
      amount += 0.75;
    }

    return amount;
  }

  // Shows a confirmation dialog when an order is placed
  void submitOrder() {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an item first.'),
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Confirmed!'),
        content: Text(
          'Thank you for ordering from Auburn Brew!\n'
              'Your total is \$${total.toStringAsFixed(2)}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6F4E37),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Auburn Brew'),
      ),

      // ListView makes the order screen scrollable
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Icon(
                Icons.local_cafe,
                size: 75,
                color: Color(0xFF6F4E37),
              ),
              const SizedBox(height: 10),
              const Text(
                'Welcome to Auburn Brew!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6F4E37),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose your favorites below.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Creates a reusable card for each product
              for (int i = 0; i < menu.length; i++)
                ProductCard(
                  item: menu[i],
                  selected: selectedItems.contains(i),
                  onChanged: (value) {
                    // setState refreshes the screen after selections change
                    setState(() {
                      if (value) {
                        selectedItems.add(i);
                      } else {
                        selectedItems.remove(i);
                      }
                    });
                  },
                ),

              const SizedBox(height: 10),

              // Conditional UI: only show extras when items are selected
              if (selectedItems.isNotEmpty) ...[
                const Text(
                  'Extra Options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SwitchListTile(
                  title: const Text('Add whipped cream'),
                  subtitle: const Text('Additional \$0.75'),
                  value: addWhippedCream,
                  onChanged: (value) {
                    setState(() {
                      addWhippedCream = value;
                    });
                  },
                ),
              ],

              const SizedBox(height: 15),
              const Divider(thickness: 2),
              const SizedBox(height: 10),

              // Displays the updated order total
              Text(
                'Total: \$${total.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6F4E37),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: submitOrder,
                icon: const Icon(Icons.check_circle),
                label: const Text('Place Order'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6F4E37),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable widget that displays a product and its checkbox
class ProductCard extends StatelessWidget {
  final MenuItem item;
  final bool selected;
  final ValueChanged<bool> onChanged;

  const ProductCard({
    super.key,
    required this.item,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // New UI feature: Card adds a styled container for each item
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: CheckboxListTile(
        secondary: Icon(
          item.icon,
          size: 34,
          color: const Color(0xFF8B4513),
        ),
        title: Text(
          item.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '\$${item.price.toStringAsFixed(2)}',
        ),
        value: selected,
        onChanged: (value) {
          onChanged(value ?? false);
        },
      ),
    );
  }
}

// AI Acknowledgment:
// ChatGPT (OpenAI) assisted with Flutter code development,
// layout, and comments for this assignment.

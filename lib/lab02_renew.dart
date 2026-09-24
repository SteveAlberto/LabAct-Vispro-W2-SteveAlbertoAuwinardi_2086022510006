import 'package:flutter/material.dart';
import 'features/menu/presentation/widgets/price_chip.dart';
import 'features/menu/presentation/widgets/promo_badge.dart';
import 'features/menu/presentation/widgets/menu_header.dart';
import 'features/menu/presentation/widgets/menu_search_bar.dart';
import 'features/menu/presentation/widgets/checkout_bar.dart';

void main() => runApp(const Lab02App());

class Lab02App extends StatelessWidget {
  const Lab02App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warung Digital',
      theme: ThemeData(colorSchemeSeed: const Color(0xFF00696E)),
      home: const MenuScreen(),
    );
  }
}

class MenuItem {
  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    this.promo = false,
  });

  final String id;
  final String name;
  final int price;
  final bool promo;
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<MenuItem> _items = [
    MenuItem(id: 'm1', name: 'Nasi Goreng Spesial', price: 18000, promo: true),
    MenuItem(id: 'm2', name: 'Mie Ayam Bakso', price: 15000),
    MenuItem(id: 'm3', name: 'Sate Ayam (10 tusuk)', price: 25000),
    MenuItem(id: 'm4', name: 'Ayam Geprek Sambal Matah', price: 20000, promo: true),
    MenuItem(id: 'm5', name: 'Soto Ayam Lamongan', price: 17000),
    MenuItem(id: 'm6', name: 'Es Teh Manis', price: 5000),
    MenuItem(id: 'm7', name: 'Es Jeruk Peras', price: 8000),
    MenuItem(id: 'm8', name: 'Kopi Susu Gula Aren', price: 12000),
  ];

  final Map<String, int> _quantities = {};

  late TextEditingController _searchController;
  late ScrollController _listController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _listController = ScrollController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _listController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    List<MenuItem> visible = [];
    for (MenuItem item in _items) {
      if (_query.isEmpty ||
          item.name.toLowerCase().contains(_query.toLowerCase())) {
        visible.add(item);
      }
    }

    int total = 0;
    int lineCount = 0;
    _quantities.forEach((String id, int qty) {
      if (qty > 0) {
        lineCount = lineCount + 1;
        for (MenuItem item in _items) {
          if (item.id == id) {
            total = total + (item.price * qty);
          }
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Warung Digital')),
      body: Column(
        children: [
          const MenuHeader(),
          
          MenuSearchBar(
            controller: _searchController,
            queryText: _query,
            onSearch: (String value) {
              setState(() => _query = value);
            },
            onClear: () {
              _searchController.clear();
              setState(() => _query = '');
            },
          ),
          
          Expanded(
            child: visible.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off, size: 48, color: Colors.grey),
                        const SizedBox(height: 8),
                        Text(
                          'Tidak ada menu yang cocok dengan "$_query"',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                          child: const Text('Hapus pencarian'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _listController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: visible.length,
                    itemBuilder: (BuildContext context, int index) {
                      MenuItem item = visible[index];
                      int qty = _quantities[item.id] ?? 0;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            item.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        if (item.promo) const SizedBox(width: 6),
                                        if (item.promo) const PromoBadge(),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    PriceChip(amount: item.price),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: qty == 0
                                    ? null
                                    : () {
                                        setState(() {
                                          _quantities[item.id] = qty - 1;
                                        });
                                      },
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                              SizedBox(
                                width: 28,
                                child: Text(
                                  '$qty',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: qty >= 99
                                    ? null
                                    : () {
                                        setState(() {
                                          _quantities[item.id] = qty + 1;
                                        });
                                      },
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          
          CheckoutBar(
            total: total,
            lineCount: lineCount,
            onSave: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Pesanan disimpan: Rp $total'),
                ),
              );
              setState(() => _quantities.clear());
            },
          ),
        ],
      ),
    );
  }
}


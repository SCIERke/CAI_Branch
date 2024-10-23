import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'EditDetail.dart';
import 'ErrorDetailPage.dart';
import 'FeedbackPageState.dart';
// import 'main.dart';
import 'ProductCard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AlertHomePage(),
    );
  }
}

class AlertHomePage extends StatefulWidget {
  @override
  _AlertHomePageState createState() => _AlertHomePageState();
}

class _AlertHomePageState extends State<AlertHomePage> {
  TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  TextEditingController _productCodeController = TextEditingController();

  List products = [];
  Future<void> fetchData() async {
    final url = Uri.parse('http://localhost:8000/branch_ErrorList');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          products = json.decode(response.body);
          filteredProducts = products;
          _sortProducts();
          // print(products);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e); // Handle errors
    }
  }

  List filteredProducts = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _sortProducts() {
    setState(() {
      filteredProducts.sort((a, b) {
        if (a['is_error'] && !b['is_error']) return -1;
        if (!a['is_error'] && b['is_error']) return 1;

        // ถ้า isError เหมือนกัน ให้เรียงตามวันที่ alertDate (ล่าสุดก่อน)
        DateTime dateA = DateFormat('dd/MM/yyyy').parse(a['error_date']);
        DateTime dateB = DateFormat('dd/MM/yyyy').parse(b['error_date']);
        return dateB.compareTo(dateA);
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
        _filterProductsByDate(_dateController.text); // กรองสินค้าตามวันที่เลือก
      });
    }
  }

  void _filterProductsByDate(String selectedDate) {
    setState(() {
      filteredProducts = products
          .where((product) => product['error_date'] == selectedDate)
          .toList();
      _sortProducts(); // จัดเรียงใหม่หลังการกรอง
    });
  }

  void _filterProducts(String searchCode) {
    setState(() {
      if (searchCode.isEmpty) {
        filteredProducts = products;
      } else {
        filteredProducts = products
            .where((product) =>
                product['product_code'].toString().contains(searchCode))
            .toList();
      }
      _sortProducts(); // จัดเรียงใหม่หลังการกรอง
    });

    void updateProduct(int index, Map<String, dynamic> updatedProduct) {
      setState(() {
        products[index] =
            updatedProduct; // Update the product at the given index
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/ce00aca9cb774dbb1c13a664bdfb90da.png',
                width: 100),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: AssetImage('assets/user_profile.jpg'),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchData,
            tooltip: 'Refresh',
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _productCodeController,
              decoration: InputDecoration(
                hintText: 'Search by Product Code',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: (value) {
                _filterProducts(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];

                // fetch ตรงนี้
                return ProductCard(
                  product: product,
                  isError: product['is_error'],
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ErrorDetailPage(productData: product),
                      ),
                    );

                    if (result != null && result == 'updated') {
                      setState(() {
                        //api
                        product['is_error'] = false;
                      });
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

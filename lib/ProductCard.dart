import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'EditDetail.dart';
import 'ErrorDetailPage.dart';
import 'FeedbackPageState.dart';
import 'main.dart';
// import 'ProductCard.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  final bool isError;
  final VoidCallback onPressed;

  ProductCard(
      {required this.product, required this.isError, required this.onPressed});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isError = true;

  @override
  void initState() {
    super.initState();
    isError = widget.isError;
  }

  @override
  Widget build(BuildContext context) {
    bool nowstate = widget.product['is_error'];
    return Card(
      color: nowstate ? Colors.red : Colors.white,
      child: ListTile(
        leading: widget.product['is_error']
            ? Icon(Icons.error, color: Colors.white)
            : Icon(Icons.check_circle_outline, color: Colors.green),
        title: Text(widget.product['product_code']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date of alert: ${widget.product['error_date']}'),
            if (widget.product['is_error'])
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.white),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'This Product Data got an error',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ErrorDetailPage(productData: widget.product),
              ),
            );

            if (result != null && result == true) {
              setState(() {
                isError = false;
                widget.product['is_error'] = false;
              });
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MyApp()),
                (Route<dynamic> route) => false,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor:
                widget.product['is_error'] ? Colors.red : Colors.white,
            backgroundColor:
                widget.product['is_error'] ? Colors.white : Colors.blue,
          ),
          child: Text('Details'),
        ),
      ),
    );
  }
}

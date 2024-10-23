import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'EditDetail.dart';
// import 'ErrorDetailPage.dart';
import 'FeedbackPageState.dart';
import 'main.dart';
import 'ProductCard.dart';

class ErrorDetailPage extends StatelessWidget {
  final Map<String, dynamic> productData; // json

  ErrorDetailPage({required this.productData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error Detail'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: productData['is_error'] ? Colors.red : Colors.green,
                child: ListTile(
                  title: Text(
                    productData['product_code'],
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date of alert: ${productData['error_date']}',
                          style: TextStyle(color: Colors.white)),
                      if (productData['is_error'])
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.white),
                            SizedBox(width: 5),
                            Text('This Product Data got an error',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildNonEditableText(
                  'PRODUCT_CODE', productData['product_code']),
              _buildNonEditableText('BRANCH_ID', productData['branch_id']),
              _buildNonEditableText('REC_TYPE', productData['rec_type']),
              _buildNonEditableText('DOC_TYPE', productData['doc_type']),
              _buildNonEditableText('TRANS_TYPE', productData['trans_type']),
              _buildNonEditableText('DOC_DATE', productData['doc_date']),
              _buildNonEditableText('DOC_NO', productData['doc_no']),
              _buildNonEditableText('REASON_CODE', productData['reason_code']),
              _buildNonEditableText('CV_CODE', productData['cv_code']),
              _buildNonEditableText('PMA_CODE', productData['pma_code']),
              _buildNonEditableText(
                  'CATEGORY_CODE', productData['category_code']),
              _buildNonEditableText(
                  'SUBCATEGORY_CODE', productData['subcategory_code']),
              _buildNonEditableText('QTY', productData['quantity'].toString()),
              SizedBox(height: 20),
              if (productData['is_error']) ...[
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      print('productData : ');
                      print(productData);
                      //API
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeedbackPage(
                            productData: productData,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Feedback'),
                  ),
                ),
              ] else ...[
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      //API
                      productData['is_error'] = false;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlertHomePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Back'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNonEditableText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

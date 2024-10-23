// import 'dart:ui_web';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class EditingDetailPage extends StatefulWidget {
//   final String productCode;

//   EditingDetailPage({required this.productCode});

//   @override
//   _EditingDetailPageState createState() => _EditingDetailPageState();
// }

// class _EditingDetailPageState extends State<EditingDetailPage> {
//   late Map<String, dynamic> product = {};
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> patchfeedbackData() async {
//     final url = Uri.parse(
//         'http://localhost:8000/branch_EditDetail/${widget.productCode}');

//     Map<String, dynamic> feedbackData = {
//       "product_code":  _buildEditableField('PRODUCT_CODE', product['product_code']),,
//       "is_error":
//     };

//     try {
//       final response = await http.patch(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(feedbackData),
//       );
//       if (response.statusCode == 200) {
//       } else {
//         throw Exception('Failed to patch data');
//       }
//     } catch (e) {
//       print(e); // Handle errors
//     }
//   }

//   Future<void> fetchData() async {
//     final url = Uri.parse(
//         'http://localhost:8000/branch_ErrorDetail/${widget.productCode}');

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         setState(() {
//           product = json.decode(response.body);
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print(e); // Handle errors
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Editing Detail'),
//           backgroundColor: Colors.red,
//         ),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Editing Detail'),
//         backgroundColor: Colors.red,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Card(
//                 color: product['is_error'] ? Colors.red : Colors.green,
//                 child: ListTile(
//                   title: Text(
//                     product['product_code'],
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Date of alert: ${product['error_date']}',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       if (product['is_error'])
//                         Row(
//                           children: [
//                             Icon(Icons.access_time, color: Colors.white),
//                             SizedBox(width: 5),
//                             Text(
//                               'This Product Data got an error',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       if (!product['is_error'])
//                         Text('No Error', style: TextStyle(color: Colors.white)),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               _buildEditableField('PRODUCT_CODE', product['product_code']),
//               _buildEditableField('BRANCH_ID', product['branch_id']),
//               _buildEditableField('REC_TYPE', product['rec_type']),
//               _buildEditableField('DOC_TYPE', product['doc_type']),
//               _buildEditableField('TRANS_TYPE', product['trans_type']),
//               _buildEditableField('DOC_DATE', product['doc_date']),
//               _buildEditableField('DOC_NO', product['doc_no']),
//               _buildEditableField('REASON_CODE', product['reason_code']),
//               _buildEditableField('CV_CODE', product['cv_code']),
//               _buildEditableField('PMA_CODE', product['pma_code']),
//               _buildEditableField('CATEGORY_CODE', product['category_code']),
//               _buildEditableField(
//                   'SUBCATEGORY_CODE', product['subcategory_code']),
//               _buildEditableField('QTY', product['quantity'].toString()),
//               SizedBox(height: 20),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.white,
//                     backgroundColor: Colors.red,
//                   ),
//                   child: Text('Submit'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Build editable field method
//   Widget _buildEditableField(String label, String? initialValue) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         initialValue: initialValue,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'main.dart';

class EditingDetailPage extends StatefulWidget {
  final String productCode;

  EditingDetailPage({required this.productCode});

  @override
  _EditingDetailPageState createState() => _EditingDetailPageState();
}

class _EditingDetailPageState extends State<EditingDetailPage> {
  late TextEditingController productCodeController;
  late TextEditingController branchIdController;
  late TextEditingController recTypeController;
  late TextEditingController docTypeController;
  late TextEditingController transTypeController;
  late TextEditingController docDateController;
  late TextEditingController docNoController;
  late TextEditingController reasonCodeController;
  late TextEditingController cvCodeController;
  late TextEditingController pmaCodeController;
  late TextEditingController categoryCodeController;
  late TextEditingController subCategoryCodeController;
  late TextEditingController quantityController;

  late Map<String, dynamic> product = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse(
        'http://localhost:8000/branch_ErrorDetail/${widget.productCode}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          product = json.decode(response.body);

          // Initialize controllers with existing product data
          productCodeController =
              TextEditingController(text: product['product_code']);
          branchIdController =
              TextEditingController(text: product['branch_id']);
          recTypeController = TextEditingController(text: product['rec_type']);
          docTypeController = TextEditingController(text: product['doc_type']);
          transTypeController =
              TextEditingController(text: product['trans_type']);
          docDateController = TextEditingController(text: product['doc_date']);
          docNoController = TextEditingController(text: product['doc_no']);
          reasonCodeController =
              TextEditingController(text: product['reason_code']);
          cvCodeController = TextEditingController(text: product['cv_code']);
          pmaCodeController = TextEditingController(text: product['pma_code']);
          categoryCodeController =
              TextEditingController(text: product['category_code']);
          subCategoryCodeController =
              TextEditingController(text: product['subcategory_code']);
          quantityController =
              TextEditingController(text: product['quantity'].toString());

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> patchfeedbackData() async {
    final url = Uri.parse(
        'http://localhost:8000/branch_EditDetail/${widget.productCode}');

    Map<String, dynamic> feedbackData = {
      "product_code": productCodeController.text,
      "branch_id": branchIdController.text,
      "rec_type": recTypeController.text,
      "doc_type": docTypeController.text,
      "trans_type": transTypeController.text,
      "doc_date": docDateController.text,
      "doc_no": docNoController.text,
      "reason_code": reasonCodeController.text,
      "cv_code": cvCodeController.text,
      "pma_code": pmaCodeController.text,
      "category_code": categoryCodeController.text,
      "subcategory_code": subCategoryCodeController.text,
      "quantity": double.parse(
          quantityController.text), // Assuming quantity is a double
      "is_error": false // Example to resolve the error state
    };

    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(feedbackData),
      );
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlertHomePage(),
          ),
        );
      } else {
        throw Exception('Failed to patch data');
      }
    } catch (e) {
      print(e); // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Editing Detail'),
          backgroundColor: Colors.red,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Editing Detail'),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color:
                    (product['is_error'] ?? false) ? Colors.red : Colors.green,
                child: ListTile(
                  title: Text(
                    product['product_code'] ?? 'Unknown',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date of alert: ${product['error_date'] ?? 'Unknown'}',
                        style: TextStyle(color: Colors.white),
                      ),
                      if (product['is_error'] ?? false)
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              'This Product Data got an error',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      if (!(product['is_error'] ?? false))
                        Text('No Error', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildEditableField('PRODUCT_CODE', productCodeController),
              _buildEditableField('BRANCH_ID', branchIdController),
              _buildEditableField('REC_TYPE', recTypeController),
              _buildEditableField('DOC_TYPE', docTypeController),
              _buildEditableField('TRANS_TYPE', transTypeController),
              _buildEditableField('DOC_DATE', docDateController),
              _buildEditableField('DOC_NO', docNoController),
              _buildEditableField('REASON_CODE', reasonCodeController),
              _buildEditableField('CV_CODE', cvCodeController),
              _buildEditableField('PMA_CODE', pmaCodeController),
              _buildEditableField('CATEGORY_CODE', categoryCodeController),
              _buildEditableField(
                  'SUBCATEGORY_CODE', subCategoryCodeController),
              _buildEditableField('QTY', quantityController),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: patchfeedbackData, // Submit changes via API
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build editable field method
  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

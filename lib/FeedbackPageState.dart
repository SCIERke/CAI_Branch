import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'EditDetail.dart';
import 'ErrorDetailPage.dart';
// import 'FeedbackPageState.dart';
import 'main.dart';
import 'ProductCard.dart';

class FeedbackPage extends StatefulWidget {
  final Map<String, dynamic> productData; // fetch specific data
  // Callback for feedback

  FeedbackPage({required this.productData});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  bool isCheckedYes = false;
  bool isCheckedNo = false;
  TextEditingController feedbackController = TextEditingController();

  Future<void> patchfeedbackData() async {
    final url = Uri.parse(
        'http://localhost:8000/branch_Feedback/${widget.productData['product_code']}');

    Map<String, dynamic> feedbackData = {
      "feedback": feedbackController.text,
      "is_error": isCheckedYes
    };

    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(feedbackData),
      );
      if (response.statusCode == 200) {
        setState(() {
          setState(() {});
        });
        print('isCheckedYes' + isCheckedYes.toString());
      } else {
        throw Exception('Failed to patch data');
      }
    } catch (e) {
      print(e); // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color:
                    widget.productData['is_error'] ? Colors.red : Colors.green,
                child: ListTile(
                  title: Text(
                    widget.productData['product_code'],
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //set date
                      Text('Date of alert: ${widget.productData['error_date']}',
                          style: TextStyle(color: Colors.white)),
                      if (widget.productData['is_error'])
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.white),
                            SizedBox(width: 5),
                            Text('This Product Data got an error',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      if (!widget.productData['is_error'])
                        Text('No Error', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Does this mistake actually occur?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Checkbox(
                    value: isCheckedYes,
                    onChanged: (value) {
                      setState(() {
                        isCheckedYes = value!;
                        isCheckedNo = false;
                      });
                    },
                  ),
                  Text('Yes'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: isCheckedNo,
                    onChanged: (value) {
                      setState(() {
                        isCheckedNo = value!;
                        isCheckedYes = false;
                      });
                    },
                  ),
                  Text('No'),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: feedbackController,
                decoration: InputDecoration(
                  labelText: 'Feedback',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    patchfeedbackData();

                    print('isCheckedYes' + isCheckedYes.toString());
                    if (isCheckedYes) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditingDetailPage(
                              productCode: widget.productData['product_code']),
                        ),
                      );
                    } else {
                      widget.productData['is_error'] = false;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlertHomePage(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                  child: Text('Send'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

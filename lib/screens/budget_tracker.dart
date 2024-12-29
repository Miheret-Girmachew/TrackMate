import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'TransactionPage.dart'; // Import the TransactionPage
import 'PlannedBudgetPage.dart'; // Import the PlannedBudgetPage

class BudgetTracker extends StatefulWidget {
  @override
  _BudgetTrackerState createState() => _BudgetTrackerState();
}

class _BudgetTrackerState extends State<BudgetTracker> {
  double _totalBalance = 0.0;
  double _totalEarned = 0.0;
  double _totalSpent = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? transactionsString = prefs.getString('transactions');
    if (transactionsString != null) {
      List<Map<String, dynamic>> transactions = List<Map<String, dynamic>>.from(json.decode(transactionsString));
      setState(() {
        _totalEarned = transactions
            .where((transaction) => transaction['type'] == '+')
            .fold(0.0, (sum, transaction) => sum + transaction['amount']);
        _totalSpent = transactions
            .where((transaction) => transaction['type'] == '-')
            .fold(0.0, (sum, transaction) => sum + transaction['amount']);
        _totalBalance = _totalEarned - _totalSpent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Budget Tracker',
          style: TextStyle(
            color: Colors.white, // White color
            fontWeight: FontWeight.bold, // Bold text
            fontSize: 28, // Larger font size
            fontFamily: 'Roboto', // You can replace this with any custom font
            letterSpacing: 1.2, // Slightly increased letter spacing
          ),
        ),
        backgroundColor: Color(0xFF580645), // Dark purple background
        elevation: 0,
        centerTitle: true, // Center the title
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xFF580645), // Dark Purple Background
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Color(0xFFF4E8FE), // Light Lavender Box Color
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Wallet',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9), // Increased opacity for better readability
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available balance',
                            style: TextStyle(
                              color: Colors.black87, // Darker color for better readability
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '\$ $_totalBalance',
                            style: TextStyle(
                              color: Colors.black, // Darker color for better readability
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Spent',
                                    style: TextStyle(
                                      color: Colors.black87, // Darker color for better readability
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '\$ $_totalSpent',
                                    style: TextStyle(
                                      color: Colors.black, // Darker color for better readability
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Earned',
                                    style: TextStyle(
                                      color: Colors.black87, // Darker color for better readability
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '\$ $_totalEarned',
                                    style: TextStyle(
                                      color: Colors.black, // Darker color for better readability
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    // Transactions Section
                    Text(
                      'Transactions',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionPage(), // Navigate to Transaction Page
                          ),
                        );
                        _loadTransactions(); // Reload transactions after returning from TransactionPage
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9), // Increased opacity for better readability
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.account_balance_wallet,
                              color: Colors.black, // Darker color for better readability
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'View Transactions',
                                style: TextStyle(
                                  color: Colors.black, // Darker color for better readability
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.black, // Darker color for better readability
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    // Planned Budget Section
                    Text(
                      'Planned Budget',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlannedBudgetPage(), // Navigate to Planned Budget Page
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9), // Increased opacity for better readability
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.black, // Darker color for better readability
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Track Planned Budget',
                                style: TextStyle(
                                  color: Colors.black, // Darker color for better readability
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.black, // Darker color for better readability
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
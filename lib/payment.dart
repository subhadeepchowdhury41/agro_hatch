import 'package:agro_hatch/constants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

class Payment extends StatefulWidget {
  Payment({this.amount});
  final int amount;
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  // static const platform = const MethodChannel("razorpay_flutter");
  Razorpay _razorpay;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: kAppBarColor,
          title: const Text('Payment Portal'),
        ),
        body: Container(
          color: kBodyBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                margin: EdgeInsets.all(120.0),
                padding: EdgeInsets.all(20.0),
                child: GestureDetector(
                    onTap: openCheckout, child: Center(child: Text('pay ${widget.amount} Rs-'))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_j54N3JdKBbNTnX',
      'amount': widget.amount * 100,
      'name': 'Jangalmahal Farm Services LLP',
      'description': 'Planting Material',
      'prefill': {'contact': '8768715527', 'email': 'subhadeepchowdhury41@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response.code.toString());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response.walletName);
  }
}

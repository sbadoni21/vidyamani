import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';

class UpiPaymentScreen extends StatefulWidget {
  const UpiPaymentScreen({super.key});
  @override
  _UpiPaymentScreenState createState() => _UpiPaymentScreenState();
}

class _UpiPaymentScreenState extends State<UpiPaymentScreen> {
  Future<UpiResponse>? _transaction;
  final UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  TextStyle header = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle value = const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

  @override
  void initState() {
    _upiIndia
        .getAllUpiApps(mandatoryTransactionId: false)
        .then((value) => {
              setState(() {
                apps = value;
              })
            })
        .catchError((e) {
      print(e);
      apps = [];
    });
    super.initState();
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      merchantId: "M22FR6VSPR5HC",
      app: app,
      receiverUpiId: "",
      receiverName: '',
      transactionRefId: '',
      transactionNote: '',
      amount: 1,
    );
  }

  Widget displayUpiApps() {
    if (apps == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (apps!.isEmpty) {
      return Center(
        child: Text("No apps found to handle transaction"),
      );
    } else
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  _transaction = initiateTransaction(app);
                  setState(() {});
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
  }
  
  String _upiErrorHandler(error) {
    if (error is UpiIndiaAppNotInstalledException) {
      return "Requested app not installed on device";
    } else if (error is UpiIndiaUserCancelledException) {
      return "You cancelled the transaction";
    } else if (error is UpiIndiaNullResponseException) {
      return "Requested app didn't return any response";
    } else if (error is UpiIndiaInvalidParametersException) {
      return "Requested app cannot handle the transaction";
    } else {
      return "An unknown error has occurred";
    }
  }

  Widget _buildTransactionDetails(UpiResponse response) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Transaction ID: ${response.transactionId}", style: header),
        Text("Status: ${response.status}", style: header),
        Text("Approval Ref: ${response.approvalRefNo}", style: header),
        Text("Transaction Ref: ${response.transactionRefId}", style: header),
        // Add more details as needed
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UPI Payment Example'),
      ),
      body: Column(
        children: [
          displayUpiApps(),
          if (_transaction != null)
            FutureBuilder(
              future: _transaction,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(_upiErrorHandler(snapshot.error!));
                } else if (snapshot.hasData) {
                  return _buildTransactionDetails(snapshot.data as UpiResponse);
                } else {
                  return Container();
                }
              },
            ),
        ],
      ),
    );
  }
}

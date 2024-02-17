import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:phone_pe_pg/phone_pe_pg.dart';

class MyAppforpay extends StatefulWidget {
  const MyAppforpay({super.key});

  @override
  State<MyAppforpay> createState() => _MyAppState();
}

class _MyAppState extends State<MyAppforpay> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  PhonePePg pePg = PhonePePg(
    isUAT: false,
    saltKey: "84e1592e-9627-4411-a0ab-dd8f099863f0",
    saltIndex: '1',
  );

  PaymentRequest _paymentRequest({String? merchantCallBackScheme}) {
    String generateRandomString(int len) {
      const chars =
          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      Random rnd = Random();
      var s = String.fromCharCodes(Iterable.generate(
          len, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
      return s;
    }

    PaymentRequest paymentRequest = PaymentRequest(
      amount: 1,
      callbackUrl: 'https://www.google.com',
      deviceContext: DeviceContext.getDefaultDeviceContext(
          merchantCallBackScheme: merchantCallBackScheme),
      merchantId: "M22FR6VSPR5HC",
      merchantTransactionId: generateRandomString(10).toUpperCase(),
      merchantUserId: generateRandomString(8).toUpperCase(),
      mobileNumber: '8755910826',
    );
    return paymentRequest;
  }

  PaymentRequest upipaymentRequest(UpiAppInfo e,
          {String? merchantCallBackScheme}) =>
      _paymentRequest(merchantCallBackScheme: merchantCallBackScheme).copyWith(
          paymentInstrument: UpiIntentPaymentInstrument(
        targetApp: Platform.isAndroid ? e.packageName! : e.iOSAppName!,
      ));

  PaymentRequest paypageRequestModel({String? merchantCallBackScheme}) =>
      _paymentRequest(merchantCallBackScheme: merchantCallBackScheme).copyWith(
          redirectUrl: 'https://www.google.com',
          redirectMode: 'GET',
          paymentInstrument: PayPagePaymentInstrument());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: FutureBuilder<List<UpiAppInfo>?>(
            future: PhonePePg.getUpiApps(iOSUpiApps: [
              UpiAppInfo(
                appName: "PhonePe",
                packageName: "ppe",
                appIcon: Uint8List(0),
                iOSAppName: "PHONEPE",
                iOSAppScheme: 'ppe',
              ),
              UpiAppInfo(
                appName: "Google Pay",
                packageName: "gpay",
                appIcon: Uint8List(0),
                iOSAppName: "GPAY",
                iOSAppScheme: 'gpay',
              ),
              UpiAppInfo(
                appName: "Paytm",
                packageName: "paytmmp",
                appIcon: Uint8List(0),
                iOSAppName: "PAYTM",
                iOSAppScheme: 'paytmmp',
              ),
              UpiAppInfo(
                  appName: "PhonePe Simulator",
                  packageName: "ppemerchantsdkv1",
                  appIcon: Uint8List(0),
                  iOSAppScheme: 'ppemerchantsdkv1',
                  iOSAppName: "PHONEPE"),
              UpiAppInfo(
                appName: "PhonePe Simulator",
                packageName: "ppemerchantsdkv2",
                appIcon: Uint8List(0),
                iOSAppScheme: 'ppemerchantsdkv2',
                iOSAppName: "PHONEPE",
              ),
              UpiAppInfo(
                appName: "PhonePe Simulator",
                packageName: "ppemerchantsdkv3",
                iOSAppScheme: 'ppemerchantsdkv3',
                appIcon: Uint8List(0),
                iOSAppName: "PHONEPE",
              ),
            ]),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return ListView(children: [
                  ...snapshot.data!
                      .map(
                        (e) => ListTile(
                          onTap: () async {
                            pePg
                                .startUpiTransaction(
                                    paymentRequest: upipaymentRequest(e))
                                .then((response) {
                              if (response.status == UpiPaymentStatus.success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Transaction Successful")));
                              } else if (response.status ==
                                  UpiPaymentStatus.pending) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Transaction Pending")));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Transaction Failed")));
                              }
                            }).catchError((e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Transaction Failed")));
                            });
                          },
                          leading: Image.memory(
                            e.appIcon,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error);
                            },
                          ),
                          title: Text(e.appName),
                          subtitle: Text(e.packageName ?? e.iOSAppName!),
                        ),
                      )
                      .toList(),
                  ListTile(
                    title: const Text("Card/Net Banking"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => pePg.startPayPageTransaction(
                                    onPaymentComplete:
                                        (paymentResponse, paymentError) {
                                      Navigator.pop(context);
                                      if (paymentResponse != null &&
                                          paymentResponse.code ==
                                              PaymentStatus.success) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Transaction Successful")));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Transaction Failed")));
                                      }
                                    },
                                    paymentRequest: paypageRequestModel(),
                                  )));
                    },
                  )
                ]);
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }
}

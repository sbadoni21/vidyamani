import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:random_string/random_string.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/models/package_model.dart';
import 'package:vidyamani/models/upi_apps_model.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/services/data/subscription_service.dart';
import 'package:vidyamani/utils/static.dart';

final userProvider = Provider<User?>((ref) {
  return ref.watch(userStateNotifierProvider);
});

class PhonePayPayment extends ConsumerStatefulWidget {
  const PhonePayPayment({
    Key? key,
    required this.packageType, //gold or premium
    required this.packages,
  }) : super(key: key);
  final String packageType;
  final Packages packages;

  @override
  _PhonePayPaymentState createState() => _PhonePayPaymentState();
}

class _PhonePayPaymentState extends ConsumerState<PhonePayPayment> {
  String environment = 'PRODUCTION';
  String appId = 'null';
  String merchantId = "M22FR6VSPR5HC";
  bool enableLogging = true;
  String checksum = '';
  String saltIndex = '1';
  String saltKey = '84e1592e-9627-4411-a0ab-dd8f099863f0';
  String callback = "https://api.phonepe.com/apis/hermes";
  String body = "";
  Object result = "";
  String apiEndPoint = "/pg/v1/pay";
  getCheckSum() {
    final requestData = {
      "merchantId": merchantId,
      'merchantUserId': "Vidhyamani",
      "merchantTransactionId": randomAlphaNumeric(10),
      "amount": widget.packageType == 'gold'
          ? widget.packages.goldPackagePrice * 100
          : widget.packages.premiumPackagePrice * 100,
      "callbackUrl": callback,
      "mobileNumber": "9999999999",
      "paymentInstrument": {"type": "PAY_PAGE"}
    };
    String base64Body = base64.encode(utf8.encode(json.encode(requestData)));
    checksum =
        '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltIndex';
    return base64Body;
  }

  @override
  void initState() {
    super.initState;
    phonepeInit();
    body = getCheckSum().toString();
  }

  void addUserToDatabase(userid, contest) async {
    await SubscriptionService().changeUserType(userid, widget.packageType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBarBckBtn(),
        body: ListView(children: [
          widget.packageType == 'gold'
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: cardColor,
                    ),
                    width: double.infinity,
                    height: 250,
                    child: Stack(
                      children: [
                        Positioned(right: 0, child: Image.asset(logohalf)),
                        Positioned(
                          left: 20,
                          top: 36,
                          child: Text(
                            'Vidhyamani Plus',
                            style: myTextStylefontsize24BGCOLOR,
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 102,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 25,
                              ),
                              Text(
                                'Ad-free Content',
                                style: myTextStylefontsize16,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 168,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "₹",
                                style: myTextStylefontsize24BGCOLOR,
                              ),
                              Text(
                                "${widget.packages.goldPackagePrice}",
                                style: myTextStylefontsize24BGCOLOR,
                              ),
                              Text(
                                "/",
                                style: myTextStylefontsize24BGCOLOR,
                              ),
                              Text(
                                "month",
                                style: myTextStylefontsize14,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: bgColor,
                    ),
                    width: double.infinity,
                    height: 250,
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0,
                          child: Image.asset(
                            logohalf,
                            color: cardColor,
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 36,
                          child: Text(
                            'Vidhyamani Premium',
                            style: myTextStylefontsize24,
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 85,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 25,
                              ),
                              Text(
                                'Ad-free Content',
                                style: myTextStylefontsize16white,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 110,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 25,
                              ),
                              Text(
                                'Advanced Courses',
                                style: myTextStylefontsize16white,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 135,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 25,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Premium Content (Competitive exam ',
                                    style: myTextStylefontsize16white,
                                  ),
                                  Text(
                                    'content etc.)',
                                    style: myTextStylefontsize16white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 194,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "₹",
                                style: myTextStylefontsize24,
                              ),
                              Text(
                                "${widget.packages.premiumPackagePrice}",
                                style: myTextStylefontsize24,
                              ),
                              Text(
                                "/",
                                style: myTextStylefontsize24,
                              ),
                              Text(
                                "month",
                                style: myTextStylefontsize14White,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Checkout",
                          style: myTextStylefontsize20BGCOLOR,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Package",
                          style: myTextStylefontsize20BGCOLOR,
                        ),
                        Text(
                          widget.packageType == "gold" ? 'Gold' : 'Premium',
                          style: myTextStylefontsize20BGCOLOR,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: myTextStylefontsize20BGCOLOR,
                        ),
                        Text(
                          widget.packageType == "gold"
                              ? '₹ ${widget.packages.goldPackagePrice.toString()}'
                              : '₹ ${widget.packages.premiumPackagePrice.toString()}',
                          style: myTextStylefontsize20BGCOLOR,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 250,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white),
                              onPressed: () {
                                startPgTransaction();
                              },
                              child: Text(
                                  'Pay ${widget.packageType == "gold" ? widget.packages.goldPackagePrice.toString() : widget.packages.premiumPackagePrice.toString()}')),
                        ),
                      ],
                    )
                  ])),
        ]));
  }

  void phonepeInit() {
    PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
        .then((val) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $val';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void startPgTransaction() async {
    PhonePePaymentSdk.startTransaction(
            body, callback, checksum, 'com.phonepe.app')
        .then((response) => {
              setState(() {
                if (response != null) {
                  final User? user = ref.read(userProvider);
                  String status = response['status'].toString();
                  String error = response['error'].toString();
                  if (status == 'SUCCESS') {
                    result = "Flow Completed - status: $status";
                    if (user?.uid != null) {
                      if (widget.packageType == "gold") {
                        addUserToDatabase(user!.uid, "gold");
                      } else {
                        addUserToDatabase(user!.uid, "premium");
                      }
                    } else {
                      result = "User ID is null";
                    }
                  } else {
                    result =
                        "Flow Completed - Status: $status and Error: $error";
                  }
                } else {
                  result = "Flow Incomplete";
                }
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }
  

  void handleError(error) {
    setState(() {
      result = {error: error};
    });
  }
}

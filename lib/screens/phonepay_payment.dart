import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:vidyamani/components/topappbar_component.dart';
import 'package:vidyamani/models/package_model.dart';
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
  }) : super(key: key);
  final String packageType;

  @override
  _PhonePayPaymentState createState() => _PhonePayPaymentState();
}

class _PhonePayPaymentState extends ConsumerState<PhonePayPayment> {
  String environment = 'SANDBOX';
  String appId = '';
  String merchantId = "PGTESTPAYUAT";
  bool enableLogging = true;
  String checksum = '';
  String saltIndex = '1';
  String saltKey = '099eb0cd-02cf-4e2a-8aca-3e6c6aff0399';
  String callback = "https://webhook.site/3371683a-d392-4c4d-a147-795329f5a3ac";
  String body = "";
  Object result = "";
  String apiEndPoint = "/pg/v1/pay";
  late Packages packages;

  getCheckSum() {
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": "MT7850590068188104",
      "merchantUserId": "MUID123",
      "amount": widget.packageType == 'gold'
          ? packages.goldPackagePrice
          : packages.premiumPackagePrice,
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
        appBar: const CustomAppBar(),
        body: Stack(children: [
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
                          widget.packageType,
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
                              ? packages.goldPackagePrice.toString()
                              : packages.premiumPackagePrice.toString(),
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
                                  'Pay ${widget.packageType == "gold" ? packages.goldPackagePrice.toString() : packages.premiumPackagePrice.toString()}')),
                        ),
                      ],
                    )
                  ]))
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
    PhonePePaymentSdk.startTransaction(body, callback, checksum, "")
        .then((response) => {
              setState(() {
                if (response != null) {
                  String status = response['status'].toString();
                  String error = response['error'].toString();
                  if (status == 'SUCCESS') {
                    result = "Flow Completed - status: $status";
                    final User? user = ref.read(userProvider);

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
      // handleError(error)
      return <dynamic>{};
    });
  }

  void handleError(error) {
    setState(() {
      result = {error: error};
    });
  }
}

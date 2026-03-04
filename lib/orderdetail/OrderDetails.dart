import 'dart:io';

import 'package:debs_driver_app/Utils/color.dart';
import 'package:debs_driver_app/orderdetail/DeliveryTimerWidget.dart';
import 'package:debs_driver_app/orderdetail/HolderOrder.dart';
import 'package:debs_driver_app/orderdetail/PickupTimer.dart';
import 'package:debs_driver_app/orderdetail/controller/OrderDetailController.dart';
import 'package:debs_driver_app/orderdetail/model/CommonResponse.dart';
import 'package:debs_driver_app/orderdetail/model/DropOrderRequest.dart';
import 'package:debs_driver_app/orderdetail/model/OrderDetailsResponse.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends StatefulWidget {
  int? taskId, orderID;
  String? pickup_address;
  var pickupdetails;
  OrderDetails({super.key, this.taskId, this.orderID});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool pickup_visible = false;
  bool deliveryVisibile = false;
  OrderDetailResponse orderdetailResponse = OrderDetailResponse();
  CommonResponse driverReachResponse = CommonResponse();
  CommonResponse orderDeliveryResponse = CommonResponse();
  CommonResponse pickupOrderResponse = CommonResponse();
  bool showSignature = false;
  bool showDeliveryProof = false;
  int parseExpectedDeliveryTs(String ts) {
    return DateTime.parse(ts).millisecondsSinceEpoch;
  }

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );
  XFile? deliveryImage;

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  bool isloading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOrderDetails();
  }

  Future<void> pickDeliveryImage(VoidCallback refreshDialog) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        deliveryImage = image;
      });

      refreshDialog();
    }
  }

  void fetchOrderDetails() async {
    setState(() {
      isloading = true;
    });
    final response = await Orderdetailcontroller()
        .fetchOrderDetail(context, widget.orderID ?? 0, widget.taskId ?? 0);

    if (response != null) {
      setState(() {
        orderdetailResponse = response;
        isloading = false;
        if (orderdetailResponse.data!.pickupDetails != null) {
          setPickupData(orderdetailResponse);
        }

        if (orderdetailResponse.data!.dropOffDetails != null) {
          setDropOffData(orderdetailResponse.data!.dropOffDetails);
          deliveryVisibile = true;
          pickup_visible = false;
        } else {
          deliveryVisibile = false;
        }
      });
    } else {
      setState(() {
        isloading = false;  
      });
    }
  }

  Widget signatureView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // 🔑 IMPORTANT
      children: [
        const SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Signature(
            height: 190,
            controller: _signatureController,
            backgroundColor: Colors.transparent,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _signatureController.clear,
            child: const Text("Clear"),
          ),
        ),
      ],
    );
  }

  Widget deliveryProofView({required VoidCallback refreshDialog}) {
    return Column(
      mainAxisSize: MainAxisSize.min, // 🔑 IMPORTANT
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => pickDeliveryImage(refreshDialog),
          child: Container(
            height: 320,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: deliveryImage == null
                ? const Center(
                    child: Icon(Icons.camera_alt, size: 40),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(deliveryImage!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (orderdetailResponse.data == null) {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            fetchOrderDetails();
          },
          child: ListView(physics: AlwaysScrollableScrollPhysics(), children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
            ),
            Center(
              child: Text("No DATA"),
            ),
          ]),
        ),
      );
    } else {
      String dropOffAddress = "";
      var dropOffDetails = orderdetailResponse.data!.dropOffDetails!;
      if (dropOffDetails.area != null) {
        dropOffAddress = "Area - ${dropOffDetails.area}";
      }

      if (dropOffDetails.block != null && dropOffDetails.block!.isNotEmpty) {
        if (dropOffAddress.isNotEmpty) {
          dropOffAddress = "$dropOffAddress,Block - ${dropOffDetails.block}";
        } else {
          dropOffAddress = ",Block - ${dropOffDetails.block}";
        }
      }

      if (dropOffDetails.city != null && dropOffDetails.city!.isNotEmpty) {
        if (dropOffAddress.isNotEmpty) {
          dropOffAddress = "$dropOffAddress,City - ${dropOffDetails.city}";
        } else {
          dropOffAddress = "City - ${dropOffDetails.city}";
        }
      }

      if (dropOffDetails.street != null && dropOffDetails.street!.isNotEmpty) {
        if (dropOffAddress.isNotEmpty) {
          dropOffAddress = "$dropOffAddress,Street - ${dropOffDetails.street}";
        } else {
          dropOffAddress = "Street - ${dropOffDetails.street}";
        }
      }
      if (dropOffDetails.building != null &&
          dropOffDetails.building!.isNotEmpty) {
        if (dropOffAddress.isNotEmpty) {
          dropOffAddress =
              "$dropOffAddress,Building - ${dropOffDetails.building}";
        } else {
          dropOffAddress = "Building - ${dropOffDetails.building}";
        }
      }
      if (dropOffDetails.postalCode != null &&
          dropOffDetails.postalCode!.isNotEmpty) {
        if (dropOffAddress.isNotEmpty) {
          dropOffAddress =
              "$dropOffAddress,Postal Code - ${dropOffDetails.postalCode}";
        } else {
          dropOffAddress = "Postal Code - ${dropOffDetails.postalCode}";
        }
      }

      if (dropOffDetails.flat != null && dropOffDetails.flat!.isNotEmpty) {
        if (dropOffAddress.isNotEmpty) {
          dropOffAddress = "$dropOffAddress,Flat- ${dropOffDetails.flat}";
        } else {
          dropOffAddress = "Flat - ${dropOffDetails.flat}";
        }
      }

      if (dropOffDetails.houseNumber != null &&
          dropOffDetails.houseNumber!.isNotEmpty) {
        if (dropOffAddress.isNotEmpty) {
          dropOffAddress =
              "$dropOffAddress,House Number- ${dropOffDetails.houseNumber}";
        } else {
          dropOffAddress = "House Number - ${dropOffDetails.houseNumber}";
        }
      }

      if (dropOffDetails.floor != null && dropOffDetails.floor!.isNotEmpty) {
        if (dropOffAddress.isNotEmpty) {
          dropOffAddress = "$dropOffAddress,Floor- ${dropOffDetails.floor}";
        } else {
          dropOffAddress = "Floor - ${dropOffDetails.floor}";
        }
      }

      if (dropOffDetails.landmark != null &&
          dropOffDetails.landmark!.isNotEmpty) {
        if (dropOffAddress.isNotEmpty) {
          dropOffAddress =
              "$dropOffAddress,Landmark- ${dropOffDetails.landmark}";
        } else {
          dropOffAddress = "Floor - ${dropOffDetails.landmark}";
        }
      }
      final status = orderdetailResponse.data!.orderDetails!.status;

      final String? refId = orderdetailResponse.data?.orderDetails?.referenceId;
      final double amountDue =
          orderdetailResponse.data!.orderDetails!.amountDueOnDelivery ?? 0.0;

      final expectedTs =
          orderdetailResponse.data?.dropOffDetails?.expectedDeliveryTs;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text(
              "Order Details",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: ColorTheme().colorPrimary,
            iconTheme: IconThemeData(color: Colors.white),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios_new))),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (refId != null) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Refrenece #"),
                          SizedBox(
                            height: 10,
                          ),
                          Text(orderdetailResponse
                              .data!.orderDetails!.referenceId!
                              .toString())
                        ],
                      )
                    ],
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order #"),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.orderID.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                ),
              ),
              if (pickup_visible) ...[
                Card(
                  elevation: 5,
                  margin: EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pick Up",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    pickup_visible = !pickup_visible;
                                  });
                                },
                                icon: pickup_visible
                                    ? Icon(Icons.arrow_right)
                                    : Icon(Icons.arrow_drop_down))
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            height: 60,
                            "assets/images/logo.png",
                            fit: BoxFit.fill,
                          ),
                          Text(orderdetailResponse.data!.pickupDetails!.name
                              .toString()),
                          Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.call),
                            padding: EdgeInsets.only(right: 10),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          openGoogleMap(
                            orderdetailResponse.data!.pickupDetails!.latitude!,
                            orderdetailResponse.data!.pickupDetails!.longitude!,
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            height: 40,
                            width: 150,
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(80, 76, 175, 79),
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.green,
                                ),
                                Text(
                                  orderdetailResponse.data!.pickupDetails!.state
                                      .toString(),
                                  style: TextStyle(color: Colors.green),
                                )
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "Address : ${widget.pickup_address}",
                            style: TextStyle(fontSize: 15),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "",
                            style: TextStyle(fontSize: 18),
                          )),
                      Container(
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 20, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text("Status"),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 100,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Text(
                                          "${orderdetailResponse.data!.orderDetails!.status}")),
                                )
                              ],
                            ),
                            PickupTimer(
                              expectedPickupTime: orderdetailResponse
                                  .data!.pickupDetails!.expectedPickupReachTs!,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
              if (deliveryVisibile)
                Card(
                  elevation: 5,
                  margin: EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delivery",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    // deliveryVisibile = !deliveryVisibile;
                                  });
                                },
                                icon: deliveryVisibile
                                    ? Icon(Icons.arrow_right)
                                    : Icon(Icons.arrow_drop_down))
                          ],
                        ),
                      ),
                      Divider(
                        color: ColorTheme().lightgrey,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            height: 40,
                            "assets/images/logo.png",
                            fit: BoxFit.fill,
                          ),
                          Text(
                            "Customer : ${orderdetailResponse.data!.dropOffDetails!.name.toString()}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              openGoogleMap(
                                orderdetailResponse
                                    .data!.dropOffDetails!.latitude!,
                                orderdetailResponse
                                    .data!.dropOffDetails!.longitude!,
                              );
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                                height: 40,
                                width: 150,
                                margin: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(80, 76, 175, 79),
                                  border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.green,
                                    ),
                                    Text(
                                      "${orderdetailResponse.data!.dropOffDetails!.area}",
                                      style: TextStyle(color: Colors.green),
                                    )
                                  ],
                                )),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              makePhoneCall(
                                orderdetailResponse
                                    .data!.dropOffDetails!.mobile!,
                              );
                            },
                            icon: Icon(Icons.call),
                            padding: EdgeInsets.only(right: 0),
                          ),
                          IconButton(
                            onPressed: () {
                              openWhatsApp(
                                context: context,
                                phoneNumber: orderdetailResponse
                                    .data!.dropOffDetails!.mobile
                                    .toString(),
                              );
                            },
                            icon: Icon(Icons.chat, color: Colors.green),
                            padding: EdgeInsets.only(right: 0),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "Adress: $dropOffAddress",
                            style: TextStyle(fontSize: 18),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "Notes : ",
                            style: TextStyle(fontSize: 18),
                          )),
                      Container(
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 20, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Status"),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 100,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.orange),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Text(
                                    "${orderdetailResponse.data!.orderDetails!.status}",
                                    style: TextStyle(color: Colors.orange),
                                  )),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Payment"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: 100,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Center(
                                            child: Text(
                                          (orderdetailResponse
                                                          .data!
                                                          .orderDetails!
                                                          .amountDueOnDelivery ??
                                                      0) ==
                                                  0
                                              ? "Paid"
                                              : "Cash on Delivery",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            buildTimer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
        bottomNavigationBar: (status == "Assigned" ||
                status == "Picked Up" ||
                status == "Driver Reached")
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 8,
                      offset: Offset(0, -3),
                    )
                  ],
                ),
                margin: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// ✅ ONLY ASSIGNED CASE
                    if (status == "Assigned")
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            callDriverReachApi();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorTheme().colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Driver Reached",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      )
                    else if (status == "Driver Reached")
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            callPickupOrderApi();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorTheme().colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Pickup Order",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      )

                    /// ✅ ONLY PICKED UP CASE
                    else if (status == "Picked Up") ...[
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Holderorder(
                                orderID: widget.orderID,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Hold Order",
                          style: TextStyle(color: ColorTheme().colorPrimary),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: callDropOrderApi,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorTheme().colorPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          amountDue > 0
                              ? "DROP ORDER (${amountDue.toStringAsFixed(1)} KWD)"
                              : "DROP ORDER",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ],
                ),
              )
            : null,
      );
    }
  }

  Widget buildTimer() {
    final expectedTs =
        orderdetailResponse.data?.dropOffDetails?.expectedDeliveryTs;

    return expectedTs != null
        ? DeliveryTimerWidget(deliveryTime: expectedTs)
        : const SizedBox(
            height: 80,
            width: 80,
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
  }

  void setPickupData(OrderDetailResponse orderdetailResponse) {
    pickup_visible = true;
    widget.pickupdetails = orderdetailResponse.data!.pickupDetails!;
    if (widget.pickupdetails.area != null) {
      widget.pickup_address = "Area - ${widget.pickupdetails.area}";
    }
    if (widget.pickupdetails.block != null) {
      if (widget.pickup_address!.isNotEmpty) {
        widget.pickup_address =
            "${widget.pickup_address},Block -${widget.pickupdetails.block}";
      }
    } else {
      widget.pickup_address = "Block -${widget.pickupdetails.block}";
    }

    if (widget.pickupdetails.city != null) {
      if (widget.pickup_address!.isNotEmpty) {
        widget.pickup_address =
            "${widget.pickup_address},City - ${widget.pickupdetails.city}";
      } else {
        widget.pickup_address = "City - ${widget.pickupdetails.city}";
      }
    }

    if (widget.pickupdetails.street != null) {
      if (widget.pickup_address!.isNotEmpty) {
        widget.pickup_address =
            "${widget.pickup_address},Street - ${widget.pickupdetails.street}";
      } else {
        widget.pickup_address = "Street - ${widget.pickupdetails.street}";
      }
    }

    if (widget.pickupdetails.building != null) {
      if (widget.pickup_address!.isNotEmpty) {
        widget.pickup_address =
            "${widget.pickup_address},Building - ${widget.pickupdetails.building}";
      } else {
        widget.pickup_address = "Building - ${widget.pickupdetails.building}";
      }
    }

    if (widget.pickupdetails.pickupPostalCode != null) {
      if (widget.pickup_address!.isNotEmpty) {
        widget.pickup_address =
            "${widget.pickup_address},Postal code - ${widget.pickupdetails.pickupPostalCode}";
      } else {
        widget.pickup_address =
            "Postal code - ${widget.pickupdetails.pickupPostalCode}";
      }
    }

    if (widget.pickupdetails.flat != null) {
      if (widget.pickup_address!.isNotEmpty) {
        widget.pickup_address =
            "${widget.pickup_address},Flat - ${widget.pickupdetails.flat}";
      } else {
        widget.pickup_address = "Flat - ${widget.pickupdetails.flat}";
      }
    }

    if (widget.pickupdetails.houseNumber != null) {
      if (widget.pickup_address!.isNotEmpty) {
        widget.pickup_address =
            "${widget.pickup_address},House Number - ${widget.pickupdetails.houseNumber}";
      } else {
        widget.pickup_address =
            "House Number - ${widget.pickupdetails.houseNumber}";
      }
    }

    if (widget.pickupdetails.floor != null) {
      if (widget.pickup_address!.isNotEmpty) {
        widget.pickup_address =
            "${widget.pickup_address},Floor - ${widget.pickupdetails.floor}";
      } else {
        widget.pickup_address = "Floor - ${widget.pickupdetails.floor}";
      }
    }

    if (widget.pickupdetails.landmark != null) {
      if (widget.pickup_address!.isNotEmpty) {
        widget.pickup_address =
            "${widget.pickup_address},Landmark - ${widget.pickupdetails.landmark}";
      } else {
        widget.pickup_address = "Landmark - ${widget.pickupdetails.landmark}";
      }
    }

    // if (pickupdetails.avenue != null) {
    // if (widget.pickup_address!.isNotEmpty) {
    //   widget.pickup_address =
    //       "${widget.pickup_address},Avenue - ${pickupdetails.avenue}";
    // } else {
    //   widget.pickup_address = "Avenue - ${pickupdetails.avenue}";
    // }
    // }

    // String addressNote =  widget.pickupdetails?.instructions?.notes?.isNotEmpty == true
    //     ?  widget.pickupdetails!.instructions!.notes!
    //     : "No notes";
  }

  void setDropOffData(DropOffDetails? dropOffDetails) {}

  Future<void> callDropOrderApi() async {
    final orderDetails = orderdetailResponse.data!.orderDetails!;

    // 1️⃣ Signature required
    if (orderDetails.needSignature == true) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Signature"),
          content: SizedBox(
            width: double.maxFinite,
            height: 260, // 🔑 FIX: CONSTRAIN HEIGHT
            child: signatureView(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorTheme().colorPrimary),
              onPressed: () {
                Navigator.pop(context);
                if (orderDetails.needDeliveryProof == true) {
                  Future.microtask(() {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setDialogState) {
                            return AlertDialog(
                              backgroundColor: Colors.grey.shade100,
                              title: const Text("Delivery Proof"),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: deliveryProofView(
                                  refreshDialog: () => setDialogState(() {}),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: deliveryImage == null
                                      ? null
                                      : () {
                                          Navigator.pop(context);
                                          callOrderDeliveryWithProofSignature(
                                              context,
                                              widget.orderID!,
                                              deliveryImage,
                                              _signatureController,
                                              orderDetails
                                                  .amountDueOnDelivery!);
                                        },
                                  child: const Text("Confirm"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  });
                } else {
                  callDropOrderApiwithSignature(context, widget.orderID!,
                      _signatureController, orderDetails.amountDueOnDelivery!);
                }
              },
              child: const Text(
                "Confirm",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );

      return;
    } else if (orderDetails.needDeliveryProof == true) {
      Future.microtask(() {
        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setDialogState) {
                return AlertDialog(
                  backgroundColor: Colors.grey.shade100,
                  title: const Text("Delivery Proof"),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: deliveryProofView(
                      refreshDialog: () => setDialogState(() {}),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: deliveryImage == null
                          ? null
                          : () {
                              Navigator.pop(context);
                              callOrderDeliveryWithProofSignature(
                                  context,
                                  widget.orderID!,
                                  deliveryImage,
                                  _signatureController,
                                  orderDetails.amountDueOnDelivery!);
                            },
                      child: const Text("Confirm"),
                    ),
                  ],
                );
              },
            );
          },
        );
      });
    } else {
      // 3️⃣ Call API
      setState(() => isloading = true);

      CommonResponse? response;

      final double amountDue = orderDetails.amountDueOnDelivery ?? 0.0;

      if (amountDue > 0) {
        final request = DropOrderRequest(
          amountDueOnDelivery: amountDue,
        );

        response = await Orderdetailcontroller().callDropOrderwithAmountApi(
          context,
          widget.orderID!,
          request,
        );
      } else {
        response = await Orderdetailcontroller()
            .callDropOrderApi(context, widget.orderID!);
      }

      setState(() => isloading = false);

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? "Success")),
        );

        Navigator.pop(context, true); // 🔄 trigger reload
      }
    }
  }

  void callDriverReachApi() async {
    setState(() {
      isloading = true;
    });
    final response = await Orderdetailcontroller()
        .callDriverReachApi(context, widget.orderID ?? 0, widget.taskId ?? 0);

    if (response != null) {
      setState(() {
        driverReachResponse = response;
        isloading = false;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${pickupOrderResponse.message}")));
        fetchOrderDetails();
      });
    } else {
      setState(() {
        isloading = false;
      });
    }
  }

  void callPickupOrderApi() async {
    setState(() {
      isloading = true;
    });
    final response = await Orderdetailcontroller()
        .callPickupOrderApi(context, widget.orderID ?? 0, widget.taskId ?? 0);

    if (response != null) {
      setState(() {
        pickupOrderResponse = response;
        isloading = false;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${pickupOrderResponse.message}")));
        fetchOrderDetails();
      });
    } else {
      setState(() {
        isloading = false;
      });
    }
  }

  Future<void> openGoogleMap(double lat, double lng) async {
    final Uri uri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Maps not available")),
      );
    }
  }

  Future<CommonResponse?> callOrderDeliveryWithProofSignature(
      BuildContext context,
      int orderID,
      XFile? deliveryImage,
      SignatureController signature,
      double amountDue) async {
    setState(() => isloading = true);

    CommonResponse? response;

    final request = DropOrderRequest(
      amountDueOnDelivery: amountDue,
    );

    response = await Orderdetailcontroller().callDropOrderApiwithProofSignature(
      context,
      widget.orderID!,
      deliveryImage,
      signature,
      amountDue,
    );

    setState(() => isloading = false);

    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? "Success")),
      );

      Navigator.pop(context, true); // 🔄 trigger reload
    }
    return null;
  }

  Future<CommonResponse?> callOrderDeliveryWithProof(BuildContext context,
      int orderID, XFile? deliveryImage, double amountDue) async {
    setState(() => isloading = true);

    CommonResponse? response;

    if (amountDue > 0) {
      final request = DropOrderRequest(
        amountDueOnDelivery: amountDue,
      );

      response = await Orderdetailcontroller().callDropOrderApiwithProof(
          context, widget.orderID!, deliveryImage, amountDue);
    } else {
      response = await Orderdetailcontroller()
          .callDropOrderApi(context, widget.orderID!);
    }

    setState(() => isloading = false);

    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? "Success")),
      );

      Navigator.pop(context, true); // 🔄 trigger reload
      Navigator.pop(context, true); // 🔄 trigger reload
    }
    return null;
  }

  Future<CommonResponse?> callDropOrderApiwithSignature(BuildContext context,
      int i, SignatureController signatureController, double amountDue) async {
    setState(() => isloading = true);

    CommonResponse? response;

    final request = DropOrderRequest(
      amountDueOnDelivery: amountDue,
    );

    response = await Orderdetailcontroller().callDropOrderApiwithSignature(
        context, widget.orderID!, signatureController, amountDue);

    setState(() => isloading = false);

    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? "Success")),
      );

      Navigator.pop(context, true); // 🔄 trigger reload
    }
    return null;
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $uri');
    }
  }

  Future<void> openWhatsApp({
    required BuildContext context,
    required String phoneNumber, // e.g., "8089273918"
    String countryCode = "965", // default country code
  }) async {
    // Ensure full number with country code
    String phone = phoneNumber.startsWith(countryCode)
        ? phoneNumber
        : "$countryCode$phoneNumber";

    // WhatsApp URL
    final Uri whatsappUri =
        Uri.parse("https://api.whatsapp.com/send?phone=$phone");

    try {
      // Launch only in external app (WhatsApp)
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        // WhatsApp is not installed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("WhatsApp is not installed on this device.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error opening WhatsApp: $e")),
      );
    }
  }
}

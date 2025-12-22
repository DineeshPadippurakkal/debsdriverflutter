import 'dart:ffi';

import 'package:debs_driver_app/Utils/color.dart';
import 'package:debs_driver_app/orderdetail/controller/OrderDetailController.dart';
import 'package:debs_driver_app/orderdetail/model/OrderDetailsResponse.dart';
import 'package:debs_driver_app/orders/OrderListResponse.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  int? taskId, orderID;
  OrderDetails({this.taskId, this.orderID});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool pickup_visible = true;
    OrderDetailResponse orderdetailResponse =OrderDetailResponse();

    bool isloading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOrderDetails();
  }

  void fetchOrderDetails() async {
    setState(() {
      isloading = true;
    });
    final response = await Orderdetailcontroller()
        .fetchOrderDetail(context, widget.orderID ?? 0, widget.taskId ?? 0);

    if (response != null) {
      setState(() {
        orderdetailResponse=response;
        isloading = false;
      });
    }else{
setState(() {
  isloading = false;
});
    }
  }

  @override
  Widget build(BuildContext context) {
    if(isloading ){
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  else  if(orderdetailResponse.data == null){
 return Scaffold(
   body: RefreshIndicator(
    onRefresh: () async{
     fetchOrderDetails();
    },
     child: ListView(
       physics: AlwaysScrollableScrollPhysics(),
       children:[
        SizedBox(height: MediaQuery.of(context).size.height /2.5,),
         Center(
        child: Text("No DATA"),
       ),]
     ),
   ),
 );
    }
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Refrenece #"),
                      SizedBox(
                        height: 10,
                      ),
                      Text("test data")
                    ],
                  ),
                  Column(
                    children: [
                      Text("Order #"),
                      SizedBox(
                        height: 10,
                      ),
                      Text(widget.orderID.toString())
                    ],
                  )
                ],
              ),
            ),
            Card(
              elevation: 5,
              margin: EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
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
                  if (pickup_visible) ...[
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
                        Text("${orderdetailResponse.data!.pickupDetails!.name.toString()}"),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.call),
                          padding: EdgeInsets.only(right: 10),
                        )
                      ],
                    )
                  ],
                  SizedBox(
                    height: 10,
                  ),
                  Container(
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
                            "Asimah ",
                            style: TextStyle(color: Colors.green),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Notes : theseses",
                        style: TextStyle(fontSize: 18),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Area : theseses",
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
                              child: Center(child: Text("Assigned")),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(20)),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text("Expected Pick up"),
                            SizedBox(
                              height: 10,
                            ),
                            CircularProgressIndicator(
                              backgroundColor: Colors.blue,
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Card(
              elevation: 5,
              margin: EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
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
                                pickup_visible = !pickup_visible;
                              });
                            },
                            icon: pickup_visible
                                ? Icon(Icons.arrow_right)
                                : Icon(Icons.arrow_drop_down))
                      ],
                    ),
                  ),
                  if (pickup_visible) ...[
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
                        Text(orderdetailResponse.data!.dropOffDetails!.name.toString()),
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
                    Container(
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
                              "Asimah ",
                              style: TextStyle(color: Colors.green),
                            )
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Notes : theseses",
                          style: TextStyle(fontSize: 18),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Area : theseses",
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
                                child: Center(child: Text("Assigned")),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(20)),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text("Expected Pick up"),
                              SizedBox(
                                height: 10,
                              ),
                              CircularProgressIndicator(
                                backgroundColor: Colors.blue,
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ]
                ],
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: false,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.15),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: Offset(0, -3),
                )
              ]),
          margin: EdgeInsets.only(right: 0, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text(
                  "Hold",
                  style: TextStyle(color: ColorTheme().colorPrimary),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorTheme().colorPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child:
                    Text("Drop Order", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(
                width: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

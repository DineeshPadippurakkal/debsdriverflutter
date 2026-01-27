import 'package:debs_driver_app/OrderHistory/controller/OrderHistoryController.dart';
import 'package:debs_driver_app/OrderHistory/model/OrderHistoryRes.dart';
import 'package:debs_driver_app/Utils/color.dart';
import 'package:flutter/material.dart';

import 'OrderHistoryItem.dart';

class Orderhistory extends StatefulWidget {
  const Orderhistory({super.key});

  @override
  State<Orderhistory> createState() => _OrderhistoryState();
}

class _OrderhistoryState extends State<Orderhistory> {
  OrderHistoryRes orderHistoryRes = OrderHistoryRes();

  // late Future<OrderHistoryRes?> orderHistoryFuture;
  int offset = 0, limit = 0;

  @override
  void initState() {
    super.initState();

    fetchInitialOrders();
    // orderHistoryFuture =
    //     OrderHistoryController().fetchORderHistory(context, limit, offset);
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 50) {
        loadMoreOrders();
      }
    });
  }

  // void loadMore(int limit, int offset) {
  //   orderHistoryFuture =
  //       OrderHistoryController().fetchORderHistory(context, limit, offset);
  // }

  bool initialLoading = true;
  bool isLoadingMore = false;
  void fetchInitialOrders() async {
    final response = await OrderHistoryController()
        .fetchORderHistory(context, limit, offset);

    if (response != null) {
      setState(() {
        allOrders = response.data ?? [];
        offset = response.links?.offset ?? 0;
        initialLoading = false;
      });
    }
  }

  void loadMoreOrders() async {
    if (isLoadingMore) return;

    setState(() => isLoadingMore = true);

    final response = await OrderHistoryController()
        .fetchORderHistory(context, limit, offset);

    if (response != null) {
      setState(() {
        allOrders.addAll(response.data ?? []);
        offset = response.links?.offset ?? 0;
        isLoadingMore = false;
      });
    }
  }

  List<Data> allOrders = [];
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Order History",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorTheme().colorPrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: initialLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: scrollController,
                    itemCount: allOrders.length + 1,
                    itemBuilder: (context, index) {
                      if (index == allOrders.length) {
                        return isLoadingMore
                            ? Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child:
                                      CircularProgressIndicator(strokeWidth: 3),
                                ),
                              )
                            : SizedBox.shrink();
                      }

                      final order = allOrders[index];

                      return OrderHistoryItem(
                        logo: order.logo ?? "",
                        date: "${order.date}, ${order.time}",
                        itemName: order.orderFrom ?? "",
                        location: order.areaName ?? "",
                        orderNumber: order.order.toString(),
                        paymentStatus: order.paymentTypeLabel ?? "",
                        paymentAmount: "${order.paymentAmount}",
                        orderStatus: order.orderStatusLabel ?? "",
                      );
                    },
                  ),
          )
//           Expanded(
//             child: FutureBuilder(
//               future: orderHistoryFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   print ("this is the issue");
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError) {
//                   return Center(child: Text("Error occurred"));
//                 }

//                 if (!snapshot.hasData || snapshot.data == null) {
//                   return Center(child: Text("No orders found"));
//                 }

//                 final orders = snapshot.data!.data ?? [];
//                 final link = snapshot.data!.links;
//                 offset = link?.offset ?? 0;
//                 limit = link?.limit ?? 0;

//                 return ListView.builder(
//                   controller: scrollController,shrinkWrap: true,
// physics: AlwaysScrollableScrollPhysics(),

//                   itemCount: orders.length + 1,
//                   itemBuilder: (context, index) {
//                    if (index == orders.length) {
//   return isLoadingMore
//       ? Padding(
//           padding: EdgeInsets.symmetric(vertical: 16),
//           child: Align(
//             alignment: Alignment.center,
//             child: SizedBox(
//               height: 30,
//               width: 30,
//               child: CircularProgressIndicator(strokeWidth: 3),
//             ),
//           ),
//         )
//       : SizedBox.shrink();
// }

//                     final order = orders[index];

//                     return OrderHistoryItem(
//                       logo: order.logo ?? "",
//                       date: "${order.date} , ${order.time.toString()}" ?? "",
//                       itemName: order.orderFrom ?? "",
//                       location: order.areaName ?? "",
//                       orderNumber: order.order.toString(),
//                       paymentStatus: order.paymentTypeLabel ?? "",
//                       paymentAmount: "${order.paymentAmount}",
//                       orderStatus: order.orderStatusLabel ?? "",
//                     );
//                   },
//                 );
//               },
//             ),
//           )
        ],
      ),
    );
  }

  void fetchOrderDetails() async {
    final response =
        await OrderHistoryController().fetchORderHistory(context, 0, 0);
    if (response != null) {
      setState(() {
        orderHistoryRes = response;
      });
    } else {}
  }
}

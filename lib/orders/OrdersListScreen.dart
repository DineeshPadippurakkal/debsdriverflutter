import 'package:debs_driver_app/Utils/color.dart';
import 'package:debs_driver_app/orderdetail/OrderDetails.dart';
import 'package:debs_driver_app/orders/OrderListController.dart';
import 'package:debs_driver_app/orders/OrderListResponse.dart';
import 'package:debs_driver_app/provider/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:provider/provider.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  final Orderlistcontroller _orderlistcontroller = Orderlistcontroller();
  OrderListResponse? response;

  bool isloading = false;
  @override
  void initState() {
    super.initState();
    getOrders();
  }

  Future<void> getOrders() async {
    try {
      setState(() {
        isloading = true;
      });

      final data = await _orderlistcontroller.getOrderList(context);
      if (data != null) {
        setState(() {
          isloading = false;
          response = data;
        });
      } else {
        setState(() {
          isloading = false;
        });
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        getOrders();
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 244, 244),
        body: RefreshIndicator(
          onRefresh: () async {
            getOrders();
          },
          child: isloading
              ? Center(child: CircularProgressIndicator())
              : response == null ||
                      response!.data?.tasks == null ||
                      response!.data!.tasks!.isEmpty
                  ? Center(
                      child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: ColorTheme().colorPrimary),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text("No Orders")))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: response!.data!.tasks!.length,
                      itemBuilder: (context, index) {
                        final task = response!.data!.tasks![index];
                        final pickup = task.pickupDetails!;
                        final isActive = task.isActive ?? false;
                        final isMultiple = task.isMultiple ?? false;
                        final orders = task.orders ?? [];

                        // 🔹 Define color palette based on active/inactive state
                        final Color textColor =
                            isActive ? Colors.black : Colors.grey;
                        final Color iconColor =
                            isActive ? Colors.redAccent : Colors.grey;
                        final Color borderColor =
                            isActive ? Colors.blue : Colors.grey;
                        final Color statusColor =
                            isActive ? Colors.blue : Colors.grey;
                        final Color bgColor =
                            isActive ? Colors.white : Colors.grey.shade200;
                        final Color boxColor = isActive
                            ? Colors.blue.shade50
                            : Colors.grey.shade300;

                        return Consumer<NotificationProvider>(
                            builder: (context, provider, data) {
                          return GestureDetector(
                            onTap: () {
                              print("task id = ${task.taskId}");
                              print("order id = ${orders.first.id}");
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => OrderDetails(
                                     taskId:  task.taskId,orderID:  orders.first.id)));
                            },
                            child: Card(
                              color: bgColor,
                              elevation: isActive ? 5 : 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Stack(
                                children: [
                                  Opacity(
                                    opacity: provider.Messagement ? .1 : 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // 🔹 Header Row
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: NetworkImage(
                                                      pickup.logo ?? ""),
                                                  onBackgroundImageError:
                                                      (_, __) {},
                                                  child: pickup.logo != null ||
                                                          pickup
                                                              .logo!.isNotEmpty
                                                      ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          child: Image.network(
                                                            pickup.logo!,
                                                            width: 50,
                                                            height: 50,
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (context,
                                                                    error,
                                                                    stackTrace) =>
                                                                Image.asset(
                                                              'assets/images/supplier.png',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        )
                                                      : Image.asset(
                                                          'assets/images/supplier.png',
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    pickup.name ?? "",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.call,
                                                      color: isActive
                                                          ? Colors.green
                                                          : Colors.grey),
                                                  onPressed: isActive
                                                      ? () {
                                                          final phone =
                                                              pickup.mobile ??
                                                                  "";
                                                          if (phone
                                                              .isNotEmpty) {
                                                            launchUrl(Uri.parse(
                                                                "tel:$phone"));
                                                          }
                                                        }
                                                      : null,
                                                )
                                              ],
                                            ),
                                          ),

                                          const Divider(
                                              color: Color.fromARGB(
                                                  255, 208, 208, 208)),

                                          // 🔹 Location + Status
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: isActive
                                                        ? Colors.grey[200]
                                                        : Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.location_on,
                                                          color: iconColor,
                                                          size: 18),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        pickup.area ?? "",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: textColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              if (orders.isNotEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12, right: 12),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: boxColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      border: Border.all(
                                                          color: borderColor),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    child: Text(
                                                      orders.first.status ?? "",
                                                      style: TextStyle(
                                                        color: statusColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),

                                          const SizedBox(height: 8),

                                          // 🔹 SINGLE ORDER
                                          if (!isMultiple &&
                                              orders.isNotEmpty) ...[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 2),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Order #${orders.first.id ?? ''}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                        color: textColor),
                                                  ),
                                                  // Text(
                                                  //   orders.first.status ?? "",
                                                  //   style: TextStyle(
                                                  //       color: statusColor,
                                                  //       fontWeight: FontWeight.w600),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 2),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                // children: [
                                                //   Text(orders.first.area ?? "",
                                                //       style: TextStyle(color: textColor)),
                                                //   Text("${orders.first.amount ?? 0} KWD",
                                                //       style: TextStyle(color: textColor)),
                                                // ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12,
                                                  left: 12,
                                                  right: 12,
                                                  top: 4),
                                              child: Text(
                                                "Date: ${orders.first.day ?? ''}, ${orders.first.date ?? ''}, ${orders.first.time ?? ''}",
                                                style:
                                                    TextStyle(color: textColor),
                                              ),
                                            ),
                                          ],

                                          // 🔹 MULTIPLE ORDERS
                                          if (isMultiple &&
                                              orders.isNotEmpty) ...[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12,
                                                  right: 12,
                                                  bottom: 4),
                                              child: Text(
                                                "Task ID #${task.taskId ?? ''}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                    color: textColor),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12,
                                                  right: 12,
                                                  bottom: 8),
                                              child: Text(
                                                "Date: ${orders.first.day ?? ''}, ${orders.first.date ?? ''}, ${orders.first.time ?? ''}",
                                                style:
                                                    TextStyle(color: textColor),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              child: Column(
                                                children: orders.map((order) {
                                                  final orderActive =
                                                      order.isActive ?? false;
                                                  final Color oText =
                                                      orderActive
                                                          ? Colors.black
                                                          : Colors.grey;
                                                  final Color oBox = orderActive
                                                      ? Colors.white
                                                      : Colors.grey.shade200;
                                                  final Color oBorder =
                                                      orderActive
                                                          ? Colors.blue
                                                          : Colors.grey;

                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  OrderDetails(taskId: 
                                                                      task.taskId,orderID: 
                                                                      orders
                                                                          .first
                                                                          .id)));
                                                },
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 4),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      decoration: BoxDecoration(
                                                        color: oBox,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                            color: oBorder),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Order #${order.id ?? ''}",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color:
                                                                        oText),
                                                              ),
                                                              Text(
                                                                order.status ??
                                                                    "",
                                                                style: TextStyle(
                                                                    color:
                                                                        oBorder,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 6),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  order.area ??
                                                                      "",
                                                                  style: TextStyle(
                                                                      color:
                                                                          oText)),
                                                              Text(
                                                                  "${order.amount ?? 0} KWD",
                                                                  style: TextStyle(
                                                                      color:
                                                                          oText)),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (provider.Messagement)
                                    Positioned(
                                        bottom: 0,
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  provider
                                                      .messageaccepted(false);
                                                },
                                                child: Text("data")))),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    ),
        ),
      ),
    );
  }
}

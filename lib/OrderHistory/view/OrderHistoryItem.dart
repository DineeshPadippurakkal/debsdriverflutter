import 'package:debs_driver_app/Utils/color.dart';
import 'package:flutter/material.dart';

class OrderHistoryItem extends StatelessWidget {
  final String logo;
  final String date;
  final String itemName;
  final String location;
  final String orderNumber;
  final String paymentStatus;
  final String paymentAmount;
  final String orderStatus;

  const OrderHistoryItem({
    super.key,
    required this.logo,
    required this.date,
    required this.itemName,
    required this.location,
    required this.orderNumber,
    required this.paymentStatus,
    required this.paymentAmount,
    required this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8,left: 12,right: 12,bottom: 8),
      child: Card(
        color: Colors.white,
        elevation: 3,
        shadowColor: Colors.grey.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(logo),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Details Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ORDER NUMBER + STATUS (Row)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Order # ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              orderNumber,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        Container( padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(

                            color:orderStatus =="Delivered" ? ColorTheme().greenLight : orderStatus=="Cancelled" ?ColorTheme().ligtred :ColorTheme().greenLight  ,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            orderStatus,
                            style: TextStyle(
                              fontSize: 13,
                              color:orderStatus =="Delivered" ? ColorTheme().green : orderStatus=="Cancelled" ?ColorTheme().red :ColorTheme().greenLight ,
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 5),

                    /// DATE
                    Text(
                      date ,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 5),

                    /// ITEM NAME
                    Text(
                      itemName,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 5),

                    /// LOCATION WITH ICON
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 18, color: Colors.red),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 5),

                    /// PAYMENT AMOUNT + STATUS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          paymentAmount,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            paymentStatus,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
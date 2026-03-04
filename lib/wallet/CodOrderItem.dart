import 'package:flutter/material.dart';

class CodOrderItem extends StatelessWidget {
  final String logoUrl;
  final String orderFrom;
  final String orderNumber;
  final String date;
  final String amount;

  const CodOrderItem({
    super.key,
    required this.logoUrl,
    required this.orderFrom,
    required this.orderNumber,
    required this.date,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        
      child: Padding(
        
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Image.network(
              logoUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return SizedBox(
                  width: 50,
                  height: 50, 
                  child:   Image.asset("assets/images/logo.png"),
                     
                );
              },
            ),
            const SizedBox(width: 16),

            // Order info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderFrom,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Order #$orderNumber",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Amount
            Text(
              amount,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.green, // or red for debits
              ),
            ),
            
          ],
          
        ),
        
      ),
    );
       

  }
}

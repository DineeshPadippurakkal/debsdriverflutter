class DropOrderRequest {
  final double amountDueOnDelivery;

  DropOrderRequest({
    required this.amountDueOnDelivery,
  });

  Map<String, dynamic> toJson() {
    return {
      "amount": amountDueOnDelivery,
    };
  }
} 
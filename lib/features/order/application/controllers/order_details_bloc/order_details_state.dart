part of 'order_details_bloc.dart';

class OrderDetailsState extends Equatable {
  const OrderDetailsState(
      {required this.orderDetails, required this.deliveryProof, required this.signatureProof});
  final DataLoadState<OrderData> orderDetails;
  final Option<File> deliveryProof;
  final Option<File> signatureProof;

  factory OrderDetailsState.initial() {
    return OrderDetailsState(
        orderDetails: const DataLoadState.initial(),
        deliveryProof: const None(),
        signatureProof: const None());
  }

  @override
  List<Object?> get props => [orderDetails, deliveryProof, signatureProof];

  OrderDetailsState copyWith({
    DataLoadState<OrderData>? orderDetails,
    Option<File>? deliveryProof,
    Option<File>? signatureProof,
  }) {
    return OrderDetailsState(
      orderDetails: orderDetails ?? this.orderDetails,
      deliveryProof: deliveryProof ?? this.deliveryProof,
      signatureProof: signatureProof ?? this.signatureProof,
    );
  }
}

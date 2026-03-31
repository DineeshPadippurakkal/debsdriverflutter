part of 'order_details_bloc.dart';

class OrderDetailsState extends Equatable {
  const OrderDetailsState({required this.orderDetails});
  final DataLoadState<OrderData> orderDetails;

  factory OrderDetailsState.initial() {
    return OrderDetailsState(orderDetails: DataLoadState.initial());
  }

  @override
  List<Object?> get props => [orderDetails];

  OrderDetailsState copyWith({
    DataLoadState<OrderData>? orderDetails,
  }) {
    return OrderDetailsState(
      orderDetails: orderDetails ?? this.orderDetails,
    );
  }
// copyWith method is not needed here as there is only one property and it can be directly set when emitting new states.




}

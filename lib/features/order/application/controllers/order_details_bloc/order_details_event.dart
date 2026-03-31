part of 'order_details_bloc.dart';

abstract class OrderDetailsEvent extends Equatable {
  const OrderDetailsEvent();
}

class OrderDetailsLoaded extends OrderDetailsEvent {
  const OrderDetailsLoaded();

  @override
  List<Object> get props => [];
}

class DriverReached extends OrderDetailsEvent {
  const DriverReached();

  @override
  List<Object> get props => [];
}

class OrderPickedUp extends OrderDetailsEvent {
  const OrderPickedUp();

  @override
  List<Object> get props => [];
}

class OrderDropped extends OrderDetailsEvent {
  const OrderDropped();

  @override
  List<Object> get props => [];
}

class OrderDroppedWithAmount extends OrderDetailsEvent {
  final double amountDueOnDelivery;

  const OrderDroppedWithAmount(this.amountDueOnDelivery);

  @override
  List<Object> get props => [amountDueOnDelivery];
}

class OrderDroppedWithProof extends OrderDetailsEvent {
  final double? amountDueOnDelivery;
  const OrderDroppedWithProof({this.amountDueOnDelivery});

  @override
  List<Object?> get props => [amountDueOnDelivery];
}

class DeliveryProofPicked extends OrderDetailsEvent {
  final File proof;

  const DeliveryProofPicked(this.proof);
  @override
  List<Object> get props => [proof];
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:debs_driver_app/core/application/controllers/base_controller.dart';
import 'package:debs_driver_app/core/application/controllers/states/app_state.dart';
import 'package:debs_driver_app/core/application/controllers/view_contracts/view_contract.dart';
import 'package:debs_driver_app/core/domain/failure/exception.dart';
import 'package:debs_driver_app/features/order/application/order_details_args.dart';
import 'package:debs_driver_app/features/order/domain/entities/order_details.dart';
import 'package:debs_driver_app/features/order/domain/repos/orders_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'order_details_event.dart';
part 'order_details_state.dart';

abstract class OrderDetailsViewContract extends ViewContract {
  void handleDriverReached(Either<AppException, Unit> result);
  void handlePickedUp(Either<AppException, Unit> result);
  void handleDropOrder(Either<AppException, Unit> result);
  void handleDropOrderWithProof(Either<AppException, Unit> result);
  void handleDropOrderWithAmount(Either<AppException, Unit> result);
}

@Injectable()
class OrderDetailsBloc
    extends ViewContractBloc<OrderDetailsEvent, OrderDetailsState, OrderDetailsViewContract> {
  final OrdersRepo _repo;
  final OrderDetailsArguments arguments;

  OrderDetailsBloc(this._repo, @factoryParam this.arguments) : super(OrderDetailsState.initial()) {
    on<OrderDetailsLoaded>(_onOrderDetailsLoaded);
    on<DriverReached>(_onDriverReached);
    on<OrderPickedUp>(_onOrderPickedUp);
    on <OrderDropped>(_onOrderDropped);
    on<OrderDroppedWithAmount>(_onOrderDroppedWithAmount);
    on<OrderDroppedWithProof>(_onOrderDroppedWithProof);

  }

  Future<void> _onOrderDetailsLoaded(
      OrderDetailsLoaded event, Emitter<OrderDetailsState> emit) async {
    final result = await _repo.getOrderDetails(arguments.orderID!, arguments.taskId!);

    result.fold(
      (failure) => emit(state.copyWith(orderDetails: DataLoadState.error(failure))),
      (orderDetails) => emit(state.copyWith(orderDetails: DataLoadState.loaded(orderDetails))),
    );
  }

  Future<void> _onDriverReached(DriverReached event, Emitter<OrderDetailsState> emit) async {
    final result = await _repo.reachLocation(arguments.orderID!, arguments.taskId!);
    viewContract.handleDriverReached(result);
  }

  Future<void> _onOrderPickedUp(OrderPickedUp event, Emitter<OrderDetailsState> emit) async {
    final result = await _repo.pickupOrder(arguments.orderID!, arguments.taskId!);
    viewContract.handleDriverReached(result);
  }

  Future<void> _onOrderDropped(OrderDropped event, Emitter<OrderDetailsState> emit) async {
    final result = await _repo.dropOrder(arguments.orderID!);
    viewContract.handleDropOrder(result);
  }

  Future<void> _onOrderDroppedWithAmount(OrderDroppedWithAmount event, Emitter<OrderDetailsState> emit) async {
    final result = await _repo.dropOrderWithAmount(arguments.orderID!, event.amountDueOnDelivery);
    viewContract.handleDropOrderWithAmount(result);
  }

  Future<void> _onOrderDroppedWithProof(OrderDroppedWithProof event, Emitter<OrderDetailsState> emit) async {
    final result = await _repo.dropOrderWithProof(arguments.orderID!, amountDue: event.amountDueOnDelivery);
    viewContract.handleDropOrderWithProof(result);
  }



}

import 'package:debs_driver_app/core/domain/failure/exception.dart';
import 'package:equatable/equatable.dart';

sealed class DataLoadState<T extends Object?> extends Equatable {
  const DataLoadState();

  const factory DataLoadState.loading() = DataLoadLoadingState;

  factory DataLoadState.loaded(T data) = DataLoadLoadedState<T>;

  bool get isLoaded => this is DataLoadLoadedState<T>;

  bool get isLoading => this is DataLoadLoadingState<T>;

  bool get isError => this is DataLoadErrorState<T>;

  bool get isEmpty => this is DataLoadEmptyState<T>;

  bool get isInitial => this is DataLoadInitialState<T>;

  T? get loadedData =>
      this is DataLoadLoadedState<T> ? (this as DataLoadLoadedState<T>).data : null;

  const factory DataLoadState.error([AppException? err]) = DataLoadErrorState;

  const factory DataLoadState.empty() = DataLoadEmptyState;

  const factory DataLoadState.initial() = DataLoadInitialState;
}

class DataLoadEmptyState<T extends Object?> extends DataLoadState<T> {
  const DataLoadEmptyState();

  @override
  List<Object?> get props => [];
}

class DataLoadInitialState<T extends Object?> extends DataLoadState<T> {
  const DataLoadInitialState();

  @override
  List<Object?> get props => [];
}

class DataLoadLoadingState<T extends Object?> extends DataLoadState<T> {
  const DataLoadLoadingState();

  @override
  List<Object?> get props => [];
}

class DataLoadLoadedState<T extends Object?> extends DataLoadState<T> {
  final T data;

  const DataLoadLoadedState(this.data);

  @override
  List<Object?> get props => [data];
}

class DataLoadErrorState<T extends Object?> extends DataLoadState<T> {
  final AppException? err;

  const DataLoadErrorState([this.err]);

  @override
  List<Object?> get props => [err];
}

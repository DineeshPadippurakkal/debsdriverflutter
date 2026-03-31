import 'package:equatable/equatable.dart';

class Price extends Equatable {
  const Price(this.value);

  final num value;


  bool get isZero => value == 0;

  @override
  List<Object?> get props => [value];

  // override +

  Price operator +(Price other) {
    return Price(value + other.value);
  }

  Price operator -(Price other) {
    return Price(value - other.value);
  }

  Price operator *(int multiplier) {
    return Price(value * multiplier);
  }

  Price operator /(int divisor) {
    return Price(value / divisor);
  }
}

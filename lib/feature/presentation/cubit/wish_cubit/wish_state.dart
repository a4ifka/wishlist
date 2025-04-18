part of 'wish_cubit.dart';

sealed class WishState extends Equatable {
  const WishState();

  @override
  List<Object> get props => [];
}

class WishInitial extends WishState {}

class WishLoading extends WishState {}

class WishStart extends WishState {}

class WishesSuccess extends WishState {}

class WishesLoaded extends WishState {
  final List<WishEntity> wishes;

  const WishesLoaded({required this.wishes});

  @override
  List<Object> get props => [wishes];
}

class WishesGetCountBooking extends WishState {
  final int count;

  const WishesGetCountBooking({required this.count});

  @override
  List<Object> get props => [count];
}

class WishesGetCountCompleted extends WishState {
  final int count;

  const WishesGetCountCompleted({required this.count});

  @override
  List<Object> get props => [count];
}

class WishGetLoaded extends WishState {
  final WishEntity wish;

  const WishGetLoaded({required this.wish});

  @override
  List<Object> get props => [wish];
}

class WishLoaded extends WishState {
  final List<Map<String, dynamic>> wish;

  const WishLoaded({required this.wish});

  @override
  List<Object> get props => [wish];
}

class WishOperationInProgress extends WishState {}

class WishOperationSuccess extends WishState {}

class WishError extends WishState {
  final String message;

  const WishError({required this.message});

  @override
  List<Object> get props => [message];
}

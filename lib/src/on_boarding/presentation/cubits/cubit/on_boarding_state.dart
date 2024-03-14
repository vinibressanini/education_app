part of 'on_boarding_cubit.dart';

sealed class OnBoardingState extends Equatable {
  const OnBoardingState();

  @override
  List<Object> get props => [];
}

final class OnBoardingInitial extends OnBoardingState {
  const OnBoardingInitial();
}

final class CachingFirstTimer extends OnBoardingState {
  const CachingFirstTimer();
}

final class CheckingIfUserIsFirstTimer extends OnBoardingState {
  const CheckingIfUserIsFirstTimer();
}

final class UserCached extends OnBoardingState {
  const UserCached();
}

final class OnBoardingStatus extends OnBoardingState {
  const OnBoardingStatus({required this.isUserFirstTimer});

  final bool isUserFirstTimer;

  @override
  List<bool> get props => [isUserFirstTimer];
}

final class OnBoardingError extends OnBoardingState {
  const OnBoardingError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}

abstract class AppState {}

class IntiAppState extends AppState {}

class NewsLoadState extends AppState {}

class NewsDoneState extends AppState {}

class NewsErrorState extends AppState {
  final String error;
  NewsErrorState(this.error);
}

class LoadingState extends AppState {}

class FinalResultState extends AppState {}

class ModelLoadedSTate extends AppState {}

class ClassifyImageState extends AppState {}

class PickedImageState extends AppState {}

class ClearState extends AppState {}

class SignUpLoadingState extends AppState {}

class SignUpDoneState extends AppState {}

class SignUpErrorState extends AppState {
  final String error;

  SignUpErrorState({required this.error});
}

class SignInLoadingState extends AppState {}

class SignInDoneState extends AppState {}

class SignInErrorState extends AppState {
  final String error;

  SignInErrorState({required this.error});
}

class SignOutLoadingState extends AppState {}

class SignOutDoneState extends AppState {}

class SignOutErrorState extends AppState {
  final String error;
  SignOutErrorState(this.error);
}

class ResetPasswordLoadingState extends AppState {}

class ResetPasswordDoneState extends AppState {}

class ResetPasswordErrorState extends AppState {
  final String error;

  ResetPasswordErrorState({required this.error});
}

class GetUserDataLoadingState extends AppState {}

class GetUserDataDoneState extends AppState {}

class GetUserDataErrorState extends AppState {
  final String error;

  GetUserDataErrorState({required this.error});
}


class GetDataHeartLoadingState extends AppState {}

class GetDataHeartSuccessState extends AppState {
    final String percentage;

  GetDataHeartSuccessState({required this.percentage});

}

class GetDataHeartFailureState extends AppState {
  final String error;

  GetDataHeartFailureState({required this.error});
}

class CommonState {
  final bool isLoad;
  final bool isSuccess;
  final bool isError;
  final String errMessage;

  CommonState(
      {required this.isLoad,
      required this.isSuccess,
      required this.isError,
      required this.errMessage});

  CommonState copyWith(
      {bool? isLoad, bool? isSuccess, bool? isError, String? errMessage}) {
    return CommonState(
      isLoad: isLoad ?? this.isLoad,
      isSuccess: isSuccess ?? this.isSuccess,
      isError: isError ?? this.isError,
      errMessage: errMessage ?? this.errMessage,
    );
  }
}

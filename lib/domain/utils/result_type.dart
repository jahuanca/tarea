class ResultType<T, U> {
  get data => T;
  get error => U;
}

class Success<T, U> extends ResultType<T, U> {
  final dynamic data;
  Success({this.data});
}

class Error<T, U> extends ResultType<T, U> {
  final dynamic error;
  Error({this.error});
}

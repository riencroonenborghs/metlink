import "package:meta/meta.dart";
import "package:equatable/equatable.dart";

abstract class StopSearchState extends Equatable {
  StopSearchState([List props = const []]) : super(props);
}

class StopSearchErrorState extends StopSearchState {}
class StopSearchInitialState extends StopSearchState {}
class StopSearchStopSearchingState extends StopSearchState {}

class StopSearchDoneState extends StopSearchState {
  final dynamic result;
  StopSearchDoneState({@required this.result})
      : assert(result != null),
        super([result]);
}




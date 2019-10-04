import "package:meta/meta.dart";
import "package:equatable/equatable.dart";
import "package:metlink/models/models.dart";

abstract class StopSearchState extends Equatable {
  StopSearchState([List props = const []]) : super(props);
}

class StopSearchErrorState extends StopSearchState {}
class StopSearchInitialState extends StopSearchState {}
class StopSearchStopSearchingState extends StopSearchState {}

class StopSearchDoneState extends StopSearchState {
  final List<Stop> stops;
  StopSearchDoneState({@required this.stops})
      : assert(stops != null),
        super([stops]);
}




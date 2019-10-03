import "package:meta/meta.dart";
import "package:equatable/equatable.dart";

abstract class StopSearchEvent extends Equatable {
  StopSearchEvent([List props = const []]) : super(props);
}

class StopSearchPerformEvent extends StopSearchEvent {
  final String query;
  StopSearchPerformEvent({@required this.query})
      : assert(query != null),
        super([query]);
}
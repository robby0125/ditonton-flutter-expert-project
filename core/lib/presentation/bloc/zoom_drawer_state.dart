part of 'zoom_drawer_bloc.dart';

class ZoomDrawerState extends Equatable {
  Widget mainScreen;

  ZoomDrawerState(this.mainScreen);

  @override
  List<Object?> get props => [mainScreen];
}

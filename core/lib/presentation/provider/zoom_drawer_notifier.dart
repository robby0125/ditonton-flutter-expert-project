import 'package:core/presentation/pages/home_movie_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_zoom_drawer/config.dart';

class ZoomDrawerNotifier extends ChangeNotifier {
  final ZoomDrawerController zoomDrawerController;

  ZoomDrawerNotifier({required this.zoomDrawerController});

  Widget? _curMainScreen;

  Widget get mainScreen => _curMainScreen ?? const HomeMoviePage();

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
    notifyListeners();
  }

  void switchMainScreen({required Widget mainScreen}) {
    _curMainScreen = mainScreen;
    zoomDrawerController.toggle?.call();
    notifyListeners();
  }
}

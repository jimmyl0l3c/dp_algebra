import 'package:flutter/material.dart';

class AlgebraTransitionPage<T> extends Page<T> {
  final Widget child;
  final Duration duration;

  const AlgebraTransitionPage({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Route<T> createRoute(BuildContext context) =>
      PageBasedFadeTransitionRoute<T>(this);
}

class PageBasedFadeTransitionRoute<T> extends PageRoute<T> {
  final AlgebraTransitionPage<T> _page;

  PageBasedFadeTransitionRoute(this._page) : super(settings: _page);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => _page.duration;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      (settings as AlgebraTransitionPage).child;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    var tween = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.fastOutSlowIn));
    return ScaleTransition(
      scale: animation.drive(tween),
      child: child,
    );
  }
}

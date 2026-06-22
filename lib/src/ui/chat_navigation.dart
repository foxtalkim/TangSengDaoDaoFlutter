import 'package:flutter/material.dart'
    show BuildContext, MaterialPageRoute, Navigator, Widget;

Future<void> pushPage(BuildContext context, Widget page) {
  return Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => page));
}

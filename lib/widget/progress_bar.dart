import 'package:flutter/material.dart';
CircularProgress()
{
return Container(
alignment: Alignment.center,
  padding: const EdgeInsets.only(top: 12),
  child: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(
      Colors.amber
    ),
  ),
);
}

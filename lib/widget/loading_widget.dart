
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key, // Fixed the parameter declaration
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      
    );
  }
}

import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  final bool loadingState;
  const Loading({super.key, required this.loadingState});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return widget.loadingState
        ? Center(
            child: Card(
              elevation: 0,
              color: Colors.lightGreen.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 5,
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}

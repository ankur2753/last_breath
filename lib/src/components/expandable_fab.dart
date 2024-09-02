import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  final List<Widget> fabs;
  final List<String> labels;

  const ExpandableFab({
    super.key,
    required this.fabs,
    required this.labels,
  });

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  bool _isExpanded = false;

  void expand() {
    setState(() {
      _isExpanded = true;
    });
  }

  void collapse() {
    setState(() {
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Other action buttons
        for (int i = 0; i < widget.fabs.length; i++)
          if (_isExpanded)
            Positioned(
              bottom: 80.0 + i * 60.0, // Adjust spacing as needed
              right: 16.0,
              child: Column(
                children: [
                  widget.fabs[i],
                  const SizedBox(height: 4),
                  Text(widget.labels[i]),
                ],
              ),
            ),

        // Main FAB
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: AlwaysStoppedAnimation(_isExpanded ? 1.0 : 0.0),
            ),
          ),
        ),
      ],
    );
  }
}

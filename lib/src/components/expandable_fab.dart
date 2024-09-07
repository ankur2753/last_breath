// import 'package:flutter/material.dart';
//
// class ExpandableFab extends StatefulWidget {
//   final List<Widget> fabs;
//   final List<String> labels;
//
//   const ExpandableFab({
//     super.key,
//     required this.fabs,
//     required this.labels,
//   });
//
//   @override
//   State<ExpandableFab> createState() => _ExpandableFabState();
// }
//
// class _ExpandableFabState extends State<ExpandableFab> {
//   bool _isExpanded = false;
//
//   void expand() {
//     setState(() {
//       _isExpanded = true;
//     });
//   }
//
//   void collapse() {
//     setState(() {
//       _isExpanded = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.bottomRight,
//       children: [
//         // Main FAB
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: FloatingActionButton(
//             onPressed: () {
//               setState(() {
//                 _isExpanded = !_isExpanded;
//               });
//             },
//             child: AnimatedIcon(
//               icon: AnimatedIcons.menu_close,
//               progress: AlwaysStoppedAnimation(_isExpanded ? 1.0 : 0.0),
//             ),
//           ),
//         ),
//
//         // Expanded FABs (using a Stack for better control)
//         if (_isExpanded)
//           Positioned(
//             bottom: 100.0, // Adjust bottom position based on FAB height
//             right: 16.0,
//             child: SizedBox(
//               width: 650,
//               height: 650,
//               child: Stack(
//                 alignment: Alignment.bottomCenter,
//                 children: [
//                   for (int i = 0; i < widget.fabs.length; i++)
//                     Positioned(
//                       bottom: i * 60.0, // Adjust spacing between FABs
//                       child: Row(
//                         children: [
//                           widget.fabs[i],
//                           const SizedBox(width: 4),
//                           Text(widget.labels[i]),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

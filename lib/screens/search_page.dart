

// import 'package:flutter/material.dart';
// import 'package:vidyamani/components/search_bar.dart';

// class SearchBarButton extends StatefulWidget {
//   const SearchBarButton({super.key});

//   @override
//   _SearchBarButtonState createState() => _SearchBarButtonState();
// }

// final List<Map<String, String>> searchOptions = [
//   {"schoolName": "School 1", "imageUrl": "assets/school2.png"},
//   {"schoolName": "School 2", "imageUrl": "assets/school2.png"},
//   {"schoolName": "School 3", "imageUrl": "assets/school2.png"},
// ];
// final List<Map<String, String>> imageSchools = [
//   {"schoolName": "School 1", "imageUrl": "assets/school2.png"},
//   {"schoolName": "School 2", "imageUrl": "assets/school2.png"},
//   {"schoolName": "School 3", "imageUrl": "assets/school2.png"},
// ];

// final List<Map<String, String>> dreamSchools = [
//   {"schoolName": "School 1", "imageUrl": "assets/school2.png"},
//   {"schoolName": "School 2", "imageUrl": "assets/school4.png"},
//   {"schoolName": "School 3", "imageUrl": "assets/school5.png"},
//   {"schoolName": "School 4", "imageUrl": "assets/school6.png"},
// ];

// class _SearchBarButtonState extends State<SearchBarButton> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           body: ListView(children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
//           child: Column(
//             children: [
//               const SearchBarWithButton(hintText: "Search boarding admissions"),
//               const SizedBox(height: 20),
//               Column(
//                 children: searchOptions.map((option) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 5.0),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                       ),
//                       onPressed: () {},
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Image.asset(option["imageUrl"]!),
//                                 const SizedBox(width: 25),
//                                 Text(
//                                   option["schoolName"]!,
//                                   style: const TextStyle(color: Colors.black),
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               const Divider(
//                 thickness: 1,
//                 color: Colors.blue,
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 alignment: Alignment.centerLeft,
//                 child: const Text(
//                   'Top Courses',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: imageSchools.map((school) {
//                   final String? schoolName = school["schoolName"];
//                   final String? imageUrl = school["imageUrl"];
//                   if (schoolName != null && imageUrl != null) {
//                     return ElevatedButton(
//                       onPressed: () {
//                         // Handle button press
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color.fromRGBO(240, 255, 255, 1),
//                         minimumSize: const Size(100, 100),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         shadowColor: Colors.black54,
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Container(
//                             child: Image.asset(
//                               imageUrl,
//                               height: 100,
//                               width: 100,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   schoolName,
//                                   style: const TextStyle(
//                                     color: Colors.blue,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   } else {
//                     return Container();
//                   }
//                 }).toList(),
//               ),
//               const Padding(
//                 padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
//                 child: Divider(
//                   thickness: 1,
//                   color: Colors.blue,
//                 ),
//               ),
//               Container(
//                 alignment: Alignment.centerLeft,
//                 child: const Text(
//                   'Dream Schools',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: dreamSchools.map((school) {
//                   final String? schoolName = school["schoolName"];
//                   final String? imageUrl = school["imageUrl"];
//                   if (schoolName != null && imageUrl != null) {
//                     return Column(
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             // Handle button press
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                                 const Color.fromRGBO(250, 250, 250, 1),
//                             minimumSize: const Size(100, 100),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(120.0),
//                             ),
//                             shadowColor: Colors.black87,
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
//                                 child: Image.asset(
//                                   imageUrl,
//                                   height: 60,
//                                   width: 60,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Text(
//                           schoolName,
//                           style: const TextStyle(
//                               fontSize: 13,
//                               color: Colors.blue,
//                               fontWeight: FontWeight.w600),
//                         )
//                       ],
//                     );
//                   } else {
//                     return Container();
//                   }
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//       ])),
//     );
//   }
// }

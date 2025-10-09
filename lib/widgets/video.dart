import 'package:flutter/material.dart';

class Video extends StatefulWidget {
  final String title;
  final String imageURL;
  final String publisher;
  final String date;

  const Video({
    super.key,
    required this.title,
    required this.imageURL,
    required this.publisher,
    required this.date,
  });
  @override
  State<StatefulWidget> createState() {
    return VideoState();
  }
}

class VideoState extends State<Video> {
  selectedArticle() {}
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("Taped");
        selectedArticle();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 7,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Image.network(
                    widget.imageURL,
                    height: 230,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  height: 230,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15)),
                      color: Colors.black.withOpacity(0.5)),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  height: 230,
                  child: Center(
                      child: Icon(
                    Icons.play_circle_outline,
                    size: 80,
                    color: Colors.white.withOpacity(0.8),
                  )),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: const Color(0xFFE1ECEC),
                              borderRadius: BorderRadius.circular(5)),
                          child: const Icon(Icons.create,
                              color: Color(0xFF599B99), size: 20)),
                      const SizedBox(width: 5),
                      const Text(
                        'الدكتور :',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF599B99),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.publisher,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF495057),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: const Color(0xFFE1ECEC),
                              borderRadius: BorderRadius.circular(5)),
                          child: const Icon(Icons.date_range_outlined,
                              color: Color(0xFF599B99), size: 20)),
                      const SizedBox(width: 5),
                      Text(
                        widget.date,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF495057),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

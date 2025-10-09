import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:health_app/colors.dart';
import 'package:health_app/models/article_model.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo(String videoUrl) async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    await _videoController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: false,
      looping: false,
      allowFullScreen: true,
      allowMuting: true,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.teal,
        handleColor: Colors.tealAccent,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final article = ModalRoute.of(context)?.settings.arguments as ArticleModel;

    if (article.isVideo &&
        _videoController == null &&
        article.videoURL != null) {
      _initializeVideo(article.videoURL!);
    }

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: background2,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 235,
              width: double.infinity,
              child: article.isVideo
                  ? (_chewieController != null &&
                          _videoController!.value.isInitialized)
                      ? Chewie(controller: _chewieController!)
                      : const Center(
                          child: CircularProgressIndicator(),
                        )
                  : Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(article.imageURL ?? ''),
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF197278),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    article.description,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 17.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

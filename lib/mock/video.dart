import 'dart:io';

Socket? socket;
var videoList = [
  'test-video-10.MP4',
  'test-video-6.mp4',
  'test-video-9.MP4',
  'test-video-8.MP4',
  'test-video-7.MP4',
  'test-video-1.mp4',
  'test-video-2.mp4',
  'test-video-3.mp4',
  'test-video-4.mp4',
];

class UserVideo {
  final String url;
  final String image;
  final String? desc;

  UserVideo({
    required this.url,
    required this.image,
    this.desc,
  });

  static List<UserVideo> fetchVideo() {
    List<UserVideo> list = videoList
        .map((e) => UserVideo(
            image: '', url: 'https://static.ybhospital.net/$e', desc: '$e'))
        .toList();
    return list;
  }

  @override
  String toString() {
    return 'image:$image' '\nvideo:$url';
  }
}

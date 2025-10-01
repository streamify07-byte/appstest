import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../models/channel.dart';
import '../../../providers/media_providers.dart';

class LiveTvScreen extends ConsumerStatefulWidget {
  const LiveTvScreen({super.key});

  @override
  ConsumerState<LiveTvScreen> createState() => _LiveTvScreenState();
}

class _LiveTvScreenState extends ConsumerState<LiveTvScreen> {
  VideoPlayerController? _controller;
  Channel? _currentChannel;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _play(Channel channel) async {
    if (_currentChannel?.id == channel.id && _controller != null) return;
    await _controller?.dispose();
    final controller = VideoPlayerController.networkUrl(Uri.parse(channel.streamUrl));
    await controller.initialize();
    await controller.play();
    setState(() {
      _controller = controller;
      _currentChannel = channel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final channelsAsync = ref.watch(channelsProvider);

    return SafeArea(
      child: Column(
        children: [
          if (_controller != null && _controller!.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            )
          else
            Container(
              height: 200,
              color: Colors.black12,
              alignment: Alignment.center,
              child: const Text('Select a channel to play'),
            ),
          const Divider(),
          Expanded(
            child: channelsAsync.when(
              data: (channels) => ListView.separated(
                itemCount: channels.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final c = channels[index];
                  return ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(c.logoUrl)),
                    title: Text(c.name),
                    subtitle: Text(c.category ?? ''),
                    onTap: () => _play(c),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Failed to load channels')),
            ),
          ),
        ],
      ),
    );
  }
}

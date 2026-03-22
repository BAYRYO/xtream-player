import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:stream_xtream/core/theme/app_theme.dart';
import 'package:stream_xtream/features/movies/domain/entities/movie.dart';
import 'package:stream_xtream/features/player/presentation/bloc/player_bloc.dart';
import 'package:stream_xtream/features/player/presentation/bloc/player_event.dart';
import 'package:stream_xtream/features/player/presentation/bloc/player_state.dart';

class VideoPlayerPage extends StatefulWidget {
  final String streamUrl;
  final String title;
  final int? contentId;
  final ContentType contentType;
  final int? seasonNumber;
  final int? episodeNumber;

  const VideoPlayerPage({
    super.key,
    required this.streamUrl,
    required this.title,
    this.contentId,
    required this.contentType,
    this.seasonNumber,
    this.episodeNumber,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late final PlayerBloc _playerBloc;
  late final VideoController _videoController;
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _playerBloc = PlayerBloc();
    _videoController = VideoController(_playerBloc.player);
    
    _playerBloc.add(PlayerInitialize(
      streamUrl: widget.streamUrl,
      title: widget.title,
      contentId: widget.contentId,
      contentType: widget.contentType,
      seasonNumber: widget.seasonNumber,
      episodeNumber: widget.episodeNumber,
    ));
    
    // Hide system UI for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _playerBloc.add(PlayerDispose());
    _playerBloc.close();
    super.dispose();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _onTap() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideControlsTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _playerBloc,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<PlayerBloc, VideoPlayerState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: _onTap,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Video Player
                  Video(
                    controller: _videoController,
                    controls: NoVideoControls,
                  ),
                  
                  // Loading/Buffering Indicator
                  if (state.isBuffering || state.status == VideoPlayerStatus.loading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  
                  // Controls Overlay
                  AnimatedOpacity(
                    opacity: _showControls ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: _ControlsOverlay(
                      state: state,
                      onPlayPause: () {
                        if (state.status == VideoPlayerStatus.playing) {
                          _playerBloc.add(PlayerPause());
                        } else {
                          _playerBloc.add(PlayerPlay());
                        }
                      },
                      onSeek: (position) {
                        _playerBloc.add(PlayerSeek(position));
                      },
                      onVolumeChanged: (volume) {
                        _playerBloc.add(PlayerSetVolume(volume));
                      },
                      onSpeedChanged: (speed) {
                        _playerBloc.add(PlayerSetPlaybackSpeed(speed));
                      },
                      onClose: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  final VideoPlayerState state;
  final VoidCallback onPlayPause;
  final Function(Duration) onSeek;
  final Function(double) onVolumeChanged;
  final Function(double) onSpeedChanged;
  final VoidCallback onClose;

  const _ControlsOverlay({
    required this.state,
    required this.onPlayPause,
    required this.onSeek,
    required this.onVolumeChanged,
    required this.onSpeedChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black54,
            Colors.transparent,
            Colors.transparent,
            Colors.black54,
          ],
          stops: const [0.0, 0.2, 0.8, 1.0],
        ),
      ),
      child: Column(
        children: [
          // Top Bar
          _TopBar(
            title: state.title,
            onClose: onClose,
          ),
          
          // Center Controls
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Rewind
                  _IconButton(
                    icon: Icons.replay_10,
                    size: 40,
                    onPressed: () {
                      final newPosition = state.position - const Duration(seconds: 10);
                      onSeek(newPosition.isNegative ? Duration.zero : newPosition);
                    },
                  ),
                  const SizedBox(width: 32),
                  
                  // Play/Pause
                  _IconButton(
                    icon: state.status == VideoPlayerStatus.playing
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    size: 72,
                    onPressed: onPlayPause,
                  ),
                  const SizedBox(width: 32),
                  
                  // Forward
                  _IconButton(
                    icon: Icons.forward_10,
                    size: 40,
                    onPressed: () {
                      final newPosition = state.position + const Duration(seconds: 10);
                      onSeek(newPosition > state.duration ? state.duration : newPosition);
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Bar
          _BottomBar(
            state: state,
            onSeek: onSeek,
            onVolumeChanged: onVolumeChanged,
            onSpeedChanged: onSpeedChanged,
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const _TopBar({
    required this.title,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 8,
        right: 8,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: onClose,
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Quality Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.hdr10Color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '4K HDR',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final VideoPlayerState state;
  final Function(Duration) onSeek;
  final Function(double) onVolumeChanged;
  final Function(double) onSpeedChanged;

  const _BottomBar({
    required this.state,
    required this.onSeek,
    required this.onVolumeChanged,
    required this.onSpeedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress Slider
          Row(
            children: [
              Text(
                state.positionString,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  ),
                  child: Slider(
                    value: state.progress.clamp(0.0, 1.0),
                    onChanged: (value) {
                      final newPosition = Duration(
                        seconds: (value * state.duration.inSeconds).round(),
                      );
                      onSeek(newPosition);
                    },
                    activeColor: AppTheme.primaryColor,
                    inactiveColor: Colors.white30,
                  ),
                ),
              ),
              Text(
                state.durationString,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          
          // Controls Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Volume Control
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      state.volume == 0
                          ? Icons.volume_off
                          : state.volume < 0.5
                              ? Icons.volume_down
                              : Icons.volume_up,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      onVolumeChanged(state.volume == 0 ? 1.0 : 0.0);
                    },
                  ),
                  SizedBox(
                    width: 100,
                    child: Slider(
                      value: state.volume,
                      onChanged: onVolumeChanged,
                      activeColor: Colors.white,
                      inactiveColor: Colors.white30,
                    ),
                  ),
                ],
              ),
              
              // Playback Speed
              GestureDetector(
                onTap: () => _showSpeedMenu(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white30),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${state.playbackSpeed}x',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              
              // Settings
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  // Show settings menu
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSpeedMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Playback Speed',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...[0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
            return ListTile(
              title: Text('${speed}x'),
              trailing: state.playbackSpeed == speed
                  ? const Icon(Icons.check, color: AppTheme.primaryColor)
                  : null,
              onTap: () {
                onSpeedChanged(speed);
                Navigator.pop(context);
              },
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onPressed;

  const _IconButton({
    required this.icon,
    required this.size,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: size),
      color: Colors.white,
      onPressed: onPressed,
    );
  }
}

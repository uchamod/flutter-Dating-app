import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:undomain/models/user/user_model.dart';
import 'package:undomain/provider/user_provider.dart';
import 'package:undomain/router/router_names.dart';
import 'package:undomain/secrets/secrets.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/global/global_function.dart';
import 'package:undomain/widgets/avater/streaming_avater.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class ZegoLiveScreen extends ConsumerStatefulWidget {
  final bool isHost;
  final String liveId;
  const ZegoLiveScreen({super.key, required this.isHost, required this.liveId});

  @override
  ConsumerState<ZegoLiveScreen> createState() => _ZegoLiveScreenState();
}

class _ZegoLiveScreenState extends ConsumerState<ZegoLiveScreen> {
  bool _hasShownError = false;
  final GlobalFunction _globalFunction = GlobalFunction();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    ZegoUIKit().leaveRoom();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getCurrentUser = ref.watch(currentUserProvider);

    return SafeArea(
      child: getCurrentUser.when(
        loading:
            () =>
                Center(child: CircularProgressIndicator(color: utilPrimaryRed)),

        error:
            (error, stackTrace) =>
                Center(child: Text('Error: ${error.toString()}')),
        data: (currentuser) {
          if ((!currentuser["success"] && !_hasShownError) ||
              currentuser["user"] == null) {
            _hasShownError = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _globalFunction.snackBarMassage(
                context,
                currentuser["massage"],
                3,
              );
            });
          }
          if (currentuser["user"] == null) {
            Center(child: CircularProgressIndicator(color: utilPrimaryRed));
          }
          UserModel user = currentuser["user"];
          return ZegoUIKitPrebuiltLiveStreaming(
            appID: Secrets().ZEGO_APPID,
            appSign: Secrets().ZEGO_APPSING,
            userID: user.id,
            userName: user.username,
            liveID: widget.liveId,
            //when end the streaming
            events: ZegoUIKitPrebuiltLiveStreamingEvents(
              onEnded: (event, defaultAction) {
                if (event.reason == ZegoLiveStreamingEndReason.hostEnd) {
                  GoRouter.of(
                    context,
                  ).goNamed(RouterNames.StremingConfigScreen);
                }
                if (event.reason == ZegoLiveStreamingEndReason.localLeave) {
                  GoRouter.of(
                    context,
                  ).goNamed(RouterNames.StremingConfigScreen);
                } else {
                  GoRouter.of(
                    context,
                  ).goNamed(RouterNames.StremingConfigScreen);
                }
              },
            ),
            config:
                (widget.isHost
                      ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
                      : ZegoUIKitPrebuiltLiveStreamingConfig.audience())
                  ..avatarBuilder = customAvatarBuilder,
          );
        },
      ),
    );
  }
}

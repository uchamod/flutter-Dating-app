import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:undomain/router/router_names.dart';
import 'package:undomain/services/auth_services/authservices.dart';
import 'package:undomain/services/reelservice/reelservices.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/global/global_function.dart';
import 'package:undomain/util/global/global_varibles.dart';
import 'package:undomain/util/textstyles/text_styles.dart';
import 'package:undomain/widgets/textboxes/authtext_box.dart';

class ProfileScren extends ConsumerStatefulWidget {
  final String userId;
  const ProfileScren({super.key, required this.userId});

  @override
  ConsumerState<ProfileScren> createState() => _ProfileScrenState();
}

class _ProfileScrenState extends ConsumerState<ProfileScren> {
  final ReelsService _reelsService = ReelsService();
  bool isLoading = false;
  File? _videofile;
  final TextEditingController _titlecontroller = TextEditingController();
  final GlobalFunction _globalFunction = GlobalFunction();
  Future<void> _pickVideo() async {
    final _picker = ImagePicker();
    final video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _videofile = File(video.path);
      });
    }
  }

  Future<void> _uploadVideo() async {
    setState(() {
      isLoading = true;
    });
    final response = await _reelsService.uploadVideo(
      userId: widget.userId,
      videoFile: _videofile!,
      title: _titlecontroller.text,
    );
    if (!response["success"]) {
      print(response);
      _globalFunction.snackBarMassage(context, response["message"], 3);
    } else {
      _globalFunction.snackBarMassage(context, "video uploaded", 3);
    }

    setState(() {
      isLoading = false;
    });
  }

  void _logout(WidgetRef ref) {
    Authservices().logout(ref);
    GoRouter.of(context).goNamed(RouterNames.loginPage);
  }

  @override
  void dispose() {
    _titlecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: mainPagePaddingH,
          vertical: mainPagePaddingV,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    _logout(ref);
                  },
                  child: Text("Logout", style: textBody),
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                await _pickVideo();
              },
              child:
                  _videofile != null
                      ? Text(_videofile!.path, style: textLabel)
                      : Container(
                        width: 34,
                        height: 34,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: utilPrimaryWhite,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            size: 28,
                            color: utilPrimaryBlack,
                          ),
                        ),
                      ),
            ),
            SizedBox(height: 10),
            AuthtextBox(
              onSubmit: (p0) {},
              controller: _titlecontroller,
              hint: "title",
              isShow: false,
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.text,
              isValid: true,
              validChecker: (value) => null,
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                await _uploadVideo();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: mainPagePaddingH,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: utilPrimaryRed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    isLoading
                        ? Center(
                          child: CircularProgressIndicator(
                            color: utilPrimaryWhite,
                          ),
                        )
                        : Text(
                          "Upload Video",
                          style: textTitalSmall.copyWith(
                            color: utilPrimaryWhite,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

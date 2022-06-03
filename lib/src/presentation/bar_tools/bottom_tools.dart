import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/models/editable_items.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/scroll_notifier.dart';
import 'package:stories_editor/src/presentation/utils/constants/item_type.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class BottomTools extends StatelessWidget {
  final GlobalKey contentKey;
  final Function(String imageUri) onDone;
  final Widget? onDoneButtonStyle;
  final Function renderWidget;

  /// editor background color
  final Color? editorBackgroundColor;
  const BottomTools(
      {Key? key,
      required this.contentKey,
      required this.onDone,
      required this.renderWidget,
      this.onDoneButtonStyle,
      this.editorBackgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    bool _createVideo = false;
    return Consumer4<ControlNotifier, ScrollNotifier, DraggableWidgetNotifier,
        PaintingNotifier>(
      builder: (_, controlNotifier, scrollNotifier, itemNotifier,
          paintingNotifier, __) {
        return Container(
          height: 95,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// preview gallery
              Container(
                width: _size.width / 3,
                height: _size.width / 3,
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  child: _preViewContainer(
                    /// if [model.imagePath] is null/empty return preview image
                    child: controlNotifier.mediaPath.isEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: GestureDetector(
                              onTap: () async {
                                /// scroll to gridView page
                                if (controlNotifier.mediaPath.isEmpty) {
                                  final files =
                                      await AssetPicker.pickAssets(context,
                                          pickerConfig: const AssetPickerConfig(
                                            maxAssets: 1,
                                            requestType: RequestType.image,
                                          ));
                                  if (files != null && files.isNotEmpty) {
                                    controlNotifier.mediaPath =
                                        (await files.first.file)?.path ?? '';
                                    itemNotifier.draggableWidget.insert(
                                        0,
                                        EditableItem()
                                          ..type = ItemType.image
                                          ..position = const Offset(0.0, 0));
                                  }
                                }
                              },
                              child: const Icon(
                                Icons.photo,
                                color: Colors.white,
                              ),
                            ))

                        /// return clear [imagePath] provider
                        : GestureDetector(
                            onTap: () {
                              /// clear image url variable
                              controlNotifier.mediaPath = '';
                              itemNotifier.draggableWidget.removeAt(0);
                            },
                            child: Container(
                              height: 45,
                              width: 45,
                              color: Colors.transparent,
                              child: Transform.scale(
                                scale: 0.7,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),

              /// center logo
              controlNotifier.middleBottomWidget != null
                  ? Center(
                      child: Container(
                          width: _size.width / 3,
                          height: 80,
                          alignment: Alignment.bottomCenter,
                          child: controlNotifier.middleBottomWidget),
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/instagram_logo.png',
                            package: 'stories_editor',
                            color: Colors.white,
                            height: 42,
                          ),
                          const Text(
                            'Stories Creator',
                            style: TextStyle(
                                color: Colors.white38,
                                letterSpacing: 1.5,
                                fontSize: 9.2,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

              /// save final image to gallery
              Container(
                width: _size.width / 3,
                padding: const EdgeInsets.only(right: 15),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _preViewContainer({child}) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.4, color: Colors.white)),
      child: child,
    );
  }
}

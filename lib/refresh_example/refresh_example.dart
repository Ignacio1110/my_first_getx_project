/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time:  2019-07-11 17:55
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import 'message_controller.dart';

/*
   实现聊天列表+加载更多功能,类似于qq那种加载效果
   聊天列表最大的难点就是在列表不满一屏时,要把它往上压。目前来说,flutter没有提供这类sliver能把剩余空间(上和下)给占有,类似于Expanded,
   SliverFillRemaing并没有起作用。
   ExpandedViewport是我自定义Viewport,用来解决当不满一屏时reverseListView要居于顶部的问题(只适用于少数情况),原理就是第一次
   布局先探测一下他们的布局情况,第二次布局假如不满一屏,就在SliverExpanded后面的所有slivers调整主轴偏距。
 */
class QQChatList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _QQChatListState();
  }
}

class _QQChatListState extends State<QQChatList> {
  RefreshController _refreshController = RefreshController();
  ScrollController _scrollController = ScrollController();
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MessageController());

    // final controller = Get.find<MessageController>();
    // TODO: implement build
    return SizedBox(
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text("XXXXX"),
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
              size: 20,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          trailing: Icon(
            Icons.group,
            color: Colors.grey,
            size: 24,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: SmartRefresher(
                  enablePullDown: false,
                  onLoading: () async {
                    await Future.delayed(Duration(milliseconds: 1000));
                    controller.addData();
                    // setState(() {});
                    _refreshController.loadComplete();
                  },
                  // footer: CustomFooter(
                  //   loadStyle: LoadStyle.ShowAlways,
                  //   builder: (context, mode) {
                  //     if (mode == LoadStatus.loading) {
                  //       return Container(
                  //         height: 60.0,
                  //         child: Container(
                  //           height: 20.0,
                  //           width: 20.0,
                  //           child: CupertinoActivityIndicator(),
                  //         ),
                  //       );
                  //     } else
                  //       return Container();
                  //   },
                  // ),
                  enablePullUp: true,
                  child: Scrollable(
                    controller: _scrollController,
                    axisDirection: AxisDirection.up,
                    viewportBuilder: (context, offset) {
                      return ExpandedViewport(
                        offset: offset,
                        axisDirection: AxisDirection.up,
                        slivers: <Widget>[
                          SliverExpanded(),
                          Obx(
                            () => SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (c, i) => controller.data[i],
                                  childCount: controller.data.length),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  controller: _refreshController,
                ),
              ),
              Container(
                color: Colors.white,
                height: 56.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: CupertinoTextField(
                          controller: _textController,
                          placeholder: "输入你想发送的信息",
                          onSubmitted: (s) {
                            controller.data.insert(
                                0,
                                MessageItem(
                                  content: s,
                                  author: "我",
                                  url: myUrl,
                                  isMe: true,
                                ));
                            setState(() {});
                            _scrollController.jumpTo(0.0);
                            _textController.clear();
                          },
                        ),
                        margin: EdgeInsets.all(10.0),
                      ),
                    ),
                    ElevatedButton(
                      child: Text("发送"),
                      onPressed: () {
                        _scrollController.jumpTo(0.0);
                        controller.data.insert(
                            0,
                            MessageItem(
                              content: _textController.text,
                              author: "我",
                              url: myUrl,
                              isMe: true,
                            ));
                        setState(() {});
                        _textController.clear();
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*
   aim to implements expand all the free empty place when viewport is not full
   ,but this can not correction offset,due to _minScrollExtent,_maxScrollExtent private in RenderViewport
   ,no idea how to do. without doing this,chat list (top when not full && reverse = true) can not be done.
   in my plugin similar issue:#127,# 118
   in flutter similar issue:#12650,#33399,#17444
 */

class ExpandedViewport extends Viewport {
  ExpandedViewport({
    Key? key,
    AxisDirection axisDirection = AxisDirection.down,
    AxisDirection? crossAxisDirection,
    double anchor = 0.0,
    required ViewportOffset offset,
    Key? center,
    double? cacheExtent,
    List<Widget> slivers = const <Widget>[],
  }) : super(
            key: key,
            slivers: slivers,
            axisDirection: axisDirection,
            crossAxisDirection: crossAxisDirection,
            anchor: anchor,
            offset: offset,
            center: center,
            cacheExtent: cacheExtent);

  @override
  RenderViewport createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    return _RenderExpandedViewport(
        axisDirection: axisDirection,
        crossAxisDirection: crossAxisDirection ??
            Viewport.getDefaultCrossAxisDirection(context, axisDirection),
        anchor: anchor,
        offset: offset,
        cacheExtent: cacheExtent);
  }
}

class _RenderExpandedViewport extends RenderViewport {
  _RenderExpandedViewport({
    AxisDirection axisDirection = AxisDirection.down,
    required AxisDirection crossAxisDirection,
    required ViewportOffset offset,
    double anchor = 0.0,
    List<RenderSliver>? children,
    RenderSliver? center,
    double? cacheExtent,
  }) : super(
            axisDirection: axisDirection,
            crossAxisDirection: crossAxisDirection,
            offset: offset,
            anchor: anchor,
            children: children,
            center: center,
            cacheExtent: cacheExtent);

  @override
  void performLayout() {
    // TODO: implement performLayout
    super.performLayout();
    RenderSliver? expand;
    RenderSliver? p = firstChild;
    double totalLayoutExtent = 0;
    double frontExtent = 0.0;
    while (p != null) {
      totalLayoutExtent += p.geometry!.scrollExtent;
      if (p is _RenderExpanded) {
        expand = p;
        frontExtent = totalLayoutExtent;
      }

      p = childAfter(p);
    }

    if (expand != null && size.height > totalLayoutExtent) {
      _attemptLayout(expand, size.height, size.width,
          offset.pixels - frontExtent - (size.height - totalLayoutExtent));
    }
  }

  // _minScrollExtent private in super,no setter method
  double _attemptLayout(RenderSliver expandPosition, double mainAxisExtent,
      double crossAxisExtent, double correctedOffset) {
    assert(!mainAxisExtent.isNaN);
    assert(mainAxisExtent >= 0.0);
    assert(crossAxisExtent.isFinite);
    assert(crossAxisExtent >= 0.0);
    assert(correctedOffset.isFinite);

    // centerOffset is the offset from the leading edge of the RenderViewport
    // to the zero scroll offset (the line between the forward slivers and the
    // reverse slivers).
    final double centerOffset = mainAxisExtent * anchor - correctedOffset;
    final double reverseDirectionRemainingPaintExtent =
        centerOffset.clamp(0.0, mainAxisExtent);

    final double forwardDirectionRemainingPaintExtent =
        (mainAxisExtent - centerOffset).clamp(0.0, mainAxisExtent);
    final double fullCacheExtent = mainAxisExtent + 2 * cacheExtent!;
    final double centerCacheOffset = centerOffset + cacheExtent!;
    final double forwardDirectionRemainingCacheExtent =
        (fullCacheExtent - centerCacheOffset).clamp(0.0, fullCacheExtent);

    final RenderSliver? leadingNegativeChild = childBefore(center!);
    // positive scroll offsets
    return layoutChildSequence(
      child: expandPosition,
      scrollOffset: math.max(0.0, -centerOffset),
      overlap:
          leadingNegativeChild == null ? math.min(0.0, -centerOffset) : 0.0,
      layoutOffset: centerOffset >= mainAxisExtent
          ? centerOffset
          : reverseDirectionRemainingPaintExtent,
      remainingPaintExtent: forwardDirectionRemainingPaintExtent,
      mainAxisExtent: mainAxisExtent,
      crossAxisExtent: crossAxisExtent,
      growthDirection: GrowthDirection.forward,
      advance: childAfter,
      remainingCacheExtent: forwardDirectionRemainingCacheExtent,
      cacheOrigin: centerOffset.clamp(-cacheExtent!, 0.0),
    );
  }
}

//tag
class SliverExpanded extends SingleChildRenderObjectWidget {
  SliverExpanded() : super(child: Container());

  @override
  RenderSliver createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    return _RenderExpanded();
  }
}

class _RenderExpanded extends RenderSliver
    with RenderObjectWithChildMixin<RenderBox> {
  @override
  void performLayout() {
    // TODO: implement performLayout
    geometry = SliverGeometry.zero;
  }
}

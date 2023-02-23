import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

// import 'src/sort_path_delegate.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PhotoManagerController extends GetxController {
  PhotoManagerController({
    // this.selectedAssets,
    this.maxSelectAssets = defaultMaxAssetsCount,
    // this.pageSize,
    // this.pathThumbnailSize,
    this.requestType = RequestType.image,
    SortPathDelegate<AssetPathEntity>? sortPathDelegate,
    this.sortPathsByModifiedDate = false,
    this.filterOptions,
    Duration initializeDelayDuration = const Duration(milliseconds: 250),
  }) {
    sortPathDelegate = sortPathDelegate ?? SortPathDelegate.common;
    // Call [getAssetList] with route duration when constructing.
    Future<void>.delayed(initializeDelayDuration, () async {
      await getPaths();
      await getAssetsFromCurrentPath();
    });
  }

  ///這兩個可以長久保持排序方式
  static SortPathDelegate<AssetPathEntity> sortPathDelegate =
      SortPathDelegate.common;

  /// The last scroll position where the picker scrolled.
  ///
  /// See also:
  ///  * [AssetPickerBuilderDelegate.keepScrollOffset]
  static ScrollPosition? scrollPosition;

  static const int defaultAssetsPerPage = 80;
  static const int defaultMaxAssetsCount = 9;

  /// Default theme color from WeChat.
  static const Color defaultThemeColorWeChat = Color(0xff00bc56);

  static const ThumbnailSize defaultAssetGridPreviewSize =
      ThumbnailSize.square(200);
  static const ThumbnailSize defaultPathThumbnailSize =
      ThumbnailSize.square(80);

  final int maxSelectAssets;
  final pageSize = defaultAssetsPerPage;
  final pathThumbnailSize = defaultPathThumbnailSize;

  /// Request assets type.
  /// 请求的资源类型
  final RequestType requestType;

  /// {@macro wechat_assets_picker.constants.AssetPickerConfig.sortPathsByModifiedDate}
  final bool sortPathsByModifiedDate;

  /// Filter options for the picker.
  /// 选择器的筛选条件
  ///
  /// Will be merged into the base configuration.
  /// 将会与基础条件进行合并。
  final FilterOptionGroup? filterOptions;

  final RxList<AssetEntity> _selectedAssets = <AssetEntity>[].obs;
  RxList<AssetEntity> get selectedAssets => _selectedAssets;

  ///選擇圖片，
  ///單選/多選
  selectAsset(AssetEntity assetEntity) {
    final int index = _selectedAssets.indexWhere(
      (AssetEntity s) => assetEntity.id == s.id,
    );
    if (index == -1) {
      if (_selectedAssets.length < maxSelectAssets) {
        _selectedAssets.add(assetEntity);
      } else {
        _selectedAssets.removeLast();
        _selectedAssets.add(assetEntity);
      }
    } else {
      _selectedAssets.removeAt(index);
    }
  }

  ///當前所選圖案路徑
  final Rxn<PathWrapper<AssetPathEntity>?> _currentPath =
      Rxn<PathWrapper<AssetPathEntity>?>();

  /// The path which is currently using.
  /// 正在查看的资源路径
  PathWrapper<AssetPathEntity>? get currentPath => _currentPath.value;

  set currentPath(PathWrapper<AssetPathEntity>? value) {
    if (value == _currentPath.value) {
      return;
    }
    if (value != null) {
      final int index = _paths.indexWhere(
        (PathWrapper<AssetPathEntity> p) => p.path.id == value.path.id,
      );
      if (index != -1) {
        _paths[index] = value; //TODO check update _paths
        getThumbnailFromPath(value);
      }
    }
    _currentPath.value = value;
  }

  /// Map for all path entity.
  /// 所有包含资源的路径里列表
  ///
  /// Using [Map] in order to save the thumbnail data
  /// for the first asset under the path.
  /// 使用 [Map] 来保存路径下第一个资源的缩略图数据
  final RxList<PathWrapper<AssetPathEntity>> _paths =
      RxList<PathWrapper<AssetPathEntity>>([]);
  List<PathWrapper<AssetPathEntity>> get paths => _paths;

  /// Set thumbnail [data] for the specific [path].
  /// 为指定的路径设置缩略图数据
  void setPathThumbnail(AssetPathEntity path, Uint8List? data) {
    final int index = _paths.indexWhere(
      (PathWrapper<AssetPathEntity> w) => w.path == path,
    );
    if (index != -1) {
      final PathWrapper<AssetPathEntity> newWrapper = _paths[index].copyWith(
        thumbnailData: data,
      );
      _paths[index] = newWrapper;
      _paths.assignAll(paths);
    }
  }

  /// Assets under current path entity.
  /// 正在查看的资源路径下的所有资源
  final RxList<AssetEntity> _currentAssets = RxList<AssetEntity>([]);
  List<AssetEntity> get currentAssets => _currentAssets;

  set currentAssets(List<AssetEntity> value) {
    if (value == currentAssets) {
      return;
    }
    _currentAssets.assignAll(value.toList());
  }

  /// Whether there are any assets can be displayed.
  /// 是否有资源可供显示
  bool get hasAssetsToDisplay => _hasAssetsToDisplay.value;
  final RxBool _hasAssetsToDisplay = false.obs;

  set hasAssetsToDisplay(bool value) {
    if (value == _hasAssetsToDisplay.value) {
      return;
    }
    _hasAssetsToDisplay.value = value;
  }

  /// The current page for assets list.
  /// 当前加载的资源列表分页数
  int get currentAssetsListPage =>
      (math.max(1, currentAssets.length) / pageSize).ceil();

  /// Whether there are assets on the devices.
  /// 设备上是否有资源文件
  bool get isAssetsEmpty => _isAssetsEmpty.value;
  final RxBool _isAssetsEmpty = false.obs;

  set isAssetsEmpty(bool value) {
    if (value == isAssetsEmpty) {
      return;
    }
    _isAssetsEmpty.value = value;
  }

  /// Total count for assets.
  /// 資源總數
  int? get totalAssetsCount => _totalAssetsCount.value;
  final Rxn<int?> _totalAssetsCount = Rxn<int?>();

  set totalAssetsCount(int? value) {
    if (value == totalAssetsCount) {
      return;
    }
    _totalAssetsCount.value = value;
  }

  Future<void> getPaths() async {
    // Initial base options.
    // Enable need title for audios and image to get proper display.
    final FilterOptionGroup options = FilterOptionGroup(
      imageOption: const FilterOption(
        needTitle: true,
        sizeConstraint: SizeConstraint(ignoreSize: true),
      ),
      audioOption: const FilterOption(
        needTitle: true,
        sizeConstraint: SizeConstraint(ignoreSize: true),
      ),
      containsPathModified: sortPathsByModifiedDate,
      createTimeCond: DateTimeCond.def().copyWith(ignore: true),
      updateTimeCond: DateTimeCond.def().copyWith(ignore: true),
    );

    // Merge user's filter option into base options if it's not null.
    if (filterOptions != null) {
      options.merge(filterOptions!);
    }

    final List<AssetPathEntity> list = await PhotoManager.getAssetPathList(
      type: requestType,
      filterOption: options,
    );

    _paths.assignAll(list
        .map((AssetPathEntity p) => PathWrapper<AssetPathEntity>(path: p))
        .toList());
    // Sort path using sort path delegate.
    sortPathDelegate.sort(_paths);
    // Use sync method to avoid unnecessary wait.
    _paths
      ..forEach(getAssetCountFromPath)
      ..forEach(getThumbnailFromPath);

    // Set first path entity as current path entity.
    if (_paths.isNotEmpty) {
      currentPath ??= paths.first;
    }
  }

  Completer<void>? _getAssetsFromPathCompleter;

  Future<void> getAssetsFromPath([int? page, AssetPathEntity? path]) {
    Future<void> run() async {
      final int currentPage = page ?? currentAssetsListPage;
      final AssetPathEntity currentPath = path ?? this.currentPath!.path;
      final List<AssetEntity> list = await currentPath.getAssetListPaged(
        page: currentPage,
        size: pageSize,
      );
      if (currentPage == 0) {
        _currentAssets.clear();
      }
      _currentAssets.addAll(list);
      hasAssetsToDisplay = _currentAssets.isNotEmpty;
    }

    if (_getAssetsFromPathCompleter == null) {
      _getAssetsFromPathCompleter = Completer<void>();
      run().then((_) {
        _getAssetsFromPathCompleter!.complete();
      }).catchError((Object e, StackTrace s) {
        _getAssetsFromPathCompleter!.completeError(e, s);
      }).whenComplete(() {
        _getAssetsFromPathCompleter = null;
      });
    }
    return _getAssetsFromPathCompleter!.future;
  }

  @override
  Future<void> loadMoreAssets() => getAssetsFromPath();

  @override
  Future<void> switchPath([PathWrapper<AssetPathEntity>? path]) async {
    assert(
      () {
        if (path == null && _currentPath == null) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary('Switching empty path.'),
            ErrorDescription(
              'Neither "path" nor "currentPathEntity" is non-null, '
              'which makes this method useless.',
            ),
            ErrorHint(
              'You need to pass a non-null path or call this method '
              'when the "currentPath" is not null.',
            ),
          ]);
        }
        return true;
      }(),
    );
    if (path == null && _currentPath == null) {
      return;
    }
    _currentPath.value = path ?? currentPath!;
    await getAssetsFromCurrentPath();
  }

  Future<Uint8List?> getThumbnailFromPath(
    PathWrapper<AssetPathEntity> path,
  ) async {
    if (requestType == RequestType.audio) {
      return null;
    }
    final int assetCount = path.assetCount ?? await path.path.assetCountAsync;
    if (assetCount == 0) {
      return null;
    }
    final List<AssetEntity> assets = await path.path.getAssetListRange(
      start: 0,
      end: 1,
    );
    if (assets.isEmpty) {
      return null;
    }
    final AssetEntity asset = assets.single;
    // Obtain the thumbnail only when the asset is image or video.
    if (asset.type != AssetType.image && asset.type != AssetType.video) {
      return null;
    }
    final Uint8List? data = await asset.thumbnailDataWithSize(
      pathThumbnailSize,
    );
    final int index = paths.indexWhere(
      (PathWrapper<AssetPathEntity> p) => p.path == path.path,
    );
    if (index != -1) {
      paths[index] = paths[index].copyWith(thumbnailData: data);
      //TODO:check update
    }
    return data;
  }

  Future<void> getAssetCountFromPath(PathWrapper<AssetPathEntity> path) async {
    final int assetCount = await path.path.assetCountAsync;
    final int index = paths.indexWhere(
      (PathWrapper<AssetPathEntity> p) => p == path,
    );
    if (index != -1) {
      _paths[index] = _paths[index].copyWith(assetCount: assetCount);
      if (index == 0) {
        currentPath = currentPath?.copyWith(assetCount: assetCount);
      }
      //todo check list update
    }
  }

  /// Get assets list from current path entity.
  /// 从当前已选路径获取资源列表
  Future<void> getAssetsFromCurrentPath() async {
    if (currentPath == null || paths.isEmpty) {
      isAssetsEmpty = true;
      return;
    }
    final PathWrapper<AssetPathEntity> wrapper = currentPath!;
    final int assetCount =
        wrapper.assetCount ?? await wrapper.path.assetCountAsync;
    totalAssetsCount = assetCount;
    isAssetsEmpty = assetCount == 0;
    if (wrapper.assetCount == null) {
      currentPath = currentPath!.copyWith(assetCount: assetCount);
    }
    await getAssetsFromPath(0, currentPath!.path);
  }
}

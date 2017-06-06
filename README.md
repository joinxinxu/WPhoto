判断了系统版本 支持任何的版本 iOS8之前使用了ALAssetsLibrary框架进行封装，iOS8和大于iOS8以后的版本使用photoKit的框架进行封装。
实现了自定义相册，点击弹出相册。
可以自行设置选择相片的长数，可以单选和多选。
直接导入WPhoto可以实现该功能。
使用UIcollectionView和基本的框架进行了基本的封装。

在 ALAssetLibrary 中获取数据，无论是相册，还是资源，本质上都是使用枚举的方式，遍历照片库取得相应的数据，并且数据是从 ALAssetLibrary（照片库）
- ALAssetGroup（相册）- ALAsset（资源）这一路径逐层获取，即使有直接从 ALAssetLibrary 这一层获取 ALAsset 的接口，本质上也是枚举 ALAssetLibrary 所得，
并不是直接获取，这样的好处很明显，就是非常符合实际应用中资源的显示路径：照片库 - 相册 - 图片或视频，但由于采用枚举的方式获取资源，效率低而且不灵活。

而在 PhotoKit 中，则是采用“获取”的方式拉取资源，这些获取的手段，都是一系列形如 class func fetchXXX(..., options: PHFetchOptions) -> PHFetchResult
的类方法，具体使用哪个类方法，则视乎需要获取的是相册、时刻还是资源，这类方法中的 option 充当了过滤器的作用，可以过滤相册的类型，日期，名称等，
从而直接获取对应的资源而不需要枚举。￼


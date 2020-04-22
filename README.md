# LFAssetExportSession

### 视频压缩（体积小，清晰度高）

* 可压缩预设（240p、360p、480p、540P、720p、1080p、2k、4k）。
* 更多进阶压缩方案，可设置videoSettings来实现。
* 框架头文件好像很复杂。实际上调用非常简单。
*  误区：不要认为压缩后视频体积一定会比原视频体积小；

### 压缩效果
以demo的IMG_2300.mov为例。由iPhone8p拍摄。iPhone6s测试。

> 原视频 （2160 × 3840）88.9 MB。压缩为mp4：

压缩预设  | 体积
------ | -------------
240p  | 1.71MB
360p  | 2.58MB
480p  | 4.23MB
540P  | 4.27MB
720p  | 6.91MB
1080p  | 15.45MB
2k  | 23.78MB
4k  | 56.10MB

### 示例代码
````
    // 可选压缩预设
    LFAssetExportSession *encoder = [LFAssetExportSession exportSessionWithAsset:asset preset:LFAssetExportSessionPreset720P];
    encoder.outputFileType = AVFileTypeMPEG4;
    encoder.outputURL = outPath; // 视频输出路径

    [encoder exportAsynchronouslyWithCompletionHandler:^
    {
        if (encoder.status == AVAssetExportSessionStatusCompleted)
        {
            
            NSLog(@"Video export succeeded. video path:%@", encoder.outputURL);
        }
        else if (encoder.status == AVAssetExportSessionStatusCancelled)
        {
            NSLog(@"Video export cancelled");
        }
        else
        {
            NSLog(@"Video export failed with error: %@ (%ld)", encoder.error.localizedDescription, (long)encoder.error.code);
        }
    }];
````

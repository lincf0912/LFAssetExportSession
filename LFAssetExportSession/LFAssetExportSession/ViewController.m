//
//  ViewController.m
//  LFAssetExportSession
//
//  Created by TsanFeng Lam on 2020/4/10.
//  Copyright © 2020 lfsampleprojects. All rights reserved.
//

#import "ViewController.h"
#import "LFAssetExportSession.h"

@interface NSString (LFFileSize)

- (u_int64_t)lf_fileSize;

@end

@implementation NSString (LFFileSize)

- (u_int64_t)lf_fileSize
{
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager new]; // default is not thread safe
    if ([fileManager fileExistsAtPath:self]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:self error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}

@end

@interface ViewController () <LFAssetExportSessionDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UIButton *albumBtn;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmented;

@property (strong, nonatomic) LFAssetExportSession *encoder;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)openAlbum:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//指定数据来源是相册
    
    picker.mediaTypes = [NSArray arrayWithObjects:@"public.movie",  nil];
    
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)startAction:(id)sender {
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"IMG_2300" ofType:@"mov"];
    [self _encodeVideoWithURL:[NSURL fileURLWithPath:videoPath]];
}
- (IBAction)stopAction:(id)sender {
    [self.encoder cancelExport];
    self.encoder = nil;
}

- (NSString *)tmpVideo
{
    NSString *videoPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"video"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:videoPath]) {
        [fileManager createDirectoryAtPath:videoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return videoPath;
}

- (NSString *)createFile:(NSString *)name
{
    NSString *path = [[self tmpVideo] stringByAppendingPathComponent:name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
    return path;
}

- (NSString *)fileName
{
    return [NSString stringWithFormat:@"%@.mp4", [self.segmented titleForSegmentAtIndex:self.segmented.selectedSegmentIndex]];
}

- (void)_encodeVideoWithURL:(NSURL *)videoURL
{
    self.startBtn.enabled = NO;
    self.albumBtn.enabled = NO;
    self.stopBtn.enabled = YES;
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoURL];
    
    NSURL *outPath = [NSURL fileURLWithPath:[self createFile:[self fileName]]];
    
    
    LFAssetExportSession *encoder = [LFAssetExportSession exportSessionWithAsset:asset preset:(LFAssetExportSessionPreset)self.segmented.selectedSegmentIndex];
    encoder.delegate = self;
    encoder.outputFileType = AVFileTypeMPEG4;
    encoder.outputURL = outPath;

    
//    CMTime time = [asset duration];
//    encoder.timeRange = CMTimeRangeMake(CMTimeMake(0, time.timescale), CMTimeMake(1, time.timescale));
    NSLog(@"The compressed file size is about %.2fMB", encoder.estimatedExportSize/1000.0);

    [encoder exportAsynchronouslyWithCompletionHandler:^
    {
        if (encoder.status == AVAssetExportSessionStatusCompleted)
        {
            
            NSLog(@"Video export succeeded. video path:%@", encoder.outputURL);
            NSLog(@"video size:%.2fMB", [encoder.outputURL.relativePath lf_fileSize]/1024.0/1024.0);
        }
        else if (encoder.status == AVAssetExportSessionStatusCancelled)
        {
            NSLog(@"Video export cancelled");
        }
        else
        {
            NSLog(@"Video export failed with error: %@ (%ld)", encoder.error.localizedDescription, (long)encoder.error.code);
        }
        self.startBtn.enabled = YES;
        self.albumBtn.enabled = YES;
        self.stopBtn.enabled = NO;
    }];
    
    self.encoder = encoder;

}

#pragma mark - LFAssetExportSessionDelegate
- (void)assetExportSessionDidProgress:(LFAssetExportSession *)assetExportSession
{
    NSLog(@"%f", assetExportSession.progress);
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
        
    if ([mediaType isEqualToString:@"public.movie"]){
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];//获得视频的URL
        
        [self _encodeVideoWithURL:url];
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
}

@end

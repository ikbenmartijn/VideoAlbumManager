**Work in progress.**
*For now, you can only use this class to add albums and add videos to specified albums. Deleting, moving, ... will arrive as my needs grow. Or when people fork this repo :)*

## VideoAlbumManager

Manages the creation and curation of video albums in your Photos app on iOS

## Use

### Check if an album exists

```
if (![VideoAlbumManager albumWithAlbumName:@"your fancy albumname"]) {
	NSLog(@"Album exists...");
}
else {
	NSLog(@"Album does not exists...");
}
```

### If necessary, add the album to Photos app

```
[VideoAlbumManager addAlbumWithAlbumName:@"your fancy albumname"];
```

### Add a video asset to an album

Here shown in a delegate method

``` 
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    BOOL recordingWasSuccesvol = YES;
    if ([error code] != noErr) {
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
        {
            opnameIsSuccesvol = [value boolValue];
        }
    }
    if (recordingWasSuccesvol) {
		ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL])
        {
            [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
                                        completionBlock:^(NSURL *assetURL, NSError *error) {
                                            //error handling
                                            if (error != nil) {
												//Errorhandling
                                            }
											else {
                                                [VideoAlbumManager addVideoWithAssetURL:assetURL toAlbumWithName:@"your fancy albumname"];
											}
                                        }];
        }
    }
}
```

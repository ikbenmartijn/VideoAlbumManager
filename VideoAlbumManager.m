//
//  VideoAlbumManager.m
//
//  Created by Martijn on 10/12/13.
//  Copyright (c) 2013 Martijn Vandenberghe. All rights reserved.
//

#import "VideoAlbumManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation VideoAlbumManager

+ (BOOL)albumWithAlbumName:(NSString*)albumName {
	__block BOOL exists = NO;
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	[library enumerateGroupsWithTypes:ALAssetsGroupAlbum
						   usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
							   if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
								   NSLog(@"<VideoAlbumManager> Album '%@' found", albumName);
								   exists = YES;
							   }
						   }
						 failureBlock:^(NSError* error) {
							 NSLog(@"<VideoAlbumManager> Error enumerating the albums:\nError: %@", [error localizedDescription]);
							 exists = NO;
						 }];
	return exists;
}

+ (void)addAlbumWithAlbumName:(NSString *)albumName {
	NSLog(@"<VideoAlbumManager> Poging om album '%@' aan te maken", albumName);
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	[library addAssetsGroupAlbumWithName:albumName
							 resultBlock:^(ALAssetsGroup *group) {
								 NSLog(@"<VideoAlbumManager> Album '%@' created", albumName);
							 }
							failureBlock:^(NSError *error) {
								NSLog(@"<VideoAlbumManager> Error creating the album:\nError: %@", [error localizesDescription]);
							}];
}
    
+ (void)addVideoWithAssetURL:(NSURL*)assetURL toAlbumWithName:(NSString*)albumName {
	__block ALAssetsGroup* groupToAddTo;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	[library enumerateGroupsWithTypes:ALAssetsGroupAlbum
						   usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
							   if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
								   NSLog(@"<VideoAlbumManager> Album '%@' found, open for new items...", albumName);
								   groupToAddTo = group;
							   }
						   }
						 failureBlock:^(NSError* error) {
							 NSLog(@"<VideoAlbumManager> Error enumerating the albums:\nError: %@", [error localizedDescription]);
						 }];
	
	[library assetForURL:assetURL
			 resultBlock:^(ALAsset *asset) {
				 //Voeg de video toe aan de groep
				 [groupToAddTo addAsset:asset];
				 NSLog(@"<VideoAlbumManager> Video '%@' added to album '%@'", [[asset defaultRepresentation] filename], albumName);
			 }
			failureBlock:^(NSError* error) {
				NSLog(@"<VideoAlbumManager> Error adding video '%@' to album '%@':\nError: %@ ", [[asset defaultRepresentation] filename], albumName, [error localizedDescription]);
			}];
}

@end

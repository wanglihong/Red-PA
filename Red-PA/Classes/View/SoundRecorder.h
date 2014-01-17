//
//  SoundRecorder.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol SoundRecorderDelegate <NSObject>

- (void)soundRecordDidFinishWithFile:(NSString *)filePath;
- (void)transformFinishedWithFile:(NSString *)filePath;

@end

@interface SoundRecorder : UIView <AVAudioPlayerDelegate,AVAudioRecorderDelegate,AVAudioSessionDelegate> {
    AVAudioSession  *audioSession;
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer   *audioPlayer;
    NSString        *documentsPath;
    NSString        *audioFileName;
    NSString        *audioFilePath;
    NSString        *__mp3FileName;
    NSString        *__mp3FilePath;
    NSString        *__amrFileName;
    NSString        *__amrFilePath;
    NSURL           *pathURL;
    NSTimer         *levelTimer;
    UIImageView     *recordView;
    
    id<SoundRecorderDelegate> delegate;
    BOOL recording;
    BOOL playing;
}

@property (nonatomic, assign) id<SoundRecorderDelegate> delegate;
@property (nonatomic, retain) NSTimer *levelTimer;

- (void)startRecord;
- (void)stopRecord;
- (void)transformFile;
- (void)startPlay;
- (void)stopPlay;

@end

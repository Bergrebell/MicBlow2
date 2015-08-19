//
//  ViewController.h
//  MicBlow
//
//  Created by Roman Küpper on 8/13/15.
//  Copyright (c) 2015 Roman Küpper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreAudio/CoreAudioTypes.h>


@interface ViewController : UIViewController {
    
    AVAudioRecorder *recorder;
    NSTimer *leveltimer;
    
    AVCaptureSession *CaptureSession;
    AVCaptureMovieFileOutput *MovieFileOutput;
    AVCaptureDeviceInput *VideoInputDevice;
    
}

@property (weak, nonatomic) IBOutlet UILabel *AverageInput;
@property (weak, nonatomic) IBOutlet UILabel *PeakInput;
@property (weak, nonatomic) IBOutlet UILabel *Luminosity;




-(void)levelTimerCallback:(NSTimer *)timer;





@end

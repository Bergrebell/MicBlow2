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

// Luminosity2
#import <ImageIO/ImageIO.h>

#define CAPTURE_FRAMES_PER_SECOND		20

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
// Luminosity2

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection;



@end

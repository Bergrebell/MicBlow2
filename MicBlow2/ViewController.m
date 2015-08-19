//
//  ViewController.m
//  MicBlow
//
//  Created by Roman Küpper on 8/13/15.
//  Copyright (c) 2015 Roman Küpper. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

// method runs everytime the NSTimer is fired
- (void)levelTimerCallback:(NSTimer *)timer {
    [recorder updateMeters];
    
    float averageNS = [recorder averagePowerForChannel:0];
    NSString *averageString = [NSString stringWithFormat:@"Average: %f", averageNS];
    self.AverageInput.text = averageString;
    
    
    float peakNS = [recorder peakPowerForChannel:0];
    NSString *peakString = [NSString stringWithFormat:@"Peak: %f", peakNS];
    self.PeakInput.text = peakString;
    
    NSLog(@"Average input: %f Peak input: %f", [recorder averagePowerForChannel:0], [recorder peakPowerForChannel:0]);
    
    // testing luminosity
    float lumin = [[UIScreen mainScreen] brightness];
    NSString *luminString = [NSString stringWithFormat:@"LuminosityAuto: %f", lumin];
    self.Luminosity.text = luminString;
    
    
    NSLog(@"Screen Brightness: %f",[[UIScreen mainScreen] brightness]);
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
    GPUImageVideoCamera *videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    
    
    GPUImageLuminosity*lumin = [[GPUImageLuminosity alloc] init];
    [videoCamera addTarget:lumin];
    
    
    
    [(GPUImageLuminosity *)lumin setLuminosityProcessingFinishedBlock:^(CGFloat luminosity, CMTime frameTime) {
        // Do something with the luminosity here
        
        NSLog(@"Lumin is %f ", luminosity);
    }];
    
    [videoCamera startCameraCapture];
    
    
    
    
    
    
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];
    
    NSError *error;
    
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
    if (recorder) {
        [recorder prepareToRecord];
        recorder.meteringEnabled = YES;
        [recorder record];
        // Set NSTimer settings
        leveltimer = [NSTimer scheduledTimerWithTimeInterval: 0.03
                                                      target: self
                      /* everytime the timer is fired it sends
                       a message to the levelTimerCallback function */
                                                    selector: @selector(levelTimerCallback:)
                                                    userInfo: nil
                                                     repeats: YES];

    } else
        NSLog([error description]);
    
    
    
    
    
    
    
    
    
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




// Luminosity2

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{

    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,
                                                                 sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc]
                              initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata
                                   objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata
                              objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    NSLog(@"AVCapture: %f", brightnessValue);
}





























@end

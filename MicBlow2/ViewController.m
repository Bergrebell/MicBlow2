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
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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

@end

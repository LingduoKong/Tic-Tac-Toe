//
//  ViewController.h
//  tic tac snow
//
//  Created by Lingduo Kong on 2/6/15.
//  Copyright (c) 2015 Lingduo Kong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameInfo.h"
#import "XandOimage.h"
#import "DrawLine.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController
<UIGestureRecognizerDelegate, UIAlertViewDelegate, AVAudioPlayerDelegate>

@property NSMutableArray *gridArray;
@property UIPanGestureRecognizer *xpan;
@property UIPanGestureRecognizer *opan;
@property XandOimage* x_imageView;
@property XandOimage* o_imageView;

- (IBAction)info_button:(id)sender;


@property int step_num;
@property (weak, nonatomic) NSString *soundPath;
@property (nonatomic) AVAudioPlayer * audio;

@property (strong, nonatomic) GameInfo *infopage;
@property DrawLine* line;

@property CGFloat height;
@property CGFloat width;

@end


//
//  ViewController.m
//  tic tac snow
//
//  Created by Lingduo Kong on 2/6/15.
//  Copyright (c) 2015 Lingduo Kong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _height = self.view.frame.size.height;
    _width = self.view.frame.size.width;
    // Do any additional setup after loading the view, typically from a nib.
    [self Initial];
    
    self.xpan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(PanPiece:)];
    [self.xpan setMaximumNumberOfTouches:1];
    [self.xpan setDelegate:self];
    [self.x_imageView addGestureRecognizer:self.xpan];
    
    self.opan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(PanPiece:)];
    [self.opan setMaximumNumberOfTouches:1];
    [self.opan setDelegate:self];
    [self.o_imageView addGestureRecognizer:self.opan];
    
    [self checkAndChange];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma InfoButton

- (IBAction)info_button:(id)sender {
    _infopage = [[GameInfo alloc] initWithFrame: CGRectMake(0, -_height,_width,_height)];
    [self.view addSubview: _infopage];
    [UIView animateWithDuration:2.0 animations:^{
        [_infopage setCenter:CGPointMake(_width/2, _height/2)];
    }];   
}

#pragma initial

-(void)Initial{
    _step_num = 0;
    [self addInitViews];
    [self addXandOViews];
    [self ExtandandShrink:10];
}

#pragma addViews

-(void)addInitViews{
    
    float height = _height/2;
    float width = _width/3;
    float length = width - 20;
    
    UIImageView* grid = [[UIImageView alloc] initWithFrame:CGRectMake(0,height-width*3/2, width*3, height+30)];
    grid.backgroundColor = [UIColor blueColor];
    [self.view addSubview:grid];
    
    UIImageView* grid11 = [[UIImageView alloc] initWithFrame:CGRectMake(10, height - length/2 - width, length, length)];
    UIImageView* grid12 = [[UIImageView alloc] initWithFrame:CGRectMake(30 + length, height - length/2 - width, length, length)];
    UIImageView* grid13 = [[UIImageView alloc] initWithFrame:CGRectMake(50 + 2*length, height - length/2 - width, length, length)];
    UIImageView* grid21 = [[UIImageView alloc] initWithFrame:CGRectMake(10, height - length/2, length, length)];
    UIImageView* grid22 = [[UIImageView alloc] initWithFrame:CGRectMake(30 + length, height - length/2, length, length)];
    UIImageView* grid23 = [[UIImageView alloc] initWithFrame:CGRectMake(50 + 2*length, height - length/2, length, length)];
    UIImageView* grid31 = [[UIImageView alloc] initWithFrame:CGRectMake(10, height + width/2, length, length)];
    UIImageView* grid32 = [[UIImageView alloc] initWithFrame:CGRectMake(30 + length, height + width/2, length, length)];
    UIImageView* grid33 = [[UIImageView alloc] initWithFrame:CGRectMake(50 + 2*length, height + width/2, length, length)];
    
    _gridArray = [[NSMutableArray alloc] initWithObjects: grid11, grid12, grid13, grid21, grid22, grid23, grid31, grid32, grid33, nil];
    
    for (int i = 0; i <= 8; i++) {
        UIImageView* iv = [self.gridArray objectAtIndex:i];
        iv.image = nil;
        iv.backgroundColor = [UIColor whiteColor];
        iv.tag = i+1;
        [self.view addSubview:iv];
    }
}

-(void)addXandOViews{

    _x_imageView = [[XandOimage alloc] initWithFrame:CGRectMake(0, _height - 90, 90, 90)];
    self.x_imageView.image = [UIImage imageNamed:@"x.png"];
    self.x_imageView.tag = 11;
    _o_imageView = [[XandOimage alloc] initWithFrame:CGRectMake(_width-90, _height - 90, 90, 90)];
    self.o_imageView.image = [UIImage imageNamed:@"circle.png"];
    self.o_imageView.tag = 10;
    [self.view addSubview:_x_imageView];
    [self.view addSubview:_o_imageView];
}



#pragma panPiece

-(void)PanPiece: (UIPanGestureRecognizer*)sender{
    
    UIView *piece = [sender view];
    [[piece superview] bringSubviewToFront:piece];
    CGFloat centery;
    CGFloat centerx;
    NSString *imageName;
    if (piece.tag==11) {
        centery = _height
        - _x_imageView.frame.size.height/2;
        centerx = _x_imageView.frame.size.height/2;
        imageName = @"x.png";
    }
    else{
        centery = _height - _o_imageView.frame.size.height/2;
        centerx = _width-_o_imageView.frame.size.height/2;
        imageName = @"circle.png";
    }

    if ([sender state]==UIGestureRecognizerStateBegan) {
        [self playAudio:@"begin_drag"];
    }
    if ([sender state] == UIGestureRecognizerStateBegan ||
        [sender state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:[piece superview]];
        [piece setCenter:CGPointMake([piece center].x + translation.x,
                                     [piece center].y + translation.y)];
        [sender setTranslation:CGPointZero inView:[piece superview]];
    }
    
    // detect edge
    if ([sender state] == UIGestureRecognizerStateEnded) {
        for (int i = 0; i < 9; i++) {
            UIImageView *v = [self.gridArray objectAtIndex:i];
            if (CGRectIntersectsRect(piece.frame, v.frame)) {
                if(v.image==nil){
                    [self playAudio:@"fit_in"];
                    v.image = [UIImage imageNamed:imageName];
                    [piece setCenter:CGPointMake(centerx,centery)];
                    self.step_num = self.step_num+1;
                    if ([self isWin:[piece tag]]) {
                        [self playAudio:@"win"];
                    }
                    else {
                        [self ExtandandShrink:piece.tag];
                        [self checkAndChange];
                    }
                    break;
                }
                else [self playAudio:@"full"];
            }
        }

        [UIView animateWithDuration:2.0 animations:^{
            [piece setCenter:CGPointMake(centerx,centery)];
        }];
        [sender setTranslation:CGPointZero inView:[piece superview]];
    }
}

#pragma change status

-(void)checkAndChange{
    if (self.step_num%2==0) {
        [self.x_imageView setUserInteractionEnabled:YES];
        self.x_imageView.alpha=1;
        [self.o_imageView setUserInteractionEnabled:NO];
        self.o_imageView.alpha=0.5f;
    }
    else if (self.step_num%2!=0) {
        [self.o_imageView setUserInteractionEnabled:YES];
        self.o_imageView.alpha=1;
        [self.x_imageView setUserInteractionEnabled:NO];
        self.x_imageView.alpha=0.5f;
    }
    else {
        [self.x_imageView setUserInteractionEnabled:NO];
        self.x_imageView.alpha=0.5f;
        [self.o_imageView setUserInteractionEnabled:NO];
        self.o_imageView.alpha=0.5f;
    }
}

#pragma factor is 2

-(void)ExtandandShrink:(NSInteger)tag{
    CGFloat pieceHeight = _o_imageView.frame.size.height;
    CGFloat pieceWidth = _o_imageView.frame.size.width;
    if (tag==11) {
        [UIView animateWithDuration:1.0 animations:^{
            [_o_imageView setFrame:CGRectMake(_width-pieceWidth*2, _height-pieceHeight*2, pieceWidth*2, pieceHeight*2)];
        }
                         completion:^(BOOL completed){
                             [UIView animateWithDuration:2.0 animations:^{
                                 [_o_imageView setFrame:CGRectMake(_width-pieceWidth, _height-pieceHeight, pieceWidth, pieceHeight)];
                             }];
                         }];
    }
    else if (tag==10) {
        [UIView animateWithDuration:1.0 animations:^{
            [_x_imageView setFrame:CGRectMake(0, _height-pieceHeight*2, pieceWidth*2, pieceHeight*2)];
        }
                         completion:^(BOOL completed){
                             [UIView animateWithDuration:2.0 animations:^{
                                 [_x_imageView setFrame:CGRectMake(0, _height-pieceHeight, pieceWidth, pieceHeight)];
                             }];
                         }];
    }
}

#pragma WinOrNot

-(BOOL)isWin: (NSInteger)tag{
    UIImageView* grid11 = [self.gridArray objectAtIndex:0];
    UIImageView* grid12 = [self.gridArray objectAtIndex:1];
    UIImageView* grid13 = [self.gridArray objectAtIndex:2];
    UIImageView* grid21 = [self.gridArray objectAtIndex:3];
    UIImageView* grid22 = [self.gridArray objectAtIndex:4];
    UIImageView* grid23 = [self.gridArray objectAtIndex:5];
    UIImageView* grid31 = [self.gridArray objectAtIndex:6];
    UIImageView* grid32 = [self.gridArray objectAtIndex:7];
    UIImageView* grid33 = [self.gridArray objectAtIndex:8];
    
    BOOL iswin = false;
    NSMutableArray *linePoint = [[NSMutableArray alloc] initWithObjects:nil];
    
    if ([grid11.image isEqual:grid12.image] && [grid11.image isEqual:grid13.image]) {
        iswin = true;
        [linePoint addObject:grid11];
        [linePoint addObject:grid13];
    }
    else if ([grid21.image isEqual:grid22.image] && [grid21.image isEqual:grid23.image]) {
        iswin = true;
        [linePoint addObject:grid21];
        [linePoint addObject:grid23];
    }
    else if ([grid31.image isEqual:grid32.image] && [grid31.image isEqual:grid33.image]) {
        iswin = true;
        [linePoint addObject:grid31];
        [linePoint addObject:grid33];
    }
    else if ([grid11.image isEqual:grid21.image] && [grid21.image isEqual:grid31.image]) {
        iswin = true;
        [linePoint addObject:grid11];
        [linePoint addObject:grid31];
    }
    else if ([grid12.image isEqual:grid22.image] && [grid12.image isEqual:grid32.image]) {
        iswin = true;
        [linePoint addObject:grid12];
        [linePoint addObject:grid32];
    }
    else if ([grid13.image isEqual:grid23.image] && [grid13.image isEqual:grid33.image]) {
        iswin = true;
        [linePoint addObject:grid13];
        [linePoint addObject:grid33];
    }
    else if ([grid11.image isEqual:grid22.image] && [grid33.image isEqual:grid22.image]) {
        iswin = true;
        [linePoint addObject:grid11];
        [linePoint addObject:grid33];
    }
    else if ([grid13.image isEqual:grid22.image] && [grid13.image isEqual:grid31.image]) {
        iswin = true;
        [linePoint addObject:grid13];
        [linePoint addObject:grid31];
    }
    else
        iswin = false;
    
    if (iswin) {
        UIImageView *point1 = [linePoint objectAtIndex:0];
        UIImageView *point2 = [linePoint objectAtIndex:1];
        CGPoint aPoints[2];
        aPoints[0] =CGPointMake([point1 center].x, [point1 center].y);//start point
        aPoints[1] =CGPointMake([point2 center].x, [point2 center].y);//end point
        //坐标数组
        
        [self drawLine:aPoints[1] :aPoints[0]];
        
        NSString *str = nil;
        if (tag==11) {
            str = @"x wins";
        }
        else str = @"o wins";
        UIAlertView *endAlert = [[UIAlertView alloc] initWithTitle:@"Game Over!" message:str delegate:self
                                                 cancelButtonTitle:@"New Game" otherButtonTitles:nil];
        [endAlert show];
    }
    return iswin;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"New Game"])
    {
        [[alertView delegate] GameEnd];
    }
}

#pragma drawline

-(void)drawLine: (CGPoint) first : (CGPoint) second{
    _line = [[DrawLine alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
    _line.startX = first.x;
    _line.startY = first.y;
    _line.endX = second.x;
    _line.endY = second.y;
    _line.backgroundColor = [UIColor clearColor];
    _line.tag = 100;
    [self.view addSubview:_line];
}


#pragma playsound

-(void)playAudio:(NSString*)path{
    
    self.soundPath = [[NSBundle mainBundle]pathForResource:path ofType:@"wav"];
    self.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.soundPath] error:NULL];
    self.audio.meteringEnabled = YES;
    self.audio.delegate = self;
    [self.audio prepareToPlay];
    [self.audio play];    
}
#pragma gameend

-(void)GameEnd{
    _step_num = 0;
    for (int i = 0; i < 9; i++) {
        ((UIImageView*)[self.view viewWithTag:i+1]).image=nil;
    }
    [self checkAndChange];
    [self ExtandandShrink:10];
    [self.line setCenter:CGPointMake(_width*2, _height*2)];
}

@end

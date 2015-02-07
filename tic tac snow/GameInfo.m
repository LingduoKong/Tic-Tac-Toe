//
//  GameInfo.m
//  tic tac snow
//
//  Created by Lingduo Kong on 2/6/15.
//  Copyright (c) 2015 Lingduo Kong. All rights reserved.
//

#import "GameInfo.h"

@implementation GameInfo

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    UITextView *text = [[UITextView alloc] initWithFrame: CGRectMake(10, 20, width-20, height-30)];
    text.editable =false;
    text.text = @"\nTic-tac-toe (or Noughts and crosses, Xs and Os) is a paper-and-pencil game for two players, X and O, who take turns marking the spaces in a 3×3 grid. The player who succeeds in placing three respective marks in a horizontal, vertical, or diagonal row wins the game.";
    text.backgroundColor = [UIColor purpleColor];
    [self addSubview:text];
    
    
    UIButton *dismiss = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [dismiss setTitle:@"dismiss" forState:UIControlStateNormal];
    dismiss.backgroundColor = [UIColor grayColor];
    dismiss.layer.cornerRadius = 5;
    dismiss.clipsToBounds = YES;
    dismiss.tag = 1;
    [dismiss setFrame:CGRectMake(width/2-30,height-60,60,20)];
    
    [self addSubview:dismiss];
    [dismiss addTarget:self action:@selector(pressButton:) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    
    return self;
}

-(void) pressButton: (UIButton *)sender {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    if (sender.tag==1) {
        [UIView animateWithDuration:2.0 animations:^{
            [self setCenter:CGPointMake(width/2,3*height/2)];
        }];
    }
    
}

@end

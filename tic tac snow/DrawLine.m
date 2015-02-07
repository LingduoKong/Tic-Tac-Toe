//
//  DrawLine.m
//  tic tac snow
//
//  Created by Lingduo Kong on 2/6/15.
//  Copyright (c) 2015 Lingduo Kong. All rights reserved.
//

#import "DrawLine.h"

@implementation DrawLine

//- (id)initWithFrameCustomed:(CGRect)frame :(CGFloat)startX : (CGFloat)startY : (CGFloat)endX : (CGFloat)endY
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.startX = startX;
//        self.startY = startY;
//        self.endX = endX;
//        self.endY = endY;
//    }
//    return self;
//}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context,0, 0, 255,1.0);//颜色
    CGContextSetLineWidth(context, 4.0);//width of the line
    CGPoint aPoints[2];
    aPoints[0] =CGPointMake(self.startX, self.startY);//start point
    aPoints[1] =CGPointMake(self.endX, self.endY);//end point
    //坐标数组
    CGContextAddLines(context, aPoints, 2);//add this line
    CGContextDrawPath(context, kCGPathStroke); //draw path according to the points.
}

@end

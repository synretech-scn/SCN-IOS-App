//
//  CashFlowGraphView.m
//  BusinessForecaster_iPadApp
//
//  Created by clicklabs on 6/17/14.
//  Copyright (c) 2014 Samar Singla. All rights reserved.

#import "LineGraph.h"
@implementation LineGraph
{
//    float dataArray[20] ;
    NSMutableArray *dataarray;
    float max_closing_cash;
    NSMutableArray *values_todraw_color_filledpath;
    NSMutableArray *dateArray;
    NSMutableArray *closing_cash_values;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// GRAPH DATA
-(void)lineGraphData:(NSArray *)data xAxis:(NSString *)xKey yAxis:(NSString *)yKey
{
    //FOR AVERAGE SCORE GRAPH
    values_todraw_color_filledpath = [[NSMutableArray alloc]init];
    dateArray=[[NSMutableArray alloc]init];
    dataarray=[NSMutableArray new];
    closing_cash_values=[[NSMutableArray alloc ]init];
    NSLog(@"data count==%lu",(unsigned long)data.count);
    NSDictionary *tempdic=[[NSDictionary alloc]initWithObjectsAndKeys:@"18",yKey, nil];
    NSMutableArray *temparray=[[NSMutableArray alloc]init];
    for(int i=0;i<2;i++)
    {
        [temparray addObject:tempdic];
    }
    NSLog(@"avg=%@",[[data objectAtIndex:0] objectForKey:yKey]);
    for(int i=0;i<data.count;i++)
    {
        [closing_cash_values addObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i] objectForKey:yKey]]];
        [dateArray addObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i] objectForKey:xKey]]];
    }
//    max_closing_cash=abs((int)[[closing_cash_values objectAtIndex:0]integerValue]);
    max_closing_cash=round([[closing_cash_values objectAtIndex:0] floatValue]);

    for(int monthscount=0;monthscount<closing_cash_values.count;monthscount++)
    {
        if(max_closing_cash<round([[closing_cash_values objectAtIndex:monthscount]floatValue]))
        {
            max_closing_cash=round([[closing_cash_values objectAtIndex:monthscount]floatValue]);
        }
    }
    // Assigning values to values_todraw_color_filledpath array
    for( int monthscount=0;monthscount<[closing_cash_values count];monthscount++)
    {
        if(max_closing_cash!=0)
        {
            [values_todraw_color_filledpath addObject:[NSString stringWithFormat:@"%f",([[closing_cash_values objectAtIndex:monthscount]floatValue]/max_closing_cash)]];
        }
        else
        {
            [values_todraw_color_filledpath addObject:@"0"];
        }
    }
}

//LINE DRAWING FUNCTION and FILLING AREA

-(void)drawLineGraphWithContext:(CGContextRef)ctx
{
    for(int i=0;i<[values_todraw_color_filledpath count];i++)
    {
//        dataArray[i]=1.3*[[values_todraw_color_filledpath objectAtIndex:i]floatValue];
        [dataarray addObject:[NSString stringWithFormat:@"%f",1.55*[[values_todraw_color_filledpath objectAtIndex:i]floatValue]]];
    }
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:52/255.0f green:174/255.0f blue:245/255.0f alpha:1.0].CGColor);
    CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
    CGContextSetLineWidth(ctx, 2.0);
    CGPoint startPoint ;//= CGPointMake(85, 360);
    CGPoint endPoint ;//= CGPointMake(725, 360);
    float varing_xcordiante=70;
    float varing_ycordiante=(kGraphHeight-[[dataarray objectAtIndex:0] floatValue]*100);
    NSLog(@"varing_ycordiante  =%f",varing_ycordiante);
    

    UILabel *valueLabel=[[UILabel alloc]init];
    valueLabel.frame =CGRectMake(varing_xcordiante-31,varing_ycordiante-15, 30, 15);
    valueLabel.backgroundColor =  [UIColor clearColor] ;
    valueLabel.textAlignment=NSTextAlignmentRight;
    NSLog(@"formatter value=%.1f",[[closing_cash_values objectAtIndex:0] floatValue]);
    valueLabel.text=[NSString stringWithFormat:@"%d",[[closing_cash_values objectAtIndex:0] integerValue]];
    valueLabel.font=[UIFont fontWithName:AvenirRegular size:XbGraphLabelsize];
    valueLabel.textColor=[UIColor whiteColor];
    valueLabel.adjustsFontSizeToFitWidth=YES;
    valueLabel.userInteractionEnabled =NO;
    [self addSubview:valueLabel];
    if(dataarray.count > 0)
    {
    for(int i=0;i< dataarray.count-1;i++)
    {
        startPoint = CGPointMake(varing_xcordiante, varing_ycordiante);
        endPoint = CGPointMake(varing_xcordiante+60, (kGraphHeight-[[dataarray objectAtIndex:i+1] floatValue]*100));
        
        CGContextMoveToPoint(ctx, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y);
        varing_xcordiante=endPoint.x;
        varing_ycordiante=endPoint.y;

        UILabel *valueLabel=[[UILabel alloc]init];
        valueLabel.frame =CGRectMake(varing_xcordiante+6,varing_ycordiante-4, 30, 15);
        valueLabel.backgroundColor =  [UIColor clearColor] ;
         valueLabel.text=[NSString stringWithFormat:@"%d",[[closing_cash_values objectAtIndex:i+1] integerValue]];
        valueLabel.font=[UIFont fontWithName:AvenirRegular size:XbGraphLabelsize];
        valueLabel.textColor=[UIColor whiteColor];
        valueLabel.userInteractionEnabled =NO;
        valueLabel.adjustsFontSizeToFitWidth=YES;
        [self addSubview:valueLabel];

    }
    }
    if(dataarray.count==1)
    {
        UILabel *label1 = [[UILabel alloc]init];
        label1.frame =CGRectMake(varing_xcordiante-2.5,varing_ycordiante-2.5, 5, 5);
        label1.layer.cornerRadius=2.5;
        label1.layer.masksToBounds=YES;
        label1.lineBreakMode=NSLineBreakByCharWrapping;
        label1.backgroundColor =  [UIColor colorWithRed:52/255.0f green:174/255.0f blue:245/255.0f alpha:1.0] ;
        label1.font=[UIFont fontWithName:AvenirRegular size:XbGraphLabelsize];
        label1.userInteractionEnabled =NO;
        label1.adjustsFontSizeToFitWidth=YES;
        [self addSubview:label1];
        
    }
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

- (void)drawRect:(CGRect)rect
{
    @autoreleasepool
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 0.6);
        CGFloat dash[] = {2.0, 2.0};
        CGContextSetLineDash(context, 0.0, dash, 0);
        CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
        CGContextSetTextDrawingMode(context, kCGTextFill);
        CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
        
        NSString *theTextHeight;
        float varing_height_of_dashes=kGraphHeight;

        
        //showing positive values vertically on left side in black color
        int positivevaluecount=1;
        if(max_closing_cash==0.0)
        {
            positivevaluecount=1;
        }
        else{
            positivevaluecount=7;
        }
        for (int positive_values=0; positive_values<positivevaluecount; positive_values++)
        {
            NSNumberFormatter *formatterfloat = [[NSNumberFormatter alloc] init];
            [formatterfloat setNumberStyle:NSNumberFormatterDecimalStyle];
            [formatterfloat setMaximumFractionDigits:2];
            [formatterfloat setAllowsFloats:YES];
            // NSNumber *number = [NSNumber numberWithFloat:((max_closing_cash/6)*positive_values)];
            //numberround = [NSNumber numberWithFloat:dollarvalue];
            float drawvalue=((max_closing_cash/6.0)*positive_values);
            if(positive_values == 6)
                drawvalue= [[closing_cash_values valueForKeyPath:@"@max.intValue"] floatValue];
            NSNumber *numberdeci = [NSNumber numberWithFloat:drawvalue];
            NSString  *dollarvalueinstring=[formatterfloat stringFromNumber:numberdeci];
            
            theTextHeight=dollarvalueinstring;
            UIColor *color = [UIColor whiteColor]; //\\put something else here...
            UIFont *ffont=[UIFont fontWithName:AvenirRegular size:XbGraphLabelsize];
            NSArray *color_array=[[NSArray alloc]initWithObjects:color,ffont, nil];
            NSArray *keeys_array=[[NSArray alloc]initWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil];
            NSDictionary *attributes = [NSDictionary dictionaryWithObjects:color_array forKeys:keeys_array];
            if(positive_values==0)
            {
                theTextHeight=@"0";
            }
            [theTextHeight drawAtPoint:CGPointMake(14, varing_height_of_dashes-8) withAttributes:attributes];
            varing_height_of_dashes=varing_height_of_dashes-klinemaxheight/6;
        }
        
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        
        //finding horizontal line length
        int lengthCount=0;
        if(values_todraw_color_filledpath.count<6)
        {
            lengthCount=6;
        }
        else{
            lengthCount=(int)values_todraw_color_filledpath.count;
        }
        
        //drawing background  horizontal line
        float varing_ycordinate=kGraphHeight;
        varing_ycordinate=varing_ycordinate-klinemaxheight/6;
        for(int i=0;i<6;i++)
        {
            CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
            CGPoint startPoint = CGPointMake(50, varing_ycordinate);
            CGPoint endPoint = CGPointMake(50+lengthCount*70+40, varing_ycordinate);
            CGContextMoveToPoint(context, startPoint.x, startPoint.y);
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
            varing_ycordinate=varing_ycordinate-klinemaxheight/6;
        }
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
        
        
        int varing_xcordinate=70;
        //dashes on base line
        for (int i=0;i<dateArray.count;i++)
        {
            CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
            CGPoint startPointDiv = CGPointMake(varing_xcordinate, kGraphHeight-5);
            CGPoint endPointDiv = CGPointMake(varing_xcordinate, kGraphHeight);
            CGContextMoveToPoint(context, startPointDiv.x, startPointDiv.y);
            CGContextAddLineToPoint(context, endPointDiv.x, endPointDiv.y);
            varing_xcordinate= varing_xcordinate+60;
        }
        CGContextDrawPath(context, kCGPathFillStroke);
        
        
        
        //drawing  horizontal and vertical lines  so that graph can be drawn accordingly
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
        CGPoint startPoint = CGPointMake(50, kGraphHeight);
        CGPoint endPoint = CGPointMake(50+lengthCount*70+40, kGraphHeight);
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
        
        float x = 60;
        float y = kGraphHeight;
        
        //showing months below horizontal base line
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\""];
        NSCharacterSet* doNotWantcomma = [NSCharacterSet characterSetWithCharactersInString:@","];
        for (int monthscount = 0; monthscount <dateArray.count; monthscount++)
        {
            // NSString *theText = [dateArray objectAtIndex:monthscount];
            UILabel *label1 = [[UILabel alloc]init];
            NSString *drawbasetext=[[[[[dateArray objectAtIndex:monthscount] componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""] componentsSeparatedByCharactersInSet: doNotWantcomma] componentsJoinedByString: @"-"];
            if([[dateArray objectAtIndex:monthscount] length]==0 || [[dateArray objectAtIndex:monthscount] isEqualToString:@"<null>"]||[dateArray objectAtIndex:monthscount] ==nil||[dateArray objectAtIndex:monthscount] ==[NSNull null])
            {
                label1.text=@"";
            }
            else
            {
                label1.text=drawbasetext;
            }
            
            label1.frame =CGRectMake(x,y+10, 47, 40);
            label1.numberOfLines=2;
            label1.lineBreakMode=NSLineBreakByWordWrapping;
            label1.backgroundColor =  [UIColor clearColor] ;
            label1.font=[UIFont fontWithName:AvenirRegular size:XbGraphLabelsize];
            label1.textColor=[UIColor whiteColor];
            label1.userInteractionEnabled =NO;
            [label1 sizeToFit];
            [self addSubview:label1];
            x=x+60;
        }

        
        
        
//        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//        UIColor *color = [UIColor whiteColor]; //\\put something else here...
//        UIFont *ffont=[UIFont systemFontOfSize:9];
//        NSArray *color_array=[[NSArray alloc]initWithObjects:color,ffont, nil];
//        NSArray *keeys_array=[[NSArray alloc]initWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil];
//        NSDictionary *attributes = [NSDictionary dictionaryWithObjects:color_array forKeys:keeys_array];
//        for (int monthscount = 0; monthscount <dateArray.count; monthscount++)
//        {
//            // NSString *theText = [dateArray objectAtIndex:monthscount];
//            NSString *drawbasetext=[dateArray objectAtIndex:monthscount];
//            if([drawbasetext length]==0 || [drawbasetext isEqualToString:@"<null>"]||drawbasetext ==nil||[dateArray objectAtIndex:monthscount]==[NSNull null])
//            {
//                [@"" drawAtPoint:CGPointMake(x, y) withAttributes:attributes];
//            }
//            else
//            {
//                [[dateArray objectAtIndex:monthscount] drawAtPoint:CGPointMake(x, y) withAttributes:attributes];
//            }
//            [[dateArray objectAtIndex:monthscount] drawAtPoint:CGPointMake(x, y) withAttributes:attributes];
//            x=x+60;
//        }
//        CGContextSetLineWidth(context, 1.0);
////        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//        CGContextSetLineWidth(context, .5);
//        CGContextSetTextMatrix(context, CGAffineTransformRotate(CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0), M_PI / 2));
////        CGContextSelectFont(context, "Arial", 22, kCGEncodingMacRoman);
//        
//        /* ALTERNATE METHOD FOR CGContextSelectFont*/
//        CGContextSetTextDrawingMode(context, kCGTextFill); // This is the default
//        [@"" drawAtPoint:CGPointMake(x, y)
//                   withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial"
//                                                                        size:22]
//                                    }];
//        
//        
//        CGContextDrawPath(context, kCGPathFillStroke);
        
        [self drawLineGraphWithContext:context];
    }
}


@end

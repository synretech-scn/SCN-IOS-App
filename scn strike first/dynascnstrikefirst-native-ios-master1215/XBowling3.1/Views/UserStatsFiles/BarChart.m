//
//  GraphView.m
//  Graph
//
//  Created by clicklabs68 on 4/7/14.
//  Copyright (c) 2014 clicklabs68. All rights reserved.
//

#import "BarChart.h"

@implementation BarChart
{
    NSMutableArray *closing_cash_values;
    float max_closing_cash;
    NSMutableArray *values_todraw_color_filledpath;
    NSMutableArray *dateArraybelowbaseLine;
    NSString *xkeystring;
}
@synthesize colorlabelstextarray;


#define kLineWidth 1
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    
      return self;
}

-(void) barGraphdata:(NSArray *)data xAxis:(NSString *)xKey yAxis:(NSString *)yKey
{
   // NSDictionary *arraytoDic=[[NSDictionary alloc]init];//WithObjects:data forKeys:@"data"];
    xkeystring=xKey;
    if ([xKey isEqualToString:@"<null>"])
        xkeystring=@"";

   
   // NSLog(@"data==%@",arraytoDic objectForKey:data)
    //arraytoDic=data;
   // NSLog(@"%@",[[data objectAtIndex:0] objectAtIndex:0]);
    // NSLog(@"%@",arraytoDic);
   // NSLog(@"data==%@",[arraytoDic o);
  
     NSArray *arr = [yKey componentsSeparatedByString:@","];;
    closing_cash_values=[[NSMutableArray alloc ]init];
    values_todraw_color_filledpath = [[NSMutableArray alloc]init];
    dateArraybelowbaseLine=[[NSMutableArray alloc]init];
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"bargraphcount"]integerValue]==5)
    {
        for(int i=1;i<=10;i++)
        {
            
                [closing_cash_values addObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:0]   objectForKey:[NSString stringWithFormat:@"%@%d",[arr objectAtIndex:0],i]]]];
                [closing_cash_values addObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:0]  objectForKey:[NSString stringWithFormat:@"%@%d",[arr objectAtIndex:1],i]]]];
                [dateArraybelowbaseLine addObject:[NSString stringWithFormat:@"Pin%d",i]];
        }
    }
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"bargraphcount"]integerValue]==2)
    {
        for(int i=0;i<[data count];i++)
        {
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"bargraphcount"]integerValue]==2)
            {
                [closing_cash_values addObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i]  objectForKey:[arr objectAtIndex:0]]]];
                [closing_cash_values addObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i]   objectForKey:[arr objectAtIndex:1]]]];
                [dateArraybelowbaseLine addObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i]   objectForKey:xKey]]];
            }
        }
    }
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"bargraphcount"]integerValue]==1)
    {
        for(int i=0;i<[data count];i++)
        {
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"bargraphcount"]integerValue]==1)
            {
                [closing_cash_values addObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i]  objectForKey:[arr objectAtIndex:0]]]];
               
                [dateArraybelowbaseLine addObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i]   objectForKey:xKey]]];
            }
        }
    }
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"bargraphcount"]integerValue]==3)
    {
    for(int i=0;i<data.count;i++)
    {
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"bargraphcount"]integerValue]==3)
        {
            [closing_cash_values addObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i] objectForKey:[arr objectAtIndex:0]]]];
            [closing_cash_values addObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i] objectForKey:[arr objectAtIndex:1]]]];
        [closing_cash_values addObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i] objectForKey:[arr objectAtIndex:2]]]];
            [dateArraybelowbaseLine addObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i] objectForKey:xKey]]];

        }
        
              //[closing_cash_values addObject:[NSString stringWithFormat:@"%d",i*100]];
      //[dateArraybelowbaseLine addObject:[NSString stringWithFormat:@"%d",i*100]];

    }
    }

    max_closing_cash=abs((int)[[closing_cash_values objectAtIndex:0]integerValue]);
    values_todraw_color_filledpath =[[NSMutableArray alloc]init];
    
    //finding max closing cash
    for(int monthscount=0;monthscount<closing_cash_values.count;monthscount++)
    {
        if(max_closing_cash<abs((int)[[closing_cash_values objectAtIndex:monthscount]integerValue]))
        {
            max_closing_cash=abs((int)[[closing_cash_values objectAtIndex:monthscount]integerValue]);
        }
    }
    // Assigning values to values_todraw_color_filledpath array
    for( int monthscount=0;monthscount<closing_cash_values.count;monthscount++)
    {
        if(max_closing_cash!=0)
        {
            [values_todraw_color_filledpath addObject:[NSString stringWithFormat:@"%f",([[closing_cash_values objectAtIndex:monthscount]floatValue]/max_closing_cash)]];
        }
        else{
            [values_todraw_color_filledpath addObject:@"0"];
        }
    }

}

#pragma mark - Draw Bar Chart
- (void)drawBar:(CGRect)rect context:(CGContextRef)ctx
{
    switch (check)
    {
        case 1:
        {
//            CGFloat components[12] = {255.0/255, 40.0/255, 81.0/255, 1.0,};   // first color
            CGFloat components[12] = {255.0/255, 255.0/255, 255.0/255, 1.0,};
            CGFloat locations[1] = { 1.0};
            size_t num_locations = 1;
            colorspace = CGColorSpaceCreateDeviceRGB();
            gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
            break;
        }
        case 2:
        {
            CGFloat components[12] = {0.0/255, 118.0/255, 254.0/255, 1.0,};   // second color
            CGFloat locations[1] = { 1.0};
            size_t num_locations = 1;
            colorspace = CGColorSpaceCreateDeviceRGB();
            gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
            break;
        }
        case 3:
        {
            CGFloat components[12] = {255.0/255, 242.0/255, 38.0/255, 1.0,};   // third color
            CGFloat locations[1] = { 1.0};
            size_t num_locations = 1;
            colorspace = CGColorSpaceCreateDeviceRGB();
            gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
            break;
        }
        case 4:
        {
            CGFloat components[12] = {157.0/255, 149.0/255, 193.0/255, 1.0,};
            CGFloat locations[1] = { 1.0};
            size_t num_locations = 1;
            colorspace = CGColorSpaceCreateDeviceRGB();
            gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
            break;
        }
        case 5:
        {
            CGFloat components[12] = {140.0/255, 188.0/255, 212.0/255, 1.0,};  
            CGFloat locations[1] = { 1.0};
            size_t num_locations = 1;
            colorspace = CGColorSpaceCreateDeviceRGB();
            gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
            break;
        }
        default:
            break;
    }
    CGPoint startPoint = rect.origin;
    CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    
    // Create and apply the clipping path
    CGContextBeginPath(ctx);
    CGContextSetGrayFillColor(ctx, 0.2, 0.7);
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextClosePath(ctx);
    CGContextSaveGState(ctx);
    CGContextClip(ctx);
    
    // Draw the gradient
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(ctx);
    
    // Release the resources
    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
}

#pragma mark - Draw Rect function

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.6);
    CGFloat dash[] = {2.0, 2.0};
    CGContextSetLineDash(context, 0.0, dash, 0);
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    CGContextSetTextDrawingMode(context, kCGTextFill);
    
    // Drawing text i.e. months
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    CGContextSetLineWidth(context, kLineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, .5);
    
    // Drawing text i.e. values
    CGContextSetTextMatrix(context, CGAffineTransformRotate(CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0), M_PI / 2));
    CGContextSelectFont(context, "Arial", 22, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill); // This is the default
    [[UIColor blackColor] setFill]; // This is the default
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    NSString *theTextHeight;
    
    
    
    
    float varing_ycordinate=kbarGraphHeight;
    varing_ycordinate=varing_ycordinate-160/6;
    int horozontalLineLength=6;
    if(dateArraybelowbaseLine.count<8)
    {
        horozontalLineLength=6;
    }
    else
    {
        horozontalLineLength=(int)dateArraybelowbaseLine.count;
    }
    for(int i=0;i<6;i++)
    {
        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGPoint startPoint = CGPointMake(60, varing_ycordinate);
        CGPoint endPoint = CGPointMake(60+(55*horozontalLineLength)+50, varing_ycordinate);
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        varing_ycordinate=varing_ycordinate-160/6;
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);

    
    CGPoint startPoint = CGPointMake(60, kbarGraphHeight);
    CGPoint endPoint = CGPointMake((horozontalLineLength*55)+50+60, kbarGraphHeight);
    
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);

    float varing_height_of_dashes=kbarGraphHeight;
    UIColor *color = [UIColor whiteColor]; //\\put something else here...
    UIFont *ffont=[UIFont systemFontOfSize:10];
    NSArray *color_array=[[NSArray alloc]initWithObjects:color,ffont, nil];
    NSArray *keeys_array=[[NSArray alloc]initWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjects:color_array forKeys:keeys_array];
    
    //showing positive values vertically on left side in black color
    int positiveCount=1;
    if(max_closing_cash==0.0)
    {
        positiveCount=1;
    }
    else{
        positiveCount=7;
    }
    for (int positive_values=0; positive_values<positiveCount; positive_values++)
    {
        NSNumberFormatter *formatterfloat = [[NSNumberFormatter alloc] init];
        [formatterfloat setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatterfloat setMaximumFractionDigits:0];
        [formatterfloat setAllowsFloats:YES];
        // NSNumber *number = [NSNumber numberWithFloat:((max_closing_cash/6)*positive_values)];
        
        //numberround = [NSNumber numberWithFloat:dollarvalue];
        
        float drawvalue=((max_closing_cash/6.0)*positive_values);
        NSNumber *numberdeci = [NSNumber numberWithFloat:drawvalue];
        NSString  *dollarvalueinstring=[formatterfloat stringFromNumber:numberdeci];
        
        theTextHeight=dollarvalueinstring;
        if(positive_values==0)
        {
            theTextHeight=@"0";
        }
        [theTextHeight drawAtPoint:CGPointMake(30, varing_height_of_dashes-5) withAttributes:attributes];
        varing_height_of_dashes=varing_height_of_dashes-(165/6);
    }
   // NSString *theTextbelow = @"date \n 45";
    
#pragma mark - finding height according to graphtype
    int varheight=0;
    if([xkeystring length]==0)
    {
        varheight=2;
    }
    else
    {
        varheight=(int)[[[NSUserDefaults standardUserDefaults]objectForKey:@"bargraphcount"]integerValue];
    }
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\""];
    NSCharacterSet* doNotWantcomma = [NSCharacterSet characterSetWithCharactersInString:@","];
    
    
    
    NSArray *textarray=[[NSArray alloc]initWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:@"colorLabelText"]componentsSeparatedByString:@","]];
    
    float varingXcordinate=150;
    int countofcolorlabels=2;
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"bargraphcount"]integerValue]==3)
    {
        countofcolorlabels=3;
    }
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"bargraphcount"]integerValue]==1)
    {
        countofcolorlabels=1;
    }
    
//    UIColor *firstcolor=[UIColor colorWithRed:255/255.0f green:40/255.0f blue:81/255.0f alpha:1.0];
    UIColor *firstcolor=[UIColor whiteColor];
    UIColor *secondcolor=[UIColor colorWithRed:0/255.0f green:118/255.0f blue:254/255.0f alpha:1.0];
    UIColor *thirdcolor= [UIColor colorWithRed:255/255.0f green:242/255.0f blue:38/255.0f alpha:1.0];

//    UIColor *firstcolor=[UIColor colorWithRed:51/255.0f green:131/255.0f blue:211/255.0f alpha:1.0];
//    UIColor *secondcolor=[UIColor colorWithRed:14/255.0f green:35/255.0f blue:55/255.0f alpha:1.0];
//    UIColor *thirdcolor=[UIColor colorWithRed:180/255.0f green:192/255.0f blue:109/255.0f alpha:1.0];
    NSArray *colorarray=[[NSArray alloc]initWithObjects:firstcolor,secondcolor,thirdcolor, nil];
    
   //setting color boxes
    if(textarray.count==countofcolorlabels)
    {
    for(int i=0;i<countofcolorlabels;i++)
    {
        
        CGSize maximumLabelSize = CGSizeMake(236,9999);
        CGSize expectedLabelSize ;
        expectedLabelSize = [[textarray objectAtIndex:i] sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];

    
    UILabel *labelcolor1 = [[UILabel alloc]init];
    labelcolor1.frame=CGRectMake(varingXcordinate, kbarGraphHeight+22, 15, 15);
    labelcolor1.backgroundColor = [colorarray objectAtIndex:i] ;
    labelcolor1.userInteractionEnabled =NO;
    labelcolor1.adjustsFontSizeToFitWidth=YES;
    [self addSubview:labelcolor1];
    varingXcordinate= varingXcordinate+20;
    
    UILabel *labeltext1 = [[UILabel alloc]init];
    labeltext1.frame =CGRectMake(varingXcordinate,kbarGraphHeight+22, expectedLabelSize.width, expectedLabelSize.height);
    labeltext1.numberOfLines=0;
    labeltext1.textAlignment=NSTextAlignmentLeft;
    labeltext1.lineBreakMode=NSLineBreakByWordWrapping;
    labeltext1.backgroundColor =  [UIColor clearColor] ;
    labeltext1.font=[UIFont systemFontOfSize:13];
    labeltext1.textColor=[UIColor whiteColor];
    labeltext1.text=[textarray objectAtIndex:i];
    labeltext1.userInteractionEnabled =NO;
    labeltext1.adjustsFontSizeToFitWidth=YES;
    [self addSubview:labeltext1];
    varingXcordinate=varingXcordinate+labeltext1.frame.size.width+5;
        
     }
    }


    barX = kOffsetX + kStepX + 0 * kStepX - kBarWidth / 2-35;
    float V1;
    float V2;
    int labelCount =0;
    for (int i = 0; i < dateArraybelowbaseLine.count; i++)
    {
       
        //date label
        UILabel *label1 = [[UILabel alloc]init];
        NSString *drawbasetext=[[[[[dateArraybelowbaseLine objectAtIndex:i] componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""] componentsSeparatedByCharactersInSet: doNotWantcomma] componentsJoinedByString: @"-"];
        if([[dateArraybelowbaseLine objectAtIndex:i] length]==0 || [[dateArraybelowbaseLine objectAtIndex:i] isEqualToString:@"<null>"]||[dateArraybelowbaseLine objectAtIndex:i] ==nil||[dateArraybelowbaseLine objectAtIndex:i] ==[NSNull null])
        {
            label1.text=@"";
        }
        else
        {
            label1.text=drawbasetext;
        }
        
        label1.frame =CGRectMake(barX,kbarGraphHeight, 42, 23);
        label1.numberOfLines=2;
        label1.lineBreakMode=NSLineBreakByWordWrapping;
        label1.backgroundColor =  [UIColor clearColor] ;
        label1.font=[UIFont systemFontOfSize:8];
        label1.textColor=[UIColor whiteColor];

        //[[[dateArraybelowbaseLine objectAtIndex:i] componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""]
        
        label1.userInteractionEnabled =NO;
        [self addSubview:label1];
       // [[dateArraybelowbaseLine objectAtIndex:i] drawAtPoint:CGPointMake(barX-3, kbarGraphHeight+2) withAttributes:attributes];
        
        //first bar graph
        V1= [[values_todraw_color_filledpath objectAtIndex:varheight*i]floatValue]*160;
        V2 = kbarGraphHeight-V1-1.5;
        
        UILabel *valueLabel=[[UILabel alloc]init];
        valueLabel.frame =CGRectMake(barX - 3,V2 - 12, 17, 12);
        valueLabel.backgroundColor =  [UIColor clearColor] ;
        valueLabel.text=[NSString stringWithFormat:@"%ld",(long)[[closing_cash_values objectAtIndex:labelCount] integerValue]];
        valueLabel.font=[UIFont systemFontOfSize:9];
        valueLabel.textAlignment=NSTextAlignmentCenter;
        valueLabel.textColor=[UIColor whiteColor];
        valueLabel.adjustsFontSizeToFitWidth=YES;
        valueLabel.userInteractionEnabled =NO;
        [self addSubview:valueLabel];

        CGRect barRect = CGRectMake(barX, V2, 11, V1+1.5);
        check = 1;
        [self drawBar:barRect context:context];
        labelCount++;
        
        //second bar graph
        //barX=barX+13;id(
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"bargraphcount"]integerValue]!=1)
        {
            V1= [[values_todraw_color_filledpath objectAtIndex:varheight*i+1]floatValue]*160;
            V2 = kbarGraphHeight-V1-1.5;
            
            UILabel *valueLabel=[[UILabel alloc]init];
            valueLabel.frame =CGRectMake(barX+10,V2 - 12, 17, 12);
            valueLabel.backgroundColor =  [UIColor clearColor] ;
            valueLabel.text=[NSString stringWithFormat:@"%ld",(long)[[closing_cash_values objectAtIndex:labelCount] integerValue]];
            valueLabel.font=[UIFont systemFontOfSize:9];
             valueLabel.textAlignment=NSTextAlignmentCenter;
            valueLabel.textColor=[UIColor whiteColor];
            valueLabel.userInteractionEnabled =NO;
            valueLabel.adjustsFontSizeToFitWidth=YES;
            [self addSubview:valueLabel];

            barRect = CGRectMake(barX+13, V2, 11, V1+1.5);
            check = 2;
            [self drawBar:barRect context:context];
            labelCount++;
        }
        
       // barX=barX+18+11;
        
        //third bar graph
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"bargraphcount"]integerValue]==3)
        {
       // barX=barX+13;
            V1= [[values_todraw_color_filledpath objectAtIndex:varheight*i+2]floatValue]*160;
            V2 = kbarGraphHeight-V1-1.5;
            
            UILabel *valueLabel=[[UILabel alloc]init];
            valueLabel.frame =CGRectMake(barX+23,V2 - 12, 17, 12);
            valueLabel.backgroundColor =  [UIColor clearColor] ;
            valueLabel.text=[NSString stringWithFormat:@"%ld",(long)[[closing_cash_values objectAtIndex:labelCount] integerValue]];
            valueLabel.font=[UIFont systemFontOfSize:9];
             valueLabel.textAlignment=NSTextAlignmentCenter;
            valueLabel.textColor=[UIColor whiteColor];
            valueLabel.adjustsFontSizeToFitWidth=YES;
            valueLabel.userInteractionEnabled =NO;
            [self addSubview:valueLabel];
            barRect = CGRectMake(barX+26, V2, 11, V1+1.5);
            check = 3;
            [self drawBar:barRect context:context];
            labelCount++;
        }
        barX=barX+26+29;
    }
    
//    float y_coordinate_label_Color=kbarGraphHeight;
//    float x_coordinate_label_Color=50;
//    for (int i=0; i<7; i++)
//    {
//        UILabel *label1 = [[UILabel alloc]init];
//        if(i==0)
//        {
//            label1.frame =CGRectMake(0, y_coordinate_label_Color, 23, 15);
//        }
//        if(i==1)
//        {
//            label1.frame =CGRectMake(110, y_coordinate_label_Color, 23, 15);
//        }
//        if(i==2)
//        {
//            label1.frame =CGRectMake(230, y_coordinate_label_Color, 23, 15);
//        }
//        if(i==3)
//        {
//            label1.frame =CGRectMake(355, y_coordinate_label_Color, 23, 15);
//        }
//        if(i==4)
//        {
//            label1.frame =CGRectMake(410, y_coordinate_label_Color, 23, 15);
//        }
//        if(i==5)
//        {
//            label1.frame =CGRectMake(538, y_coordinate_label_Color, 23, 15);
//        }
//        if(i==6)
//        {
//            label1.frame =CGRectMake(605, y_coordinate_label_Color, 23, 15);
//        }
//        label1.backgroundColor =  [colors objectAtIndex:i] ;
//        label1.userInteractionEnabled =NO;
//        [self addSubview:label1];
//        
//        x_coordinate_label_Color = x_coordinate_label_Color+80;
//    }

    
  }



@end

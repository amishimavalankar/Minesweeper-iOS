//
//  SecondViewController.m
//  minesweeper_game
//
//  Created by Amishi Mavalankar on 3/1/14.
//  Copyright (c) 2014 Amishi Mavalankar. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@end

@implementation SecondViewController
@synthesize no_columns=_no_columns;
@synthesize no_rows = _no_rows;
@synthesize color_label=_color_label;
@synthesize r = _r;
@synthesize g = _g;
@synthesize b=_b;
@synthesize mine_view=_mine_view;


- (IBAction)decrement_rows:(id)sender
{
    
}

-(Mine_view *) mine_view
{
    if(!_mine_view)
        _mine_view= [[Mine_view alloc]init];
    return _mine_view;
}
- (void)viewDidLoad
{
    _r.minimumValue=0;
    _r.maximumValue=255;
    
    _g.minimumValue=0;
    _g.maximumValue=255;
    
    _b.minimumValue=0;
    _b.maximumValue=255;

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stepper_row:(UIStepper *)sender {
    int value = [sender value];
    [_no_rows setText:[NSString stringWithFormat:@"%d", (int)value]];
    [[NSUserDefaults standardUserDefaults]setInteger:value forKey:@"rows"];
    [[NSUserDefaults standardUserDefaults]synchronize];

}
- (IBAction)stepper_col:(UIStepper *)sender {
    int value = [sender value];
    [_no_columns setText:[NSString stringWithFormat:@"%d", (int)value]];
    [[NSUserDefaults standardUserDefaults]setInteger:value forKey:@"columns"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (IBAction)sliderValue:(UISlider *)sender {
    float r=[[NSString stringWithFormat:@"%.0f",_r.value] floatValue];
    float g=[[NSString stringWithFormat:@"%.0f",_g.value]floatValue];
    float b=[[NSString stringWithFormat:@"%.0f",_b.value]floatValue];
    UIColor *colorToSet=[UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1];
    NSData *color = [NSKeyedArchiver archivedDataWithRootObject:colorToSet];
    [[NSUserDefaults standardUserDefaults]setObject:color forKey:@"color"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [_color_label setBackgroundColor:colorToSet];
    
 
}
@end

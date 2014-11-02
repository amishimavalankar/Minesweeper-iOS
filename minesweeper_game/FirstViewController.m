//
//  FirstViewController.m
//  minesweeper_game
//
//  Created by Amishi Mavalankar on 3/1/14.
//  Copyright (c) 2014 Amishi Mavalankar. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@synthesize mine_view;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(Mine_view *) mine_view
{
    if(!mine_view)
        mine_view= [[Mine_view alloc]init];
    return mine_view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    int nRow=[[NSUserDefaults standardUserDefaults]integerForKey:@"rows"];
    int nCol=[[NSUserDefaults standardUserDefaults]integerForKey:@"columns"];

    [self.mine_view random_mine_generate:nRow*nCol*0.2];
    
    UIView *tapView = self.view;
    UITapGestureRecognizer *tapDoubleGR = [[UITapGestureRecognizer alloc]
                                           initWithTarget:tapView action:@selector(tapDoubleHandler:)];
    tapDoubleGR.numberOfTapsRequired = 2;         // set appropriate GR attributes
    [tapView addGestureRecognizer:tapDoubleGR];   // add GR to view
    UITapGestureRecognizer *tapSingleGR = [[UITapGestureRecognizer alloc]
                                           initWithTarget:tapView action:@selector(tapSingleHandler:)];
    
    tapSingleGR.numberOfTapsRequired = 1;         // set appropriate GR attributes
    [tapSingleGR requireGestureRecognizerToFail: tapDoubleGR];  // prevent single tap recognition on double-tap
    [tapView addGestureRecognizer:tapSingleGR];   // add GR to view
    
  [self.view setBackgroundColor:[UIColor grayColor ]];    
}






@end

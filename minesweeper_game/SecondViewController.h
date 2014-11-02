//
//  SecondViewController.h
//  minesweeper_game
//
//  Created by Amishi Mavalankar on 3/1/14.
//  Copyright (c) 2014 Amishi Mavalankar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mine_view.h"

@interface SecondViewController : UIViewController

- (IBAction)sliderValue:(UISlider *)sender;
@property (weak, nonatomic) IBOutlet UILabel *no_rows;
- (IBAction)stepper_row:(UIStepper *)sender;
@property (weak, nonatomic) IBOutlet UILabel *no_columns;
@property (strong, nonatomic) IBOutlet UILabel *color_label;
- (IBAction)stepper_col:(UIStepper *)sender;
@property (strong, nonatomic) IBOutlet UISlider *r;
@property (strong, nonatomic) IBOutlet UISlider *g;
@property (strong, nonatomic) IBOutlet UISlider *b;
@property (strong,nonatomic) Mine_view *mine_view;
@end

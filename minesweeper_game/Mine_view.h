//
//  Mine_view.h
//  minesweeper_game
//
//  Created by Amishi Mavalankar on 3/1/14.
//  Copyright (c) 2014 Amishi Mavalankar. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Mine_view : UIView <UIActionSheetDelegate>

@property (nonatomic, assign) CGFloat dw, dh;
@property (nonatomic, assign) int x, y;
@property (nonatomic, assign) int row, column;
-(void) random_mine_generate:(int)m;
@property (nonatomic,assign) BOOL mine_present;
-(void) expansion_mine: (int)x_coord :(int)y_coord;
-(void) display_mines;
@property (strong, nonatomic) IBOutlet UITextField *unflagged_mines;
- (IBAction)newgame:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *timer;
@property (strong, nonatomic) IBOutlet UITextField *best_time;
@end

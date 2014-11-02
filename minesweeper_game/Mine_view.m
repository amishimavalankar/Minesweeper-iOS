//
//  Mine_view.m
//  minesweeper_game
//
//  Created by Amishi Mavalankar on 3/1/14.
//  Copyright (c) 2014 Amishi Mavalankar. All rights reserved.
//  10 mine
//  999 flag
//  -4 flag and mine
//  0 empty
// generating number of mines in random_mine_generate by using number of rows*number of columns *0.2 (20% of the grid should have mines)
//new game needs to be started after changing the setting from the settings view
//

#import "Mine_view.h"

@implementation Mine_view

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
}
    return self;
}

@synthesize dw, dh, x,y,row,column;
@synthesize mine_present;
@synthesize best_time=_best_time;
@synthesize unflagged_mines=_unflagged_mines;
int mine_grid[16][20];
int seconds=0;
@synthesize timer=_timer;
int total_mines=0;
NSTimer *mainTimer;
bool counter_start=true;
- (void)timerController
{
   _timer.text = [self getTimeStr:(seconds++)];
}

- (NSString*)getTimeStr : (int) secondsElapsed
{
    return [NSString stringWithFormat:@"%d",seconds];
}

- (void)drawRect:(CGRect)rect
{
    NSString *str = [NSString stringWithFormat:@"%d",total_mines];
    _unflagged_mines.text=str;
    int nRow=[[NSUserDefaults standardUserDefaults]integerForKey:@"rows"];
    int nCol=[[NSUserDefaults standardUserDefaults]integerForKey:@"columns"];
    if(nRow==0 && nCol==0)
    {
        nRow=4;
        nCol=4;
    }
    
    int i,j;
    
    NSLog( @"drawRect:");
    if(counter_start)
    {
    mainTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                        selector:@selector(timerController)
                                                        userInfo:nil
                                                        repeats:YES];
        counter_start=false;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults stringForKey:@"best_time"];   //to set best time
    if(string!=NULL)
        _best_time.text=string;
    else
        _best_time.text=@"Null";
    
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();  // obtain graphics context
    // CGContextScaleCTM( context, 0.5, 0.5 );  // shrink into upper left quadrant
    CGRect bounds = [self bounds];          // get view's location and size
    CGFloat w = CGRectGetWidth( bounds );   // w = width of view (in points)
    CGFloat h = CGRectGetHeight ( bounds )-50; // h = height of view (in points)
//    
//    CGContextScaleCTM( context,0.5f, 0.5f );//***
//    CGContextTranslateCTM( context, 0.5f*(w+10), 0.5f*(h+20) );
//    
    dw = w/nCol;                           // dw = width of cell (in points)
    dh = (h-80)/nRow;                           // dh = height of cell (in points)
    NSLog( @"view (width,height) = (%g,%g)", w, h );
    NSLog( @"cell (width,height) = (%g,%g)", dw, dh );
    // draw lines to form a  cell
    CGContextBeginPath( context );               // begin collecting drawing operations
    for ( int i = 0;  i < nRow+1;  ++i )
    {
        // draw horizontal grid line
        CGContextMoveToPoint( context, 0, i*dh+80);
        CGContextAddLineToPoint( context, w, i*dh+80);
    }
    for ( int i = 0;  i < nCol+1;  ++i )
    {
        // draw vertical grid line
        CGContextMoveToPoint( context, i*dw, 80 );
        CGContextAddLineToPoint( context, i*dw, h );
    }
    [[UIColor blackColor] setStroke];             // use black as stroke color
    CGContextDrawPath( context, kCGPathStroke ); // execute collected drawing ops
    
    [self game_won];
    
    if(mine_present==true)
    {
        [self display_mines];
    }
    
    for (i=0;i<nCol;i++)  //display number of mines surrounding the cell
    {
        for(j=0;j<nRow;j++)
        {
            if((mine_grid[i][j]!=10 && mine_grid[i][j]!=0)) //setting background color for the grid using NSUserDefaults to get color of background from the settings
            {
                CGPoint xy ={ (i)*self.dw, ((j)*self.dh+80 )};
                NSData *color = [[NSUserDefaults standardUserDefaults]objectForKey:@"color"];
                UIColor *c = [NSKeyedUnarchiver unarchiveObjectWithData:color];
                CGRect imgRect = CGRectMake(xy.x,xy.y, dw, dh);
                if(c == nil)
                {
                    [[UIColor whiteColor]set];
                    UIRectFill(imgRect);
                    [[UIColor blackColor]set];
                    UIRectFrame(imgRect);
                    
                }
                else
                {
                    [c set];
                    UIRectFill(imgRect);
                    [[UIColor blackColor]set];
                    UIRectFrame(imgRect);
                }
            }
            if(mine_grid[i][j]!=999 && mine_grid[i][j]!=-4 && mine_grid[i][j]!=10  && mine_grid[i][j]!=100 && mine_grid[i][j]!=0 )  //checking if surrounding cell contains a mine and displaying the number of mines in the cell clicked
            {
                CGPoint xy ={ (i+0.3)*self.dw, ((j+0.2)*self.dh+80)};
                UIFont *f= [UIFont systemFontOfSize: 0.5*self.dh];
                [[NSString stringWithFormat:@"%d", mine_grid[i][j]] drawAtPoint: xy withFont:f];
            }
            if(mine_grid[i][j]==999 || mine_grid[i][j]==-4)  //checking if the cell contains the value 4 or -4 which represents flag or flag with mine and display image of flag at that cell
            {
                CGPoint xy ={ (i)*self.dw, (j*self.dh+80)};
                UIImage *img;
                CGRect imgRect = CGRectMake(xy.x,xy.y, dw, dh);
                img = [UIImage imageNamed:@"flg"];
                [img drawInRect: imgRect];
            }
            
        }
    }
}

-(void) game_won  //function for game win
{
    int nRow=[[NSUserDefaults standardUserDefaults]integerForKey:@"rows"];
    int nCol=[[NSUserDefaults standardUserDefaults]integerForKey:@"columns"];
    if(nRow==0 && nCol==0)
    {
        nRow=4;
        nCol=4;
    }

    int empty_grid=0, win_condition=0;
    for(int i=0;i<nCol;i++)
    {
        for(int j=0;j<nRow;j++)
        {
            if(mine_grid[i][j]==0 || mine_grid[i][j]==999)
            {   empty_grid++;
            }
        }
    }
    if(empty_grid==0)
    {
        win_condition=1;
    }
    NSUserDefaults *time = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSString *str = [time stringForKey:@"best_time"];
    NSString *current_time = [self getTimeStr:seconds];
    int least_time=[str intValue];
    int game_time=[current_time intValue];
    
    if (win_condition==1 && game_time<least_time)  //alert message when the user finishes the game in time less than the previous one set
    {
        [mainTimer invalidate];
        [time setValue:current_time forKey:@"best_time"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Minesweeper"
                                                        message:@"Congratulations!!Best Time Score!"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"New Game",nil];
        
        
                [alert show];
        
    }
    else if(win_condition==1)
    {
        [mainTimer invalidate];
        if(str==Nil)
        {
            [time setValue:current_time forKey:@"best_time"];
        }

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Minesweeper"
                                                        message:@"Congratulations!! Game Won!"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"New Game",nil];
        [alert show];
        
    }
}

-(void) display_mines
{
    int nRow=[[NSUserDefaults standardUserDefaults]integerForKey:@"rows"];
    int nCol=[[NSUserDefaults standardUserDefaults]integerForKey:@"columns"];
    int i,j;
    if(nRow==0 && nCol==0)
    {
        nRow=4;
        nCol=4;
    }

    for (i=0;i<nCol;i++)
    {
        for(j=0;j<nRow;j++)
        {
            
            if(mine_grid[i][j]==10 || mine_grid[i][j]==-4)
            {
                CGPoint xy ={ (i)*self.dw, (j*self.dh+80)};
                UIImage *img;
                CGRect imgRect = CGRectMake(xy.x,xy.y, dw, dh);
                img = [UIImage imageNamed:@"mines"];
                [img drawInRect: imgRect];
            }
        }
    }
    UIActionSheet *myAS = [[UIActionSheet alloc]
                           initWithTitle:@"Game Over"
                           delegate:self
                           cancelButtonTitle:nil       // nil to suppress this button
                           destructiveButtonTitle:nil // nil to suppress this button
                           otherButtonTitles:@"New Game",nil];
    [myAS showInView:self];
    [mainTimer invalidate];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int nRow=[[NSUserDefaults standardUserDefaults]integerForKey:@"rows"];
    int nCol=[[NSUserDefaults standardUserDefaults]integerForKey:@"columns"];

    switch ( buttonIndex ) {
        case 0:
            
            NSLog(@"you selected button at index 0");
            [self random_mine_generate:nRow*nCol*0.2];
            [self setNeedsDisplay];
            break;
        case 1:
            NSLog(@"you selected button at index 1");
            [self setNeedsDisplay];
            break;
    }
}

-(void) random_mine_generate:(int)no_mines
{
    counter_start=true;
    mine_present=false;
    total_mines=0;
    seconds=0;
    int nRow=[[NSUserDefaults standardUserDefaults]integerForKey:@"rows"];
    int nCol=[[NSUserDefaults standardUserDefaults]integerForKey:@"columns"];
    no_mines=nRow*nCol*0.2;
    if(nRow==0 && nCol==0)
    {
        nRow=4;
        nCol=4;
        no_mines=nRow*nCol*0.2;
    }
    for(int i=0;i<nCol;i++)
    {
        for(int j=0;j<nRow;j++)
        {
            mine_grid[i][j] = 0;
        }
    }
    
    for(int i=0;i<no_mines;i++)
    {
        do
        {
            
        x=arc4random()%nCol;
        y=arc4random()%nRow;
        }
        while (mine_grid[x][y]==10);
        mine_grid[x][y]=10;
        
        NSLog(@"(column,row)=(%d, %d)",x,y);
    }
    for(int i=0;i<nCol;i++)
    {
        for(int j=0;j<nRow;j++)
        {
            if(mine_grid[i][j]==10)
            {
                total_mines++;
            }
        }
    }
    NSLog(@"no of mines %d",total_mines);
  
}


-(void) expansion_mine: (int)x_coord :(int)y_coord
{
    int nRow=[[NSUserDefaults standardUserDefaults]integerForKey:@"rows"];
    int nCol=[[NSUserDefaults standardUserDefaults]integerForKey:@"columns"];
    if(nRow==0 && nCol==0)
    {
        nRow=4;
        nCol=4;
    }
    
    int startx=0, starty=0,endx=0,endy=0,count=0;
    if(mine_grid[x_coord][y_coord]!=100 && mine_grid[x_coord][y_coord]!=999 && mine_grid[x_coord][y_coord]!=10 && mine_grid[x_coord][y_coord]!=-4)
    {
        if(x_coord-1<0)
        {
            startx=x_coord;
        }
        else startx= x_coord-1;
        if(y_coord-1<0)
        {
            starty=y_coord;
            
        }
        else starty=y_coord-1;
        if(x_coord+1>nCol-1)
        {
            endx=x_coord;
        }
        else endx=x_coord+1;
        if(y_coord+1>nRow-1)
        {
            endy=y_coord;
        }
        else endy=y_coord+1;
        
        for(int i= startx;i<=endx;i++)
        {
            for(int j = starty; j<= endy;j++)
            {
                
                if(mine_grid[i][j]==10 || mine_grid[i][j]==-4)
                {
                    count++;
                }
            }
        }
        if(count==0)
        {
            mine_grid[x_coord][y_coord]=100;
            for(int i=startx;i<=endx;i++)
            {
                for(int j=starty; j<=endy;j++)
                {
                    [self expansion_mine:(int)i :(int)j];
                }
            }
        }
        else
        {
            mine_grid[x_coord][y_coord]=count;
        }
    }
}

- (void) tapSingleHandler: (UITapGestureRecognizer *) sender
{
    int nRow=[[NSUserDefaults standardUserDefaults]integerForKey:@"rows"];
    int nCol=[[NSUserDefaults standardUserDefaults]integerForKey:@"columns"];
    NSLog( @"tapSingleHandler" );
    if(nRow==0 && nCol==0)
    {
        nRow=4;
        nCol=4;
    }
    
    if ( sender.state == UIGestureRecognizerStateEnded )
    {
        NSLog( @"(single tap recognized)" );
        CGPoint xy;
        xy = [sender locationInView: self];
        NSLog( @"(x,y) = (%f,%f)", xy.x, xy.y);
        NSLog( @"(dw,dh) = (%f,%f)", self.dw, self.dh );
        self.row = xy.x / self.dw;  self.column = (xy.y-80)/ self.dh;
        NSLog( @"(row,col) = (%d,%d)", self.row, self.column );
        if(self.column<nRow && xy.y-80>0)
        {
        if(mine_grid[self.row][self.column] == 0)
        {
            mine_grid[self.row][self.column]= 999;
            total_mines--;
        }
        else if(mine_grid[self.row][self.column]== 999)
        {
            mine_grid[self.row][self.column]=0;
            total_mines++;
        }
        else if (mine_grid[self.row][self.column]==10)
        {
            mine_grid[self.row][self.column]=-4;
            total_mines--;
        }
        else if (mine_grid[self.row][self.column]==-4)
        {
            mine_grid[self.row][self.column]=10;
            total_mines++;
        }
        }
    }[self setNeedsDisplay];
}

- (void)tapDoubleHandler:(UITapGestureRecognizer *) sender
{
    int nRow=[[NSUserDefaults standardUserDefaults]integerForKey:@"rows"];
    int nCol=[[NSUserDefaults standardUserDefaults]integerForKey:@"columns"];
    if(nRow==0 && nCol==0)
    {
        nRow=4;
        nCol=4;
    }
    
    NSLog( @"tapDoubleHandler" );
    CGPoint xy;
    xy = [sender locationInView: self];
    NSLog( @"(x,y) = (%f,%f)", xy.x, xy.y );
    NSLog( @"(dw,dh) = (%f,%f)", self.dw, self.dh );
    self.row = xy.x / self.dw;  self.column = (xy.y-80) / self.dh;
    NSLog( @"(row,column) = (%d,%d)", self.row, self.column );
    
    if(self.column<nRow && xy.y-80>0)
    {
    if(mine_grid[self.row][self.column]!=999 || mine_grid[self.row][self.column]!=-4)
    {
        if(mine_grid[self.row][self.column]==10)
        {
            mine_present=true;
        }
        else
        {
            [self expansion_mine:self.row :self.column];
        }
    }
        [self setNeedsDisplay];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    int nRow=[[NSUserDefaults standardUserDefaults]integerForKey:@"rows"];
    int nCol=[[NSUserDefaults standardUserDefaults]integerForKey:@"columns"];

    // the user clicked OK
    if (buttonIndex == 0)
    {
        [self random_mine_generate:nRow*nCol*0.2];
        [self setNeedsDisplay];
    }
}

- (IBAction)newgame:(id)sender
{
    int nRow=[[NSUserDefaults standardUserDefaults]integerForKey:@"rows"];
    int nCol=[[NSUserDefaults standardUserDefaults]integerForKey:@"columns"];
    [mainTimer invalidate];
    [self random_mine_generate:nRow*nCol*0.2];
    NSData *color = [[NSUserDefaults standardUserDefaults]objectForKey:@"color"];
    UIColor *c = [NSKeyedUnarchiver unarchiveObjectWithData:color];
    [c set];
    [[UIColor blackColor]set];
    [self setNeedsDisplay];
}
@end

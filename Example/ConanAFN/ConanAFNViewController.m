//
//  ConanAFNViewController.m
//  ConanAFN
//
//  Created by acct<blob>=<NULL> on 03/20/2017.
//  Copyright (c) 2017 acct<blob>=<NULL>. All rights reserved.
//

#import "ConanAFNViewController.h"
#import <ConanAFN/ConanAfnAPI.h>
@interface ConanAFNViewController ()

@end

@implementation ConanAFNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self Post];
}

-(void)Post
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"110120130", @"MobilePhone",
                         @"123456", @"Password",
                         nil];
    
   
    [ConanAfnAPI RequestWithURL:ConanAfnRequestMethodTypePOST Url:@"Login" Params:dic SuccessBlock:^(id returnData) {
        
        
    } FailureBlock:^(NSError *error) {
        
    } ShowHUB:ConanShowNothing ShowMessage:@""];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

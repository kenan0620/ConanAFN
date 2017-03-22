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
                         @"18810261020", @"MobilePhone",
                         @"123456", @"Password",
                         nil];
    
   
    [ConanAfnAPI RequestWithURL:ConanAfnRequestMethodTypePOST Url:@"UserManage/AppLogin" Params:dic SuccessBlock:^(id returnData) {
        
        NSLog(@"returnData%@",returnData);
        NSLog(@"%@",returnData[@"States"][@"Description"]);
    } FailureBlock:^(NSError *error) {
        
    } ShowHUB:ConanShowNothing ShowMessage:@""];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

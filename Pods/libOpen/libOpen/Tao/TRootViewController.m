//
//  TRootViewController.m
//  libOpen
//
//  Created by traintrackcn on 13-1-31.
//
//

#import "TRootViewController.h"
#import "TNibUtil.h"

@interface TRootViewController ()

@end

@implementation TRootViewController



- (void)pushVC:(NSString *)name{
    UIViewController *vc = [TNibUtil instantiateObjectFromNibWithName:name];
    [self pushViewController:vc animated:YES];
}

- (void)presentVC:(NSString *)name{
    UIViewController *vc = [TNibUtil instantiateObjectFromNibWithName:name];
    [self presentViewController:vc animated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end

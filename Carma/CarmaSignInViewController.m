//
//  CarmaSignInViewController.m
//  Carma
//
//  Created by Jeremy Lubin on 7/3/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaSignInViewController.h"
#import "AppDelegate.h"
#import "CarmaRootViewController.h"
#import "CarmaDriver.h"
#import "NSString+MD5.h"
#import "SBJSON.h"
#import <QuartzCore/QuartzCore.h>

static NSString* const UserIDKey = @"UserID";
static NSString* const UsernameKey = @"Username";
static NSString* const PasswordKey = @"Password";
static NSString* const FirstNameKey = @"FirstName";

@interface CarmaSignInViewController ()

@end

@implementation CarmaSignInViewController

@synthesize usernameField;
@synthesize passwordField;
@synthesize swirl;

// ------------------------------------------------------
// Set up signin view
// ------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Set up initial sign in page
        self.title = @"Sign in";
        
        CGRect frame = CGRectMake(self.view.frame.origin.x,
                                  0,
                                  self.view.frame.size.width,
                                  self.view.frame.size.height);
        
        //UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"modal_background.png"]];
        //UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueprint_background_normal.png"]];
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smooth_background_normal.png"]];
        background.frame = frame;
        [self.view addSubview:background];
        //self.view.backgroundColor = [UIColor colorWithRed:.36 green:.65 blue:.79 alpha:1]; 
        
//        // Add header bar
//        CGRect navBarFrame = CGRectMake(self.view.frame.origin.x,
//                                        0,
//                                        self.view.frame.size.width,
//                                        44);
//        
//        UIToolbar *navBar = [[UIToolbar alloc] initWithFrame:navBarFrame];
//        [navBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_clear.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
//        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelSignIn)];
//        UIBarButtonItem *signInButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign In" style:UIBarButtonItemStyleDone target:self action:@selector(validateSignIn)];
//        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        NSArray *buttons = [[NSArray alloc] initWithObjects:cancelButton, space, signInButton, nil];
//        [navBar setItems:buttons];
//        [self.view addSubview:navBar];
//        
//        UIImageView *topDivet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divet_bottom.png"]];
//        topDivet.frame = CGRectMake(self.view.frame.origin.x,
//                                    navBarFrame.size.height + 1,
//                                    self.view.frame.size.width,
//                                    1);
//        [self.view addSubview:topDivet];
//        UIImageView *bottomDivet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divet_top.png"]];
//        bottomDivet.frame = CGRectMake(self.view.frame.origin.x,
//                                    navBarFrame.size.height,
//                                    self.view.frame.size.width,
//                                    1);
//        [self.view addSubview:bottomDivet];
        
        UIImage *signinButtonImageNormal = [UIImage imageNamed:@"nav_button.png"];
        UIImage *stretchableSigningButtonImageNormal = [signinButtonImageNormal stretchableImageWithLeftCapWidth:8 topCapHeight:8];
                
        UIImage *signinButtonImagePressed = [UIImage imageNamed:@"nav_button_pressed.png"];
        UIImage *stretchableSigningButtonImagePressed = [signinButtonImagePressed stretchableImageWithLeftCapWidth:8 topCapHeight:8];
        
        UIImageView *carma = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carma_recessed.png"]];
        carma.frame = CGRectMake(0, 18, self.view.frame.size.width, 50);
        [self.view addSubview:carma];
        
        // Add sign in table        
        int tableOffset = 20;
        
        CGRect tableFrame = CGRectMake(self.view.frame.origin.x + tableOffset,
                                        32,
                                        self.view.frame.size.width - (tableOffset * 2),
                                        self.view.frame.size.height - 44);
        
        UITableView *signinTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
//        signinTable.backgroundColor = [UIColor clearColor];
        signinTable.backgroundColor = nil;
        [signinTable setBackgroundView:nil];
        signinTable.delegate = self;
        signinTable.dataSource = self;
        [self.view addSubview:signinTable];
        
        UIButton *signinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        signinButton.frame = CGRectMake(38, 190, tableFrame.size.width - 36, 38);
        [signinButton setBackgroundImage:stretchableSigningButtonImageNormal forState:UIControlStateNormal];
        [signinButton setBackgroundImage:stretchableSigningButtonImagePressed forState:UIControlStateHighlighted];
        [signinButton setTitle:@"Sign in!" forState:UIControlStateNormal];
        [signinButton setTitle:@"Signing in..." forState:UIControlStateDisabled];
        signinButton.titleLabel.font = [UIFont fontWithName:@"Heiti TC" size:19.0];
        [signinButton addTarget:self action:@selector(validateSignIn) forControlEvents:UIControlEventTouchUpInside];
        
        int height = signinButton.frame.size.height - 1;
        UIView *buttonBackground = [[UIView alloc] initWithFrame:CGRectMake(signinButton.frame.origin.x,
                                                                            signinButton.frame.origin.y,
                                                                            signinButton.frame.size.width,
                                                                            height)];
        buttonBackground.layer.cornerRadius = 4.0f;
        buttonBackground.backgroundColor = [UIColor colorWithRed:144/255. green:233/255. blue:179/255. alpha:1];
        
        [self.view addSubview:buttonBackground];
        [self.view addSubview:signinButton];
        
        UIButton *signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        signupButton.frame = CGRectMake(38, self.view.frame.size.height - 70, tableFrame.size.width - 36, 38);
        [signupButton setBackgroundImage:stretchableSigningButtonImageNormal forState:UIControlStateNormal];
        [signupButton setBackgroundImage:stretchableSigningButtonImagePressed forState:UIControlStateHighlighted];
        [signupButton setTitle:@"+ Sign up" forState:UIControlStateNormal];
        [signupButton setTitle:@"Signing up..." forState:UIControlStateDisabled];
        signupButton.titleLabel.font = [UIFont fontWithName:@"Heiti TC" size:19.0];
        [signupButton addTarget:self action:@selector(showSignUpView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:signupButton];
        
        // Add sign in activity indicator
        self.swirl = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        swirl.frame = CGRectMake((self.view.frame.size.width - swirl.frame.size.width) / 2,
                                 260,
                                 swirl.frame.size.width,
                                 swirl.frame.size.height);
        swirl.hidesWhenStopped = YES;
        [self.view addSubview:swirl];
        
    }
    return self;
}

// ------------------------------------------------------
// Sign in methods
// ------------------------------------------------------

- (void)validateSignIn
{
    BOOL error = NO;
    NSString *errorMsg = @"You forgot your: \n\n";
    
    if ([usernameField.text isEqualToString:@""]) {
        errorMsg = [errorMsg stringByAppendingString:@"Email address\n"];
        error = YES;
    }
    
    if ([passwordField.text isEqualToString:@""]) {
        errorMsg = [errorMsg stringByAppendingString:@"Password\n"];
        error = YES;
    }
    
    errorMsg = [errorMsg stringByAppendingString:@"\nMind trying again?"];
    
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops"
                                                        message:errorMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"Sure!"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    else {
        [self attemptSignIn];
    }
}

- (void)attemptSignIn
{
    [swirl startAnimating];
    usernameField.enabled = NO;
    passwordField.enabled = NO;
    
    LLDataDownloader *signIn = [[LLDataDownloader alloc] init];
    signIn.delegate = self;
    
    NSString *url = [NSString stringWithFormat:@"http://carma.io/scripts/server/carma_sign_in.php"];
    NSString *params = [NSString stringWithFormat:@"username=%@&password=%@",
                        usernameField.text, [passwordField.text MD5]];
    if (![signIn postDataWithURL:url andParams:params]) {NSLog(@"Couldn't download %@", url);}
}

- (void)dataHasFinishedDownloadingForDownloader:(LLDataDownloader *)downloader withResult:(BOOL)result andData:(NSData *)data
{
    
    // Stop the swirl
    [swirl stopAnimating];
    
    // Parse the JSON data returned
    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([responseString isEqualToString:@"-1"] || [responseString isEqualToString:@"0"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops"
                                                        message:@"Shoot, either the email or password you entered wasn't quite right. Mind tryin again?"
                                                       delegate:nil
                                              cancelButtonTitle:@"Sure!"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    else
    {
        // Parse driver data
        SBJSON *jsonParser = [SBJSON new];	
        NSDictionary *driverData = [jsonParser objectWithString:responseString];
        
        // Save the user's data in our data model
        CarmaDriver *driver = [[CarmaDriver alloc] initWithDictionary:driverData];
        
        // Save the user's idea so they don't need to log in next time
        [[NSUserDefaults standardUserDefaults] setObject:driver.uID forKey:UserIDKey];
        [[NSUserDefaults standardUserDefaults] setObject:usernameField.text forKey:UsernameKey];
        [[NSUserDefaults standardUserDefaults] setObject:[passwordField.text MD5] forKey:PasswordKey];
        [[NSUserDefaults standardUserDefaults] setObject:driver.firstName forKey:FirstNameKey];
        
        // Tell the system that we've successfully logged in
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CarmaUserLoggedInNotification" object:driver];
        
        // Get rid of the sign in view
        [self cancelSignIn];
    }
    
    // Re-engate the text fields
    usernameField.enabled = YES;
    passwordField.enabled = YES;
}

- (void)cancelSignIn
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CarmaRootViewController *rootViewController = delegate.rootViewController;
    [rootViewController dismissModalViewControllerAnimated:YES];
    //[self dismissModalViewControllerAnimated:YES];
}

- (void)showSignUpView
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CarmaRootViewController *rootViewController = delegate.rootViewController;
    //[self dismissModalViewControllerAnimated:NO];
    [rootViewController showSignUpView];
    //[rootViewController performSelector:@selector(showSignUpView) withObject:nil afterDelay:0];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //int horizontalOffset = 
    
    CGRect textFieldFrame = CGRectMake(20,
                                       12,
                                       cell.frame.size.width - 40,
                                       cell.frame.size.height - 20);
    
    if (indexPath.row == 0)
    {
        if (self.usernameField == nil)
        {
            self.usernameField = [[UITextField alloc] initWithFrame:textFieldFrame];
            usernameField.text = @"";
            usernameField.placeholder = @"Email";
            usernameField.keyboardType = UIKeyboardTypeEmailAddress;
            usernameField.returnKeyType = UIReturnKeyNext;
            usernameField.delegate = self;
            
            [cell addSubview:usernameField];
        }
    }
    
    else if (indexPath.row == 1)
    {
        if (self.passwordField == nil)
        {
            self.passwordField = [[UITextField alloc] initWithFrame:textFieldFrame];
            passwordField.text = @"";
            passwordField.placeholder = @"Password";
            passwordField.returnKeyType = UIReturnKeyDone;
            passwordField.secureTextEntry = YES;
            passwordField.delegate = self;
            
            [cell addSubview:passwordField];
        }
    }
    
    return cell;
}

/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    return header;
}*/

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark -
#pragma mark Text Field Methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.usernameField) {
        [passwordField becomeFirstResponder];
    }
    
    else if (textField == self.passwordField) {
        [passwordField resignFirstResponder];
        [self validateSignIn];
    }
    
    return YES;
    
}


@end

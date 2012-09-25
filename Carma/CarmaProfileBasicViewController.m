//
//  CarmaProfileBasicViewController.m
//  Carma
//
//  Created by Jeremy Lubin on 7/4/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaProfileBasicViewController.h"
#import "CarmaSignUpViewController.h"
#import "NSString+MD5.h"
#import <QuartzCore/QuartzCore.h>

#define kInfoSection        0
#define kPhotoSection       1

#define kFirstNameField     0
#define kLastNameField      1
#define kUsernameField      2
#define kPasswordField      3

static NSString* const CameraText = @"Let's do it now";
static NSString* const ChooserText = @"I've got a good one...";

@interface CarmaProfileBasicViewController ()

@end

@implementation CarmaProfileBasicViewController

@synthesize table;
@synthesize firstNameField;
@synthesize lastNameField;
@synthesize usernameField;
@synthesize passwordField;
@synthesize imageData;
@synthesize delegate;

// ------------------------------------------------------
// Sign in methods
// ------------------------------------------------------

- (void)validateSignIn
{
    BOOL error = NO;
    NSString *errorMsg = @"You forgot your: \n\n";
    
    if ([firstNameField.text isEqualToString:@""]) {
        errorMsg = [errorMsg stringByAppendingString:@"First name\n"];
        error = YES;
    }
    
    if ([lastNameField.text isEqualToString:@""]) {
        errorMsg = [errorMsg stringByAppendingString:@"Last name\n"];
        error = YES;
    }
    
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
    //[swirl startAnimating];
    firstNameField.enabled = NO;
    lastNameField.enabled = NO;
    usernameField.enabled = NO;
    passwordField.enabled = NO;
    
    LLDataDownloader *signIn = [[LLDataDownloader alloc] init];
    signIn.delegate = self;
    
    NSString *url = [NSString stringWithFormat:@"http://carma.io/scripts/server/check_username.php"];
    NSString *params = [NSString stringWithFormat:@"username=%@",usernameField.text];
    if (![signIn postDataWithURL:url andParams:params]) {NSLog(@"Couldn't download %@", url);}
}

- (void)dataHasFinishedDownloadingForDownloader:(LLDataDownloader *)downloader withResult:(BOOL)result andData:(NSData *)data
{
    
    // Stop the swirl
    //[swirl stopAnimating];
    
    // Parse the JSON data returned
    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", responseString);
    
    if ([responseString isEqualToString:@"-1"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey!"
                                                        message:@"Looks like you're already signed up. Hit cancel and log in :-)"
                                                       delegate:nil
                                              cancelButtonTitle:@"Go!"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    else if ([responseString isEqualToString:@"-2"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Darn"
                                                        message:@"That doesn't look like an email to us. Mind trying a different one?"
                                                       delegate:nil
                                              cancelButtonTitle:@"Sure!"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    else if ([responseString isEqualToString:@"1"])
    {
        // Move to next screen and store values
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:usernameField.text, @"userName",
                                           [passwordField.text MD5], @"password",
                                           firstNameField.text, @"firstName",
                                           lastNameField.text, @"lastName", 
                                           imageData, @"image", nil];
        if ([delegate respondsToSelector:@selector(basicProfileCreationSucceededWithDictionary:)]) {
            [delegate basicProfileCreationSucceededWithDictionary:attributes];
        }
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Apologies"
                                                        message:@"Something went wrong on our end. Mind trying again?"
                                                       delegate:nil
                                              cancelButtonTitle:@"Sure!"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Re-engate the text fields
    firstNameField.enabled = YES;
    lastNameField.enabled = YES;
    usernameField.enabled = YES;
    passwordField.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add sign in table        
    int tableOffset = 20;   
    
    CGRect tableFrame = CGRectMake(tableOffset,
                                   0,
                                   self.view.frame.size.width - (tableOffset * 2),
                                   self.view.frame.size.height);
    
    self.table = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
    table.backgroundColor = [UIColor clearColor];
    [self.table setBackgroundView:nil];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
//    UIImageView *carma = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carma_recessed.png"]];
//    carma.frame = CGRectMake(0, self.view.frame.size.height - 100 - 44, self.view.frame.size.width, 50);
//    [self.view addSubview:carma];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGRect textFieldFrame = CGRectMake(20,
                                       12,
                                       cell.frame.size.width - 40,
                                       cell.frame.size.height - 20);
    
    if (indexPath.section == kInfoSection)
    {
        if (indexPath.row == kFirstNameField)
        {
            if (self.firstNameField == nil)
            {
                self.firstNameField = [[UITextField alloc] initWithFrame:textFieldFrame];
                firstNameField.text = @"";
                firstNameField.placeholder = @"First name";
                firstNameField.returnKeyType = UIReturnKeyNext;
                firstNameField.delegate = self;
                
                [cell addSubview:firstNameField];
            }
        }
        
        else if (indexPath.row == kLastNameField)
        {
            if (self.lastNameField == nil)
            {
                self.lastNameField = [[UITextField alloc] initWithFrame:textFieldFrame];
                lastNameField.text = @"";
                lastNameField.placeholder = @"Last name";
                lastNameField.returnKeyType = UIReturnKeyNext;
                lastNameField.delegate = self;
                
                [cell addSubview:lastNameField];
            }
        }
        
        else if (indexPath.row == kUsernameField)
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
        
        else if (indexPath.row == kPasswordField)
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
    }
    else if (indexPath.section == kPhotoSection)
    {
//        CGRectMake((cell.frame.size.width - 50) / 2,
//                   (cell.frame.size.height - 50) / 2,
//                   50,
//                   50)
        UIButton *card = [[UIButton alloc] initWithFrame:CGRectMake(cell.frame.origin.x,
                                                                          0,
                                                                          cell.frame.size.width - 60,
                                                                          self.view.frame.size.height - (tableView.rowHeight * 4) - 45)];
        [card setImage:[UIImage imageNamed:@"id_icon.png"] forState:UIControlStateNormal];
        [card setImage:[UIImage imageNamed:@"id_icon_highlighted.png"] forState:UIControlStateHighlighted];
        card.contentMode = UIViewContentModeCenter;
        card.titleLabel.text = @"Smile for the camera :-)";
        card.titleLabel.textColor = [UIColor grayColor];
        [card addTarget:self action:@selector(choosePhotoMethod) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:card];
        //card.backgroundColor = [UIColor greenColor];
    }
        
    return cell;
}

- (void)choosePhotoMethod
{
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    sheet.title = @"It's picture day!";
    sheet.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [sheet addButtonWithTitle:CameraText];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [sheet addButtonWithTitle:ChooserText];
    }
    
    [sheet addButtonWithTitle:@"I'm not ready."];
    sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
    
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:CameraText])
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:ChooserText])
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        CarmaSignUpViewController *view = (CarmaSignUpViewController *)delegate;
        [view presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kPhotoSection]];
    UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 1, cell.frame.size.width - 20, cell.frame.size.height - 2)];
    photoView.contentMode = UIViewContentModeScaleToFill;
    photoView.layer.cornerRadius = 9.0f;
    photoView.clipsToBounds = YES;
    photoView.image = image;
    [cell addSubview:photoView];
    
    // TODO get the image size right
    
    self.imageData = UIImagePNGRepresentation(image);
    
    CarmaSignUpViewController *view = (CarmaSignUpViewController *)delegate;
    [view dismissModalViewControllerAnimated:YES];
    
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kPhotoSection)
    {
        return self.view.frame.size.height - (tableView.rowHeight * 4) - 45;
    }
    
    else return 44;
}

#pragma mark -
#pragma mark Text Field Methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.firstNameField)
    {
        [lastNameField becomeFirstResponder];
    }
    
    else if (textField == self.lastNameField)
    {
        [usernameField becomeFirstResponder];
    }
    
    else if (textField == self.usernameField)
    {
        [passwordField becomeFirstResponder];
    }
    
    else if (textField == self.passwordField) {
        [passwordField resignFirstResponder];
        [self validateSignIn];
    }
    
    return YES;
    
}

@end

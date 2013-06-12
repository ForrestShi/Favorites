//
//  MyFavoriteViewController.m
//  TestCollectionView
//
//  Created by forrest on 13-6-10.
//  Copyright (c) 2013年 DFA. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "BlocksKit.h"
#import "UIColor+Colours.h"
#import "UIColor+FlatUI.h"
#import "SettingViewController.h"
#import "BaseModel.h"
#import "People.h"
#import "Group.h"


@interface MyFavoriteViewController ()<UICollectionViewDataSource, UICollectionViewDelegate ,ABPeoplePickerNavigationControllerDelegate , UIGestureRecognizerDelegate ,FUIAlertViewDelegate>

@property (nonatomic,assign) BOOL editing;
@end

@implementation MyFavoriteViewController
@synthesize editing;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[LARSAdController sharedManager] addAdContainerToViewInViewController:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.collectionView reloadData];
    self.editing = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor ghostWhiteColor];
    
    UITapGestureRecognizer *tapToStop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopEdit)];
    tapToStop.delegate = self;
    [self.view addGestureRecognizer:tapToStop];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    infoBtn.frame = CGRectMake(self.view.frame.size.width - 44., self.view.frame.size.height - 44., 44., 44.);
    [infoBtn addTarget:self action:@selector(onInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoBtn];
}

- (void)onInfo{

    SettingViewController *settingVC = [[SettingViewController alloc] init];
    [self presentViewController:settingVC animated:YES completion:^{
        
    }];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view.frame.size.width < 300 ) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [Group sharedInstance].favorites.count + 2;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPat{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPat];
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView *delBtn = (UIImageView*)[cell viewWithTag:102];
    delBtn.hidden = YES;
    delBtn.alpha = 0.;
    
    [((UILabel*)[cell viewWithTag:101]) setTextAlignment:NSTextAlignmentCenter];
    [((UILabel*)[cell viewWithTag:101]) setTextColor:[UIColor whiteColor]];
    //[((UILabel*)[cell viewWithTag:101]) setFont:[UIFont fontWithName:@"Symbol" size:22. ]];
    [((UILabel*)[cell viewWithTag:101]) setFont:[UIFont flatFontOfSize:22.]];
    [((UILabel*)[cell viewWithTag:101]) setNumberOfLines:0];
    
    if (indexPat.row == [Group sharedInstance].favorites.count) {
        //the last one
        cell.backgroundColor = [UIColor skyeBlueColor];
        [((UILabel*)[cell viewWithTag:101]) setText:@"ADD"];
        UIImageView *imgView = (UIImageView*)[cell viewWithTag:100];
        imgView.image = nil;
                
    }else if(indexPat.row == ([Group sharedInstance].favorites.count+1) ){
        cell.backgroundColor = [UIColor lightCreamColor];
        [((UILabel*)[cell viewWithTag:101]) setText:@"EDIT"];
        UIImageView *imgView = (UIImageView*)[cell viewWithTag:100];
        imgView.image = nil;
        
        if (self.editing) {
            [UIView animateWithDuration:.3 animations:^{
                cell.backgroundColor = [UIColor infoBlueColor];
            }];
        }else{
            cell.backgroundColor = [UIColor lightCreamColor];
        }

    }else if (indexPat.row < [Group sharedInstance].favorites.count ){
        cell.backgroundColor = [UIColor coffeeColor];
        UILabel *nameLabel = (UILabel*)[cell viewWithTag:101];
        UIImage* img = ((People*)[[Group sharedInstance].favorites objectAtIndex:indexPat.row]).faceImage;
        UIImageView *imgView = (UIImageView*)[cell viewWithTag:100];
        imgView.image = img;
        if (!img) {
            nameLabel.text = ((People*)[[Group sharedInstance].favorites objectAtIndex:indexPat.row]).name;
        }else{
            nameLabel.text = @"";
        }
        
        if (self.editing) {
            delBtn.hidden = NO;
            delBtn.alpha = 0.;
            [UIView animateWithDuration:.3 animations:^{
                delBtn.alpha = 1.;
                cell.backgroundColor = [UIColor brownColor];
                cell.alpha = 0.6;
                
            }];
        }else{
            [UIView animateWithDuration:.3 animations:^{
                delBtn.alpha = 0.;
                cell.backgroundColor = [UIColor greenSeaColor];
                cell.alpha = 1.;

            } completion:^(BOOL finished) {
                delBtn.hidden = YES;
            }];
            
        }

    }
    
    return cell;
}

- (void)startEdit{
    self.editing = YES;
    [self.collectionView reloadData];
}

- (void)stopEdit{
    self.editing = NO;
    [self.collectionView reloadData];
}

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0 ) {
        [Flurry logEvent:@"buy"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/app/id%@?mt=8&ls=1",@"661012216"]]];
    }
}

- (void)addOneFavorite{
    [Flurry logEvent:@"Add"];
#if LITE
    if ([Group sharedInstance].favorites.count > 5 ) {
        
        FUIAlertView *alert = [[FUIAlertView alloc] initWithTitle:@"Hi" message:@"This is a free version !" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Buy", nil];
        [alert show];
        [Flurry logEvent:@"show lite msg"];
        return;
    }
#endif
    ABAddressBookRef addressBook = ABAddressBookCreate();
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //dispatch_release(sema);
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted) {
        // Do whatever you want here.
        
        ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.editing) {
        if (indexPath.row < [Group sharedInstance].favorites.count) {
            if ([Group sharedInstance].favorites) {
                DLog(@"remove one ");
                [Flurry logEvent:@"Delete"];
                [[Group sharedInstance].favorites removeObjectAtIndex:indexPath.row];

                [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
                [self.collectionView reloadData];
                if ([Group sharedInstance].favorites.count == 0 ) {
                    [self stopEdit];
                }
                return;
            }
        }else if (indexPath.row == [Group sharedInstance].favorites.count){
            [self stopEdit];
            [self addOneFavorite];
            return;
        }else if (indexPath.row == ([Group sharedInstance].favorites.count+1) ){
            [self stopEdit];
            return;
        }

    }else{
        
        if (indexPath.row < [Group sharedInstance].favorites.count) {

            NSString *phone = [NSString stringWithFormat:@"telprompt://%@", ((People*)[[Group sharedInstance].favorites objectAtIndex:indexPath.row]).phone];
            DLog(@"called %@", phone);

            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            [self.view bringSubviewToFront:cell];
            [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAutoreverse animations:^{
                cell.alpha = 0.3;
            } completion:^(BOOL finished) {
                cell.alpha = 1.;
            }];
            
            if (phone) {
                
                [Flurry logEvent:@"Call"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
            }else{
                //TODO:
                
                [Flurry logEvent:@"Call None"];
                DLog(@"no phone");
            }
        

        }else if (indexPath.row == [Group sharedInstance].favorites.count){
            [self addOneFavorite];
        }else if (indexPath.row == ([Group sharedInstance].favorites.count+1) ){
            [self startEdit];
        }

    }
        

}


// Called after the user has pressed cancel
// The delegate is responsible for dismissing the peoplePicker
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

// Called after a person has been selected by the user.
// Return YES if you want the person to be displayed.
// Return NO  to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    //获取联系人姓名
    People *newFriend = [[People alloc] init];

    NSString *name = (__bridge NSString*)ABRecordCopyCompositeName(person);
    //获取联系人电话
    NSMutableArray *arPhList = [[NSMutableArray alloc] init];
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
    {
        CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
        NSString *phoneLabel =(__bridge NSString*) ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phones, j));
        NSString *phoneNumber = (__bridge NSString *)phoneNumberRef;
                
        // nifty  trick to remove all other characters in a phone #
        // remember 3015271111 can be stored in many ways using +, (, ), . etc characters.
        // we want to eliminate all characters that are not digits and them compare
        
        NSCharacterSet* nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet]; // all characters that are not digits
        NSString *strippedPhone = [[phoneNumber componentsSeparatedByCharactersInSet: nonDigits] componentsJoinedByString: @""]; // take them off
                
        NSDictionary *dicTemp = [[NSDictionary alloc]initWithObjectsAndKeys:strippedPhone,@"value", phoneLabel,@"label", nil];
        [arPhList addObject:dicTemp];
    }
    
    NSString *aPhone = @"0";
    if (arPhList.count > 0 ) {
        aPhone = [[arPhList objectAtIndex:0] objectForKey:@"value"];

    }
    
    newFriend.name = name;
    newFriend.phone = aPhone;
    
    if (ABPersonHasImageData(person)) {
        UIImage *addressVookImage = [UIImage imageWithData:(__bridge NSData*)ABPersonCopyImageData(person)];
        newFriend.faceImage = [addressVookImage scaleByFactor:.5];
    }

    
    [[Group sharedInstance].favorites insertObject:newFriend atIndex:0];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        [[Group sharedInstance] save];
//    });
    [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] ];
    [self.collectionView reloadData];
    
    DLog(@"name %@ phone %@", name, aPhone);
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    return NO;
}

@end

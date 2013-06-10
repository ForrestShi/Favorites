//
//  MyFavoriteViewController.m
//  TestCollectionView
//
//  Created by forrest on 13-6-10.
//  Copyright (c) 2013年 DFA. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import <AddressBookUI/AddressBookUI.h>

@interface People : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) UIImage *faceImage;

@end

@implementation People
@synthesize name,phone,faceImage;
@end

@interface MyFavoriteViewController ()<UICollectionViewDataSource, UICollectionViewDelegate ,ABPeoplePickerNavigationControllerDelegate , UIGestureRecognizerDelegate>

@property (nonatomic,strong) NSMutableArray *friends;
@property (nonatomic,assign) BOOL editing;
@end

@implementation MyFavoriteViewController
@synthesize friends,editing;


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
    friends = [NSMutableArray array];
    [self.collectionView reloadData];
    self.editing = NO;
    
    UILongPressGestureRecognizer *editGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startEdit)];
    UITapGestureRecognizer *tapToStop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopEdit)];
    tapToStop.delegate = self;
    
    [self.view addGestureRecognizer:editGesture];
    [self.view addGestureRecognizer:tapToStop];
}

- (void)startEdit{
    self.editing = YES;
    [self.collectionView reloadData];
}

- (void)stopEdit{
    self.editing = NO;
    [self.collectionView reloadData];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return self.editing;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return friends.count + 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPat{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPat];
    cell.backgroundColor = [UIColor whiteColor];
    
    UIButton *delBtn = (UIButton*)[cell viewWithTag:102];
    delBtn.hidden = YES;
    delBtn.alpha = 0.;
    [delBtn addTarget:self action:@selector(onDelete:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (indexPat.row == friends.count) {
        //the last one
        cell.backgroundColor = [UIColor redColor];
    }else{
        
        UILabel *nameLabel = (UILabel*)[cell viewWithTag:101];
        nameLabel.text = ((People*)[friends objectAtIndex:indexPat.row]).name;
        UIImage* img = ((People*)[friends objectAtIndex:indexPat.row]).faceImage;
        if (img) {
            UIImageView *imgView = (UIImageView*)[cell viewWithTag:100];
            imgView.image = img;
        }
        
        if (self.editing) {
            cell.backgroundColor = [UIColor blueColor];
            delBtn.hidden = NO;
            [UIView animateWithDuration:.3 animations:^{
                delBtn.alpha = 1.;
            }];
        }else{
            delBtn.hidden = YES;
            [UIView animateWithDuration:.3 animations:^{
                delBtn.alpha = 0.;
            }];

        }
    }
    
    
    return cell;
}

- (void)onDelete:(id)sender{
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

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
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *aPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, 0);

    newFriend.name = name;
    newFriend.phone = aPhone;
    
    if (ABPersonHasImageData(person)) {
        UIImage *addressVookImage = [UIImage imageWithData:(__bridge NSData*)ABPersonCopyImageData(person)];
        newFriend.faceImage = addressVookImage;
    }

    
    [friends addObject:newFriend];
    [self.collectionView reloadData];
    
    NSLog(@"name %@ phone %@", name, aPhone);
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    return NO;
}

@end

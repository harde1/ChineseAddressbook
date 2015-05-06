//
//  ViewController.m
//  AddressbookDemo
//
//  Created by Donal on 14-1-8.
//  Copyright (c) 2014年 vikaa. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property(nonatomic,assign)NSInteger currentIndex;


@end

@implementation ViewController
@synthesize dataSource,friendAplha,friendDictionary,addressBook;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mtableView = ({UITableView * tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.view addSubview:tableview];
        tableview.delegate = self;
        tableview.dataSource = self;
        
        tableview;
    });
    
    
    
    //中间提示圆形view
    _label_tip = ({
        UILabel * label = [UILabel new];
        label.backgroundColor = [UIColor grayColor];
        
        label.text = @"A";
        label.font = [UIFont boldSystemFontOfSize:25];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UIBaselineAdjustmentAlignCenters;
        label.hidden = YES;
        label.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame)/4., CGRectGetWidth(self.view.frame)/4.);
        label.center = CGPointMake(CGRectGetWidth(self.view.frame)/2., CGRectGetHeight(self.view.frame)/2.-60);
        
        label.layer.cornerRadius = CGRectGetWidth(label.frame)/2.;
        label.layer.masksToBounds = YES;
        [self.view addSubview:label];
        
        label;
    });
    
    
    
    RHAddressBook *ab = [[RHAddressBook alloc] init] ;
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusNotDetermined){
        __weak id this = self;
        [ab requestAuthorizationWithCompletion:^(bool granted, NSError *error) {
            [this initData:ab];
        }];
    }
    
    
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通讯录提示" message:@"请在iPhone的[设置]->[隐私]->[通讯录]，允许群友通讯录访问你的通讯录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // warn re restricted access to contacts
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusRestricted){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通讯录提示" message:@"请在iPhone的[设置]->[隐私]->[通讯录]，允许群友通讯录访问你的通讯录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self initData:ab];
}


-(void)initData:(RHAddressBook *)ad
{
    addressBook = ad;
    friendAplha = [NSMutableArray array];
    NSString *regex = @"^[A-Za-z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *people = [self.addressBook peopleOrderedByUsersPreference];
        for (RHPerson *person in people) {
            NSString *c = [[person.name substringToIndex:1] uppercaseString];
            if ([predicate evaluateWithObject:c]) {
                [person setFirstNamePhonetic:c];
            }
            else {
                NSString *alpha = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([person.name characterAtIndex:0])] uppercaseString];
                [person setFirstNamePhonetic:alpha];
            }
        }
        
        NSArray *sortedArray;
        sortedArray = [people sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
                       {
                           NSString *first = [(RHPerson*)a firstNamePhonetic];
                           NSString *second = [(RHPerson*)b firstNamePhonetic];
                           return [first compare:second];
                       }];
        
        NSMutableDictionary *sectionDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        for (RHPerson *person in sortedArray) {
            NSString *spellKey = person.firstNamePhonetic;
            if ([sectionDict objectForKey:spellKey]) {
                NSMutableArray *currentSecArray = [sectionDict objectForKey:spellKey];
                [currentSecArray addObject:person];
            }
            else {
                [self.friendAplha addObject:spellKey];
                NSMutableArray *currentSecArray = [[NSMutableArray alloc] initWithCapacity:0];
                [currentSecArray addObject:person];
                [sectionDict setObject:currentSecArray forKey:spellKey];
            }
        }
        
        self.friendDictionary = sectionDict;
        
        //索引数组
        self.dataSource = [[NSMutableArray alloc] init] ;
        for(char c = 'A'; c <= 'Z'; c++ )
        {
            [self.dataSource addObject:[NSString stringWithFormat:@"%c",c]];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mtableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            [self.mtableView reloadData];
        });
    });
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return friendAplha.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (view == nil) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
    }
    NSString *key = [friendAplha objectAtIndex:section];
    view.textLabel.text = key;
    
    return view;
}



- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return dataSource;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    self.label_tip.hidden = NO;
    NSInteger count = 0;
    
    [friendAplha containsObject:title]?(count = [friendAplha indexOfObject:title]):(count = self.currentIndex);
    self.label_tip.text = title;
    
    //这里的动画有个判断就是在3内，没有新的指令就执行
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    
    
    [[NSUserDefaults standardUserDefaults]setDouble:currentTime forKey:@"延时特效"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    double delayInSeconds = 0.1;
    // 创建延期的时间 2S，因为dispatch_time使用的时间是纳秒，尼玛，比毫秒还小，太夸张了！！！
    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_global_queue(0, 0), ^{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            //            tableView.contentOffset = self.currentPoint;
            if (count!=0&&tableView.contentOffset.y>0) {
                [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:count] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_global_queue(0,0), ^{
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSTimeInterval timeNow = [[NSDate date] timeIntervalSince1970];
                    NSTimeInterval timeOld =[[NSUserDefaults standardUserDefaults]integerForKey:@"延时特效"];
                    //                    NSLog(@"%lf,%lf",timeNow,timeOld);
                    if (timeNow-timeOld>1) {
                        self.label_tip.alpha = 1;
                        [UIView animateWithDuration:1 animations:^{
                            self.label_tip.alpha = 0;
                        } completion:^(BOOL finished) {
                            self.label_tip.alpha = 1;
                            self.label_tip.hidden = YES;
                        }];
                    }
                });
                
            });
            
        });
        
    });
    
    
    self.currentIndex = count;
    return count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [friendAplha objectAtIndex:section];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [friendAplha objectAtIndex:section];
    NSArray *keyArray = [friendDictionary objectForKey:key];
    return keyArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier    = @"friend";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *alpha     = [friendAplha objectAtIndex:indexPath.section];
    NSArray *alphaArray = [friendDictionary objectForKey:alpha];
    RHPerson *person    = [alphaArray objectAtIndex:indexPath.row];
    person.firstNamePhonetic = @"";
    cell.textLabel.text = person.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //TODO: push our own viewer view, for now just use the AB default one.
    NSString *alpha     = [friendAplha objectAtIndex:indexPath.section];
    NSArray *alphaArray = [friendDictionary objectForKey:alpha];
    RHPerson *person    = [alphaArray objectAtIndex:indexPath.row];
    
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    
    //setup (tell the view controller to use our underlying address book instance, so our person object is directly updated)
    [person.addressBook performAddressBookAction:^(ABAddressBookRef addressBookRef) {
        personViewController.addressBook =addressBookRef;
    } waitUntilDone:YES];
    
    personViewController.displayedPerson = person.recordRef;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
    personViewController.allowsActions = YES;
#endif
    personViewController.allowsEditing = YES;
    
    
    [self.navigationController pushViewController:personViewController animated:YES];
}

@end

//
//  AddressBookViewController.h
//  AddressbookDemo
//
//  Created by cong on 15/5/5.
//  Copyright (c) 2015年 vikaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHAddressBook.h"
#import "RHPerson.h"
#import "pinyin.h"
#import <AddressBookUI/AddressBookUI.h>
@interface AddressBookViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic) RHAddressBook *addressBook;
@property(strong,nonatomic)NSMutableDictionary *friendDictionary;
@property(strong,nonatomic) NSMutableArray *friendAplha;
@property(strong,nonatomic)  NSMutableArray *dataSource;
@property (strong, nonatomic)UITableView *mtableView;
@property(strong,nonatomic)UILabel * label_tip;


@end

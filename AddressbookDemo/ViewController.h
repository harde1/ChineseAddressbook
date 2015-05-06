//
//  ViewController.h
//  AddressbookDemo
//
//  Created by Donal on 14-1-8.
//  Copyright (c) 2014年 vikaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHAddressBook.h"
#import "RHPerson.h"
#import "pinyin.h"
#import <AddressBookUI/AddressBookUI.h>
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic) RHAddressBook *addressBook;
@property(strong,nonatomic)NSMutableDictionary *friendDictionary;
@property(strong,nonatomic) NSMutableArray *friendAplha;
@property(strong,nonatomic)  NSMutableArray *dataSource;
@property (strong, nonatomic)UITableView *mtableView;
@property(strong,nonatomic)UILabel * label_tip;


@end

//
//  MyCalculationHeightCellViewController.m
//  Chat quickblox
//
//  Created by Admin on 01.04.18.
//  Copyright © 2018 Tsvigun Aleksander. All rights reserved.
//

#import "MyCalculationHeightCellViewController.h"
#import "TableViewCell.h"

#define screenWidth [[UIScreen mainScreen] bounds].size.width;
#define kCellHeight 44.0
//#define kCountSymbolsRow 44 //regular, light iphone 5 12
//#define kCountSymbolsRow 42.16 //regular, light 13
#define kCountSymbolsRow 58 //regular, lightiphone 7plus 13

@interface MyCalculationHeightCellViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSMutableDictionary *selectedIndexes;

@end

static NSString *const CellIdentifier = @"cell";

@implementation MyCalculationHeightCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = @[@"YouneedtocYouneedtocYouneedtocYouneedtocYoune",
                        @"YouneedtocYouneedtocYouneedtocYouneedtocYouneedtocYouneedt", @"VaxVoIP SIP call recording SDK provides tools, software components and sample codes to build SIP REC protocol based call recording servers",
                        @"SIP REC protocol is an extention of SIP protocol designed by the Internet Engineering Task Force (IETF) for controlling a call session (media) recoder.",
                        @"Call session recording is a critical requirement in many business communication environments such as IP-Telephony service providers (ITSP)",
                        @"Trading floors, banking and IP-PBX based offices",
                        @"VaxVoIP SIP REC SDK based call recording server allows VaxVoIP Phone SDK, VaxVoIP Server SDK and other third party SIP REC protocol supported softphones, SIP servers, SIP gateways, call session recording client, SIP REC supported SBC (session border controllers) to establish call recording connection",
                        @"Versatile approach to design and develop gu windows jj based whethe",
                        @"VBNet, Delphi, BorlandC++ etc",
                        @"What this does is check whether the cell is currently selected and if so returns double the normal height. kCellHeight is a compiler define and cellIsSelected: is a method which takes an indexPath and returns whether the cell is selected or not. This doesn’t come from the cell itself, instead I am just storing the selected state in an NSMutableDictionary keyed on the indexPath. Animate The Change So we know that returning a variable height in the heightForRowAtIndexPath method will result in the table sizing the cells accordingly, but how do we animate the change… \nWell simplicity itself… you simply use these two lines… What this results in is the UITableView re-evaluating its visible cells and setting their size accordingly but without reloading the data, and the best part? IT ANIMATES IT!",
                        @"A ready to use, demo application and sample codes are available to download, which help you to understand the development of SIP call recording server and services.",
                        @"Mit freundlichen Grüßen",
                        @"Der Inhalt dieser E-Mail ist vertraulich und ausschließlich für den Bezeichneten Adressaten bestimmt. Wenn Sie nicht der vorhergesehene Adressat dieser E-Mail oder dessen Vertreter sein sollten, so beachten Sie bitte, dass jede Form der Kenntnisnahme, Veröffentlichung, Vervielfältigung oder Weitergabe des Inhalts dieser E-Mail unzulässig ist. Wir bitten Sie, sich in diesem Fall mit dem Absender der E-Mail in Verbindung zu setzen",
                        @"The information transmitted is intended only for the person or entity to which",
                        @"The information transmitted is intended only for the p",
                        @"The information transmitted is intended only for the",
                        @"New",
                        @"Any review, re-transmission, dissemination or other use of or taking of any action in reliance upon, this information by persons or entities other than the intended recipient is prohibited. If you received this in error, please contact the sender and delete the material from any computer"];
    
    self.selectedIndexes = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self setUpCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - cell setup

- (void)setUpCell:(TableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    ///************************ мега важная строчка. В stotyboard снять флаг с этого свойства. А также numberOfLines в 0 и lineBreakMode на word-wrap ************************
    
    CGFloat height = screenWidth
    cell.titleLabel.preferredMaxLayoutWidth = height - 24;
    
    if ([self cellIsSelected:indexPath]) {
        cell.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    } else {
        cell.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    
    cell.titleLabel.text = [self.dataSource objectAtIndex:indexPath.row];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static TableViewCell *cell = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    });
    
    [self setUpCell:cell atIndexPath:indexPath];
    CGFloat heightCell = kCellHeight;
    
    // If our cell is selected, return double height
    if ([self cellIsSelected:indexPath]) {
        heightCell = [self calculateHeightForConfiguredSizingCell:cell index:indexPath.row];
    }
    
    // Cell isn't selected so return single height
    if (heightCell < kCellHeight) {
        heightCell = kCellHeight;
    }
    return heightCell;
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(TableViewCell *)sizingCell
                                            index:(NSInteger)indexPath
{
    [sizingCell layoutIfNeeded];
    
    NSString *text = self.dataSource[indexPath];
    
    CGFloat symbolsCount = [text length];
    
    NSUInteger numberOfOccurrences = [[text componentsSeparatedByString:@" "] count] - 1;

    CGFloat rowsCount = (symbolsCount - numberOfOccurrences) / kCountSymbolsRow;
    
    NSInteger number = [self roundedToGreater:rowsCount];
    
    UILabel *titleLabel = sizingCell.titleLabel;
    
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.frame.size.width, number * 16);
    
    CGFloat height = titleLabel.frame.size.height + 22;
    
    return height;
}

- (NSUInteger)roundedToGreater:(CGFloat)rowsFloat
{
    NSInteger num = rowsFloat;
    CGFloat fration = rowsFloat - num;
    if (fration > 0) {
        num = num + 1;
    }
    return num;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL isSelected = ![self cellIsSelected:indexPath];
    
    // Store cell 'selected' state keyed on indexPath
    NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];
    [self.selectedIndexes setObject:selectedIndex forKey:indexPath];
    
    // This is where magic happens...
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (BOOL)cellIsSelected:(NSIndexPath *)indexPath {
    // Return whether the cell at the specified index path is selected or not
    NSNumber *selectedIndex = [self.selectedIndexes objectForKey:indexPath];
    return selectedIndex == nil ? NO : [selectedIndex boolValue];
}

@end

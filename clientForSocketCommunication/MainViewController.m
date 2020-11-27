//
//  MainViewController.m
//  clientForSocketCommunication
//
//  Created by 许明洋 on 2020/11/27.
//

#import "MainViewController.h"
#import "TcpViewController.h"
#import "UdpViewController.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"主界面";
    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    return _tableView;
}

#pragma mark - UITableViewDelegate/datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"tcp测试";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"udp测试";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        TcpViewController *vc = [[TcpViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 1) {
        UdpViewController *vc = [[UdpViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end

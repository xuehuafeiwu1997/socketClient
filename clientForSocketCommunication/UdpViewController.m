//
//  FirstViewController.m
//  clientForSocketCommunication
//
//  Created by 许明洋 on 2020/11/26.
//

#import "UdpViewController.h"
#import "GCDAsyncUdpSocket.h" //for udp
#import "Masonry.h"

@interface UdpViewController ()<UITextFieldDelegate,GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) GCDAsyncUdpSocket *clientSocket;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) NSMutableArray *textArr;
@end

@implementation UdpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"socket通信中udp测试客户端";
    
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(30);
        make.top.equalTo(self.view).offset(60);
        make.height.equalTo(@60);
    }];
    
    [self.view addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.textField.mas_bottom).offset(30);
        make.width.greaterThanOrEqualTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
    
    [self startConnection];
}

- (UITextField *)textField {
    if (_textField) {
        return _textField;
    }
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 60, 60)];
    _textField.backgroundColor = [UIColor grayColor];
    _textField.textColor = [UIColor blackColor];
    _textField.delegate = self;
    return _textField;
}

- (NSMutableArray *)textArr {
    if (_textArr) {
        return _textArr;
    }
    _textArr = [NSMutableArray array];
    return _textArr;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"当前的文本为:%@",self.textField.text);
}

- (void)startConnection {
    self.clientSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    [self.clientSocket bindToPort:5558 error:&error];
    if (error) {
        NSLog(@"绑定端口失败，失败的原因是%@",error);
    }
}

- (void)sendMessage {
    if (!self.textField.text || [self.textField.text length] == 0) {
        return;
    }
    NSLog(@"开始发送数据");
    [self.textArr addObject:self.textField.text];
    NSData *data = [self.textField.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket sendData:data toHost:@"192.168.31.61" port:5557 withTimeout:-1 tag:self.textArr.count];
}

- (UIButton *)sendButton {
    if (_sendButton) {
        return _sendButton;
    }
    _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    return _sendButton;
}

#pragma mark - delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark - GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    NSLog(@"调用了该方法");
    NSLog(@"这是发出的第%ld个请求",tag);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"tag为%ld的数据发送错误",tag);
    NSLog(@"错误的原因为%@",error);
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError  * _Nullable)error {
    NSLog(@"socket被关闭");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError * _Nullable)error {
    NSLog(@"并没有连接，连接失败");
}

@end

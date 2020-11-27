//
//  TcpViewController.m
//  clientForSocketCommunication
//
//  Created by 许明洋 on 2020/11/25.
//

#import "TcpViewController.h"
#import "Masonry.h"
#import "GCDAsyncSocket.h" //for tcp

@interface TcpViewController ()<UITextFieldDelegate,GCDAsyncSocketDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) NSMutableArray *textArr;

@end

@implementation TcpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"socket通信中tcp测试客户端";
    
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
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    //电脑上的网络名称和手机上的网络ip地址必须一致才行，不然的话协议方法一直无法执行
    if (![self.clientSocket connectToHost:@"192.168.31.61" onPort:5556 error:&error]) {
        NSLog(@"连接失败，失败的原因是%@",error);
    }
}

- (void)sendMessage {
    NSLog(@"点击了该方法");
    if (!self.textField.text || [self.textField.text length] == 0) {
        NSLog(@"发送的信息不能为空");
        return;
    }
    NSData *data = [self.textField.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket writeData:data withTimeout:-1 tag:self.textArr.count];
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
    if (!textField.text || [textField.text length] == 0) {
        return YES;
    }
    [self.textArr addObject:self.textField.text];
    return YES;
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"连接成功，连接的ip地址为%@",host);
//    NSData *data = [self.textField.text dataUsingEncoding:NSUTF8StringEncoding];
//    [sock writeData:data withTimeout:-1 tag:self.textArr.count];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"断开了连接，错误的原因是%@",err);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"调用了这个方法");
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"当前发送的是第%ld个请求",tag);
}

@end

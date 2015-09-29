//
//  BYIMViewController.m
//  IBY
//
//  Created by forbertl on 15/9/28.
//  Copyright © 2015年 com.biyao. All rights reserved.
//

#import "BYIMViewController.h"
#import <EaseMobSDK/EaseMob.h>
#import <TPKeyboardAvoidingScrollView.h>

@interface BYIMViewController ()<UITableViewDataSource,UITableViewDelegate,IEMChatProgressDelegate>
@property (nonatomic)UIScrollView * bodyView;
@property (nonatomic)UITableView * textTable;
@property (nonatomic)UITextField * inputTextField;
@property (nonatomic)UIView * inputArea;
@property (nonatomic, copy)NSString * targetUser;
@property (nonatomic, copy)NSMutableArray * talkInfo;
@property (nonatomic)BOOL keyboardWasShown;
@end

@implementation BYIMViewController


- (void)loadView
{
    UIScrollView* scroll = [[UIScrollView alloc] init ];//WithFrame:[UIScreen mainScreen].bounds];
    scroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scroll.directionalLockEnabled = YES;
    scroll.scrollEnabled = NO;
    self.view = scroll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户支持";
    
//    EMError *error = nil;
//    for (int i = 0; i<10; i++) {
//        NSString * username = [NSString stringWithFormat:@"iOS%d",i];
//        NSString * psw = [NSString stringWithFormat:@"%d%d%d%d%d%d",i,i,i,i,i,i];
//        [[EaseMob sharedInstance].chatManager registerNewAccount:username password:psw error:&error];
//        if (!error) {
//            NSLog(@"注册成功 %@",username);
//        }else{
//            NSLog(@"error :%@",error);
//        }
//    }
    
    self.view.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    self.autoHideKeyboard = YES;
    
    _bodyView = (UIScrollView*)self.view;
    __weak UIScrollView* blockbody = _bodyView;
    //    self.pwdTextField.bk_shouldReturnBlock = ^(UITextField* textField) {
    //        [bself onLogin];
    //        return YES;
    //    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];

    
    self.inputTextField.bk_shouldBeginEditingBlock = ^(UITextField* textField) {
        [blockbody TPKeyboardAvoiding_scrollToActiveTextField];
        return YES;
    };
    
    self.inputTextField.bk_shouldBeginEditingBlock = ^(UITextField* textField) {
        [blockbody TPKeyboardAvoiding_scrollToActiveTextField];
        return YES;
    };
    [self setupUI];
    [self updateUI];
    
    // Do any additional setup after loading the view.
}

- (void)setupUI
{
    _inputArea = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 20 - 44 - 80, SCREEN_WIDTH, 80)];
    [self.view addSubview:_inputArea];
    _inputArea.backgroundColor = [UIColor grayColor];
    _inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(30, 10,SCREEN_WIDTH - 120,60)];
    _inputTextField.backgroundColor = BYColorWhite;
    [_inputArea addSubview:_inputTextField];
    
    UIButton * send = [UIButton buttonWithType:UIButtonTypeCustom];
    send.frame = CGRectMake(_inputTextField.right + 10, 10, 60, 60);
    [_inputArea addSubview:send];
    send.backgroundColor = BYColor333;
    send.titleLabel.text = @"send";
    
    [send addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    
    _textTable = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20 , SCREEN_HEIGHT - 44 - 20 - 10 - 80)];
    _textTable.delegate = self;
    _textTable.dataSource = self;
    _textTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_textTable];
    self.view.backgroundColor = BYColorBG;
    
    _talkInfo = [NSMutableArray array];
}

- (void)updateUI
{
    __weak typeof (self) wself = self;
    _targetUser = @"iOS0";
    self.title = _targetUser;
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:@"iOS1" password:@"111111" completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error && loginInfo) {
            NSLog(@"登陆成功");
            NSLog(@"%@",loginInfo);
            [wself loadConversation];
        }
    } onQueue:nil];
    [self loadConversation];
    
    
   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateUI];
}


#pragma mark IM

- (void)loadConversation
{
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:_targetUser conversationType:eConversationTypeChat];
    _talkInfo = [[conversation loadAllMessages] mutableCopy];
    [_textTable reloadData];
    if (_talkInfo.count) {
        NSIndexPath * index = [NSIndexPath indexPathForRow:_talkInfo.count - 1 inSection:0];
        [_textTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
    
}

- (void)sendMessage
{
    [self.view endEditing:YES];
    
    NSString * text = [NSString stringWithString:_inputTextField.text];
    EMChatText *txtChat = [[EMChatText alloc] initWithText:text];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:txtChat];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:_targetUser bodies:@[body]];
    message.messageType = eMessageTypeChat;
    
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:self prepare:nil onQueue:nil completion:^(EMMessage * message, EMError *error){
        if (error) {
            NSLog(@"发送失败%@",error);
        }else{
            NSLog(@"发送成功%@",message);
        }
    } onQueue:nil];
    _inputTextField.text = @"";
    [_talkInfo addObject:message];
    [_textTable reloadData];
    NSIndexPath * index = [NSIndexPath indexPathForRow:_talkInfo.count - 1 inSection:0];
    [_textTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionNone animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"BYIMTalkCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    EMMessage * message = _talkInfo[indexPath.row];
    EMTextMessageBody * body = message.messageBodies[0];
    NSString * name = message.from;
    NSString * text = body.text;
    cell.textLabel.text = body.text;
    if ([_targetUser isEqualToString:message.from]) {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }else{
        cell.textLabel.textAlignment = NSTextAlignmentRight;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _talkInfo.count;
}

- (void)setProgress:(float)progress
         forMessage:(EMMessage *)message
     forMessageBody:(id<IEMMessageBody>)messageBody
{
    NSLog(@"%f,%@",progress,message.messageBodies);
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
//    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    [self.bodyView setContentOffset:CGPointMake(0, keyboardSize.height) animated:YES];
    _keyboardWasShown = YES;
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
//    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    [self.bodyView setContentOffset:CGPointMake(0,0) animated:YES];
     _keyboardWasShown = NO;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

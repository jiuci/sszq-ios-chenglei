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
#import "ConvertToCommonEmoticonsHelper.h"

@interface BYIMViewController ()<UITableViewDataSource,UITableViewDelegate,IEMChatProgressDelegate,EMChatManagerChatDelegate,EMChatManagerDelegate,EMCallManagerDelegate>
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
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
//    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
    
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
    _targetUser = @"user_16697";
    self.title = _targetUser;
    if (![EaseMob sharedInstance].chatManager.isLoggedIn) {
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:@"iOS1" password:@"111111" completion:^(NSDictionary *loginInfo, EMError *error) {
            if (!error && loginInfo) {
                NSLog(@"登陆成功");
                NSLog(@"%@",loginInfo);
                [wself loadConversation];
            }
        } onQueue:nil];
    }
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
    NSMutableString * inputtext = [_inputTextField.text mutableCopy];
    if ([inputtext hasPrefix:@"change"]) {
        [inputtext replaceCharactersInRange:NSMakeRange(0, 6) withString:@""];
        _targetUser = inputtext;
        _inputTextField.text = @"";
        [self loadConversation];
        return;
    }
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

-(void)didReceiveMessage:(EMMessage *)message
{
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            // 收到的文字消息
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            
            NSLog(@"收到的文字是 txt -- %@",txt);
        }
            break;
        case eMessageBodyType_Image:
        {
            // 得到一个图片消息body
            EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
            NSLog(@"大图remote路径 -- %@"   ,body.remotePath);
            NSLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用sdk提供的下载方法后才会存在
            NSLog(@"大图的secret -- %@"    ,body.secretKey);
            NSLog(@"大图的W -- %f ,大图的H -- %f",body.size.width,body.size.height);
            NSLog(@"大图的下载状态 -- %lu",(unsigned long)body.attachmentDownloadStatus);
            
            
            // 缩略图sdk会自动下载
            NSLog(@"小图remote路径 -- %@"   ,body.thumbnailRemotePath);
            NSLog(@"小图local路径 -- %@"    ,body.thumbnailLocalPath);
            NSLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);
            NSLog(@"小图的W -- %f ,大图的H -- %f",body.thumbnailSize.width,body.thumbnailSize.height);
            NSLog(@"小图的下载状态 -- %lu",(unsigned long)body.thumbnailDownloadStatus);
        }
            break;
        case eMessageBodyType_Location:
        {
            EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
            NSLog(@"纬度-- %f",body.latitude);
            NSLog(@"经度-- %f",body.longitude);
            NSLog(@"地址-- %@",body.address);
        }
            break;
        case eMessageBodyType_Voice:
        {
            // 音频sdk会自动下载
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
            NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
            NSLog(@"音频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在（音频会自动调用）
            NSLog(@"音频的secret -- %@"        ,body.secretKey);
            NSLog(@"音频文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"音频文件的下载状态 -- %lu"   ,(unsigned long)body.attachmentDownloadStatus);
            NSLog(@"音频的时间长度 -- %lu"      ,(long)body.duration);
        }
            break;
        case eMessageBodyType_Video:
        {
            EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
            
            NSLog(@"视频remote路径 -- %@"      ,body.remotePath);
            NSLog(@"视频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
            NSLog(@"视频的secret -- %@"        ,body.secretKey);
            NSLog(@"视频文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"视频文件的下载状态 -- %lu"   ,(unsigned long)body.attachmentDownloadStatus);
            NSLog(@"视频的时间长度 -- %lu"      ,(long)body.duration);
            NSLog(@"视频的W -- %f ,视频的H -- %f", body.size.width, body.size.height);
            
            // 缩略图sdk会自动下载
            NSLog(@"缩略图的remote路径 -- %@"     ,body.thumbnailRemotePath);
            NSLog(@"缩略图的local路径 -- %@"      ,body.thumbnailRemotePath);
            NSLog(@"缩略图的secret -- %@"        ,body.thumbnailSecretKey);
            NSLog(@"缩略图的下载状态 -- %lu"      ,(unsigned long)body.thumbnailDownloadStatus);
        }
            break;
        case eMessageBodyType_File:
        {
            EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
            NSLog(@"文件remote路径 -- %@"      ,body.remotePath);
            NSLog(@"文件local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
            NSLog(@"文件的secret -- %@"        ,body.secretKey);
            NSLog(@"文件文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"文件文件的下载状态 -- %lu"   ,(unsigned long)body.attachmentDownloadStatus);
        }
            break;
            
        default:
            break;
    }
    [self loadConversation];
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
    NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                convertToSystemEmoticons:body.text];
    cell.textLabel.text = didReceiveText;
    if ([_targetUser isEqualToString:message.from]) {
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }else{
        cell.textLabel.textColor = [UIColor greenColor];
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

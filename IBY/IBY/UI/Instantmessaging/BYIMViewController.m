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
#import "EMChatViewCell.h"
#import "EMChatTimeCell.h"
#import "MessageModelManager.h"
#import "NSDate+Category.h"
#import "MessageReadManager.h"

@interface BYIMViewController ()<UITableViewDataSource,UITableViewDelegate,IEMChatProgressDelegate,EMChatManagerChatDelegate,EMChatManagerDelegate,EMCallManagerDelegate>
@property (nonatomic)UIScrollView * bodyView;
@property (nonatomic)UITableView * textTable;
@property (nonatomic)UITextField * inputTextField;
@property (nonatomic)UIView * inputArea;
@property (nonatomic, copy)NSString * targetUser;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic)BOOL keyboardWasShown;
@property (nonatomic)NSDate * chatTagDate;
@property (nonatomic) NSMutableArray *messages;
@property (nonatomic) BOOL needScrollToEnd;
@property (strong, nonatomic) MessageReadManager *messageReadManager;
@property (strong, nonatomic) EMConversation *conversation;

@property (nonatomic) dispatch_queue_t messageQueue;

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

    _messageQueue = dispatch_queue_create("easemob.com", NULL);
    
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

- (MessageReadManager *)messageReadManager
{
    if (_messageReadManager == nil) {
        _messageReadManager = [MessageReadManager defaultManager];
    }
    
    return _messageReadManager;
}

- (void)setupUI
{
    float inputAreaHeight = 44;
    _inputArea = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 20 - 44 - inputAreaHeight, SCREEN_WIDTH, inputAreaHeight)];
    [self.view addSubview:_inputArea];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [_inputArea addSubview:line];
    line.backgroundColor = [UIColor grayColor];
    
    UIImageView * inputBg = [[UIImageView alloc]initWithFrame:CGRectMake(41, (inputAreaHeight - 32) / 2, SCREEN_WIDTH - 41 -10, 32)];
    [_inputArea addSubview:inputBg];
    inputBg.image = [[UIImage imageNamed:@"bg_im_input"] resizableImage];
    
    
    _inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(41 + 5, (inputAreaHeight - 32) / 2, inputBg.width - 10 ,32)];
//    _inputTextField.backgroundColor = BYColorWhite;
    _inputTextField.font = Font(14);
    _inputTextField.placeholder = @"输入聊天内容";
    [_inputArea addSubview:_inputTextField];
    _inputTextField.returnKeyType = UIReturnKeySend;
    _inputTextField.enablesReturnKeyAutomatically = YES;
    __weak typeof (self) wself = self;
    [_inputTextField setBk_shouldReturnBlock:^BOOL(UITextField * textfield){
        [wself sendMessage];
        return YES;
    }];
    
    UIButton * picture = [UIButton buttonWithType:UIButtonTypeCustom];
    picture.frame = CGRectMake(12 , (inputAreaHeight - 18)/2, 18, 18);
    [_inputArea addSubview:picture];
//    picture.backgroundColor = [UIColor blackColor];
//    [picture setBackgroundImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>]
    [picture setBackgroundImage:[UIImage imageNamed:@"btn_im_addpic"] forState:UIControlStateNormal];
    [picture addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton * emoji = [UIButton buttonWithType:UIButtonTypeCustom];
//    emoji.frame = CGRectMake(_inputTextField.right + 10, 10, 60, 60);
//    [_inputArea addSubview:emoji];
//    emoji.backgroundColor = BYColor333;
//    emoji.titleLabel.text = @"emoji";
//    
//    [emoji addTarget:self action:@selector(sendEmoji) forControlEvents:UIControlEventTouchUpInside];
    
    _textTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH  , SCREEN_HEIGHT - 44 - 20 - inputAreaHeight)];
    _textTable.delegate = self;
    _textTable.dataSource = self;
    _textTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_textTable];
    self.view.backgroundColor = BYColorBG;
    
    _dataSource = [NSMutableArray array];
    _messages = [NSMutableArray array];

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
    _conversation = conversation;
    _messages = [[conversation loadAllMessages] mutableCopy];
    [self reloadData];
    if (_messages.count&&_needScrollToEnd) {
        NSIndexPath * index = [NSIndexPath indexPathForRow:_dataSource.count - 1 inSection:0];
        [_textTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
    if (!_needScrollToEnd) {
        _needScrollToEnd = YES;
    }
}

- (void)sendEmoji
{
    
}

- (void)addPicture
{
    NSLog(@"addPicture");
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
    [_messages addObject:message];
    [self reloadData];
    NSIndexPath * index = [NSIndexPath indexPathForRow:_dataSource.count - 1 inSection:0];
    [_textTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

-(void)didReceiveMessage:(EMMessage *)message
{
    if ([_conversation.chatter isEqualToString:message.conversationChatter]) {
        [self addMessage:message];
        if ([self shouldAckMessage:message read:NO])
        {
            [self sendHasReadResponseForMessages:@[message]];
        }
        if ([self shouldMarkMessageAsRead])
        {
            [self markMessagesAsRead:@[message]];
        }
    }
}
-(void)addMessage:(EMMessage *)message
{
    [_messages addObject:message];
    __weak typeof (self) weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf formatMessage:message];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.dataSource addObjectsFromArray:messages];
            [weakSelf.textTable reloadData];
            [weakSelf.textTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    });
}
- (void)markMessagesAsRead:(NSArray*)messages
{
    EMConversation *conversation = _conversation;
    dispatch_async(_messageQueue, ^{
        for (EMMessage *message in messages)
        {
            [conversation markMessageWithId:message.messageId asRead:YES];
        }
    });
}

-(NSMutableArray *)formatMessage:(EMMessage *)message
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
    NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
    if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
        [ret addObject:[createDate formattedTime]];
        self.chatTagDate = createDate;
    }
    
    MessageModel *model = [MessageModelManager modelWithMessage:message];
        model.nickName = model.username;
    
      if (model) {
        [ret addObject:model];
    }
    
    return ret;
}
//-(void)didReceiveMessage:(EMMessage *)message
//{
//    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
//    switch (msgBody.messageBodyType) {
//        case eMessageBodyType_Text:
//        {
//            // 收到的文字消息
//            NSString *txt = ((EMTextMessageBody *)msgBody).text;
//            
//            NSLog(@"收到的文字是 txt -- %@",txt);
//        }
//            break;
//        case eMessageBodyType_Image:
//        {
//            // 得到一个图片消息body
//            EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
//            NSLog(@"大图remote路径 -- %@"   ,body.remotePath);
//            NSLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用sdk提供的下载方法后才会存在
//            NSLog(@"大图的secret -- %@"    ,body.secretKey);
//            NSLog(@"大图的W -- %f ,大图的H -- %f",body.size.width,body.size.height);
//            NSLog(@"大图的下载状态 -- %lu",(unsigned long)body.attachmentDownloadStatus);
//            
//            
//            // 缩略图sdk会自动下载
//            NSLog(@"小图remote路径 -- %@"   ,body.thumbnailRemotePath);
//            NSLog(@"小图local路径 -- %@"    ,body.thumbnailLocalPath);
//            NSLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);
//            NSLog(@"小图的W -- %f ,大图的H -- %f",body.thumbnailSize.width,body.thumbnailSize.height);
//            NSLog(@"小图的下载状态 -- %lu",(unsigned long)body.thumbnailDownloadStatus);
//        }
//            break;
//        case eMessageBodyType_Location:
//        {
//            EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
//            NSLog(@"纬度-- %f",body.latitude);
//            NSLog(@"经度-- %f",body.longitude);
//            NSLog(@"地址-- %@",body.address);
//        }
//            break;
//        case eMessageBodyType_Voice:
//        {
//            // 音频sdk会自动下载
//            EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
//            NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
//            NSLog(@"音频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在（音频会自动调用）
//            NSLog(@"音频的secret -- %@"        ,body.secretKey);
//            NSLog(@"音频文件大小 -- %lld"       ,body.fileLength);
//            NSLog(@"音频文件的下载状态 -- %lu"   ,(unsigned long)body.attachmentDownloadStatus);
//            NSLog(@"音频的时间长度 -- %lu"      ,(long)body.duration);
//        }
//            break;
//        case eMessageBodyType_Video:
//        {
//            EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
//            
//            NSLog(@"视频remote路径 -- %@"      ,body.remotePath);
//            NSLog(@"视频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
//            NSLog(@"视频的secret -- %@"        ,body.secretKey);
//            NSLog(@"视频文件大小 -- %lld"       ,body.fileLength);
//            NSLog(@"视频文件的下载状态 -- %lu"   ,(unsigned long)body.attachmentDownloadStatus);
//            NSLog(@"视频的时间长度 -- %lu"      ,(long)body.duration);
//            NSLog(@"视频的W -- %f ,视频的H -- %f", body.size.width, body.size.height);
//            
//            // 缩略图sdk会自动下载
//            NSLog(@"缩略图的remote路径 -- %@"     ,body.thumbnailRemotePath);
//            NSLog(@"缩略图的local路径 -- %@"      ,body.thumbnailRemotePath);
//            NSLog(@"缩略图的secret -- %@"        ,body.thumbnailSecretKey);
//            NSLog(@"缩略图的下载状态 -- %lu"      ,(unsigned long)body.thumbnailDownloadStatus);
//        }
//            break;
//        case eMessageBodyType_File:
//        {
//            EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
//            NSLog(@"文件remote路径 -- %@"      ,body.remotePath);
//            NSLog(@"文件local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
//            NSLog(@"文件的secret -- %@"        ,body.secretKey);
//            NSLog(@"文件文件大小 -- %lld"       ,body.fileLength);
//            NSLog(@"文件文件的下载状态 -- %lu"   ,(unsigned long)body.attachmentDownloadStatus);
//        }
//            break;
//            
//        default:
//            break;
//    }
//    [self loadConversation];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
        id obj = [self.dataSource objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[NSString class]]) {
            EMChatTimeCell *timeCell = (EMChatTimeCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageCellTime"];
            if (timeCell == nil) {
                timeCell = [[EMChatTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCellTime"];
                timeCell.backgroundColor = [UIColor clearColor];
                timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            timeCell.textLabel.text = (NSString *)obj;
            
            return timeCell;
        }
        else{
            MessageModel *model = (MessageModel *)obj;
            NSString *cellIdentifier = [EMChatViewCell cellIdentifierForMessageModel:model];
            EMChatViewCell *cell = (EMChatViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[EMChatViewCell alloc] initWithMessageModel:model reuseIdentifier:cellIdentifier];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.messageModel = model;
            
            return cell;
        }
    }
    
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = [self.dataSource objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        return 40;
    }
    else{
        return [EMChatViewCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(MessageModel *)obj];
    }
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (NSArray *)formatMessages:(NSArray *)messagesArray
{
    NSMutableArray *formatArray = [[NSMutableArray alloc] init];
    if ([messagesArray count] > 0) {
        for (EMMessage *message in messagesArray) {
            NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
            if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
                [formatArray addObject:[createDate formattedTime]];
                self.chatTagDate = createDate;
            }
            
            MessageModel *model = [MessageModelManager modelWithMessage:message];
            model.nickName = model.username;
            NSString * avatar = [BYAppCenter sharedAppCenter].user.avatar;
            if ([[avatar class] isSubclassOfClass:[NSString class]]&&avatar.length > 0) {
                model.headImageURL = [NSURL URLWithString:[BYAppCenter sharedAppCenter].user.avatar];
            }else{
                
            }
            
            if (model) {
                [formatArray addObject:model];
            }
        }
    }
    
    return formatArray;
}
- (void)reloadData{
    _chatTagDate = nil;
    self.dataSource = [[self formatMessages:self.messages] mutableCopy];
    [self.textTable reloadData];
    
    //回到前台时
//    if (!self.isInvisible)
//    {
//        NSMutableArray *unreadMessages = [NSMutableArray array];
//        for (EMMessage *message in self.messages)
//        {
//            if ([self shouldAckMessage:message read:NO])
//            {
//                [unreadMessages addObject:message];
//            }
//        }
//        if ([unreadMessages count])
//        {
//            [self sendHasReadResponseForMessages:unreadMessages];
//        }
//        
//        [_conversation markAllMessagesAsRead:YES];
//    }
}
- (NSDate *)chatTagDate
{
    if (_chatTagDate == nil) {
        _chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:0];
    }
    
    return _chatTagDate;
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

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    MessageModel *model = [userInfo objectForKey:KMESSAGEKEY];
//    if ([eventName isEqualToString:kRouterEventTextURLTapEventName]) {
//        [self chatTextCellUrlPressed:[userInfo objectForKey:@"url"]];
//    }
//    else if ([eventName isEqualToString:kRouterEventAudioBubbleTapEventName]) {
//        [self chatAudioCellBubblePressed:model];
//    }
//    else
    if ([eventName isEqualToString:kRouterEventImageBubbleTapEventName]){
        [self chatImageCellBubblePressed:model];
    }
//    else if ([eventName isEqualToString:kRouterEventLocationBubbleTapEventName]){
//        [self chatLocationCellBubblePressed:model];
//    }
    else if([eventName isEqualToString:kResendButtonTapEventName]){
        EMChatViewCell *resendCell = [userInfo objectForKey:kShouldResendCell];
        MessageModel *messageModel = resendCell.messageModel;
        if ((messageModel.status != eMessageDeliveryState_Failure) && (messageModel.status != eMessageDeliveryState_Pending))
        {
            return;
        }
        id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
        [chatManager asyncResendMessage:messageModel.message progress:nil];
        NSIndexPath *indexPath = [self.textTable indexPathForCell:resendCell];
        [self.textTable beginUpdates];
        [self.textTable reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.textTable endUpdates];
    }
//        else if([eventName isEqualToString:kRouterEventChatCellVideoTapEventName]){
//        [self chatVideoCellPressed:model];
//    }else if ([eventName isEqualToString:kRouterEventMenuTapEventName]) {
//        [self sendTextMessage:[userInfo objectForKey:@"text"]];
//    }
}

// 图片的bubble被点击
-(void)chatImageCellBubblePressed:(MessageModel *)model
{
    __weak typeof (self) weakSelf = self;
    id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
    if ([model.messageBody messageBodyType] == eMessageBodyType_Image) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)model.messageBody;
        if (imageBody.thumbnailDownloadStatus == EMAttachmentDownloadSuccessed) {
            if (imageBody.attachmentDownloadStatus == EMAttachmentDownloadSuccessed)
            {
                //发送已读回执
                if ([self shouldAckMessage:model.message read:YES])
                {
                    [self sendHasReadResponseForMessages:@[model.message]];
                }
                NSString *localPath = model.message == nil ? model.localPath : [[model.message.messageBodies firstObject] localPath];
                if (localPath && localPath.length > 0) {
                    UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                    self.needScrollToEnd = NO;
                    if (image)
                    {
                        [self.messageReadManager showBrowserWithImages:@[image]];
                    }
                    else
                    {
                        NSLog(@"Read %@ failed!", localPath);
                    }
                    return ;
                }
            }
            [MBProgressHUD topShow:@"加载中..."];
            [chatManager asyncFetchMessage:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                [MBProgressHUD topHide];
                if (!error) {
                    //发送已读回执
                    if ([weakSelf shouldAckMessage:model.message read:YES])
                    {
                        [weakSelf sendHasReadResponseForMessages:@[model.message]];
                    }
                    NSString *localPath = aMessage == nil ? model.localPath : [[aMessage.messageBodies firstObject] localPath];
                    if (localPath && localPath.length > 0) {
                        UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                        weakSelf.needScrollToEnd = NO;
                        if (image)
                        {
                            [weakSelf.messageReadManager showBrowserWithImages:@[image]];
                        }
                        else
                        {
                            NSLog(@"Read %@ failed!", localPath);
                        }
                        return ;
                    }
                }
                [MBProgressHUD topShowTmpMessage:@"加载失败"];
            } onQueue:nil];
        }else{
            //获取缩略图
            [chatManager asyncFetchMessageThumbnail:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                if (!error) {
                    [weakSelf reloadTableViewDataWithMessage:model.message];
                }else{
                    [MBProgressHUD topShowTmpMessage:@"加载失败"];
                }
                
            } onQueue:nil];
        }
    }else if ([model.messageBody messageBodyType] == eMessageBodyType_Video) {
        //获取缩略图
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)model.messageBody;
        if (videoBody.thumbnailDownloadStatus != EMAttachmentDownloadSuccessed) {
            [chatManager asyncFetchMessageThumbnail:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                if (!error) {
                    [weakSelf reloadTableViewDataWithMessage:model.message];
                }else{
                    [MBProgressHUD topShowTmpMessage:@"加载失败"];
                }
            } onQueue:nil];
        }
    }
}

- (BOOL)shouldAckMessage:(EMMessage *)message read:(BOOL)read
{
    NSString *account = [[EaseMob sharedInstance].chatManager loginInfo][kSDKUsername];
    if (message.messageType != eMessageTypeChat || message.isReadAcked || [account isEqualToString:message.from] || ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground))// || self.isInvisible)
    {
        return NO;
    }
    
    id<IEMMessageBody> body = [message.messageBodies firstObject];
    if (((body.messageBodyType == eMessageBodyType_Video) ||
         (body.messageBodyType == eMessageBodyType_Voice) ||
         (body.messageBodyType == eMessageBodyType_Image)) &&
        !read)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)shouldMarkMessageAsRead
{
    if (([UIApplication sharedApplication].applicationState == UIApplicationStateBackground))// || self.isInvisible)
    {
        return NO;
    }
    
    return YES;
}

- (void)sendHasReadResponseForMessages:(NSArray*)messages
{
    dispatch_async(_messageQueue, ^{
        for (EMMessage *message in messages)
        {
            [[EaseMob sharedInstance].chatManager sendReadAckForMessage:message];
        }
    });
}

- (void)reloadTableViewDataWithMessage:(EMMessage *)message{
    __weak typeof (self) weakSelf = self;
    dispatch_async(_messageQueue, ^{
        if ([weakSelf.conversation.chatter isEqualToString:message.conversationChatter])
        {
            for (int i = 0; i < weakSelf.dataSource.count; i ++) {
                id object = [weakSelf.dataSource objectAtIndex:i];
                if ([object isKindOfClass:[MessageModel class]]) {
                    MessageModel *model = (MessageModel *)object;
                    if ([message.messageId isEqualToString:model.messageId]) {
                        MessageModel *cellModel = [MessageModelManager modelWithMessage:message];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.textTable beginUpdates];
                            [weakSelf.dataSource replaceObjectAtIndex:i withObject:cellModel];
                            [weakSelf.textTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                            [weakSelf.textTable endUpdates];
                        });
                        break;
                    }
                }
            }
        }
    });
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

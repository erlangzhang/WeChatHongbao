

@protocol WCRedEnvelopesNetworkHelperDelegate <NSObject>
-(void)OnWCToAsyncBizSubscribeResponse:(id)asyncBizSubscribeResponse Request:(id)request;
-(void)OnWCToBizHBCommonErrorResponse:(id)bizHBCommonErrorResponse Request:(id)request;
-(void)OnWCToBizHBCommonSystemErrorResponse:(id)bizHBCommonSystemErrorResponse Request:(id)request;
-(void)OnWCToBizHBCommonResponse:(id)bizHBCommonResponse Request:(id)request;
-(void)OnWCToEnterpriseHBCommonErrorResponse:(id)enterpriseHBCommonErrorResponse Request:(id)request;
-(void)OnWCToEnterpriseHBCommonSystemErrorResponse:(id)enterpriseHBCommonSystemErrorResponse Request:(id)request;
-(void)OnWCToEnterpriseHBCommonResponse:(id)enterpriseHBCommonResponse Request:(id)request;
-(void)OnWCToHongbaoCommonErrorResponse:(id)hongbaoCommonErrorResponse Request:(id)request;
-(void)OnWCToHongbaoCommonSystemErrorResponse:(id)hongbaoCommonSystemErrorResponse Request:(id)request;
-(void)OnWCToHongbaoCommonResponse:(id)hongbaoCommonResponse Request:(id)request;
@end





//网络请求类

@interface WCRedEnvelopesNetworkHelper : NSObject {
}

@property(weak, nonatomic) id<WCRedEnvelopesNetworkHelperDelegate> m_delegate;

-(void)WCToHongbaoCommonRequest:(id)hongbaoCommonRequest;

-(void)WCToEnterpriseCommonBizReq:(id)enterpriseCommonBizReq;

@end

@interface WCPayInfoItem: NSObject

@property(readonly, copy) NSString* debugDescription;
@property(readonly, copy) NSString* description;
@property(readonly, assign) Class superclass;
@property(readonly, assign) unsigned hash;
@property(retain, nonatomic) NSString* m_payMemo;
@property(retain, nonatomic) NSString* m_nsPayMsgID;
@property(assign, nonatomic) unsigned long m_c2c_msg_subtype;
@property(retain, nonatomic) NSString* m_fee_type;
@property(retain, nonatomic) NSString* m_total_fee;
@property(retain, nonatomic) NSString* m_senderDesc;
@property(retain, nonatomic) NSString* m_receiverDesc;
@property(retain, nonatomic) NSString* m_sceneText;
@property(retain, nonatomic) NSString* m_hintText;
@property(retain, nonatomic) NSString* m_senderTitle;
@property(retain, nonatomic) NSString* m_receiverTitle;
@property(retain, nonatomic) NSString* m_c2cIconUrl;
@property(retain, nonatomic) NSString* m_c2cNativeUrl;
@property(retain, nonatomic) NSString* m_c2cUrl;
@property(assign, nonatomic) unsigned long m_templateID;
@property(assign, nonatomic) unsigned long m_uiEffectiveDate;
@property(retain, nonatomic) NSString* m_nsTransferID;
@property(assign, nonatomic) unsigned long m_uiBeginTransferTime;
@property(assign, nonatomic) unsigned long m_uiInvalidTime;
@property(retain, nonatomic) NSString* m_nsTranscationID;
@property(retain, nonatomic) NSString* m_nsFeeDesc;
@property(assign, nonatomic) unsigned long m_uiPaySubType;
-(id)toXML;
@end

@interface CMessageWrap : NSObject // 微信消息
@property (retain, nonatomic) WCPayInfoItem *m_oWCPayInfoItem;
@property (assign, nonatomic) NSUInteger m_uiMesLocalID;
@property (retain, nonatomic) NSString* m_nsFromUsr; // 发信人，可能是群或个人
@property (retain, nonatomic) NSString* m_nsToUsr; // 收信人
@property (assign, nonatomic) NSUInteger m_uiStatus;
@property (retain, nonatomic) NSString* m_nsContent; // 消息内容
@property (retain, nonatomic) NSString* m_nsRealChatUsr; // 群消息的发信人，具体是群里的哪个人
@property (nonatomic) NSUInteger m_uiMessageType;
@property (nonatomic) long long m_n64MesSvrID;
@property (nonatomic) NSUInteger m_uiCreateTime;
@property (retain, nonatomic) NSString *m_nsDesc;
@property (retain, nonatomic) NSString *m_nsAppExtInfo;
@property (nonatomic) NSUInteger m_uiAppDataSize;
@property (nonatomic) NSUInteger m_uiAppMsgInnerType;
@property (retain, nonatomic) NSString *m_nsShareOpenUrl;
@property (retain, nonatomic) NSString *m_nsShareOriginUrl;
@property (retain, nonatomic) NSString *m_nsJsAppId;
@property (retain, nonatomic) NSString *m_nsPrePublishId;
@property (retain, nonatomic) NSString *m_nsAppID;
@property (retain, nonatomic) NSString *m_nsAppName;
@property (retain, nonatomic) NSString *m_nsThumbUrl;
@property (retain, nonatomic) NSString *m_nsAppMediaUrl;
@property (retain, nonatomic) NSData *m_dtThumbnail;
@property (retain, nonatomic) NSString *m_nsTitle;
@property (retain, nonatomic) NSString *m_nsMsgSource;
- (instancetype)initWithMsgType:(int)msgType;
+ (UIImage *)getMsgImg:(CMessageWrap *)arg1;
+ (NSData *)getMsgImgData:(CMessageWrap *)arg1;
+ (NSString *)getPathOfMsgImg:(CMessageWrap *)arg1;
- (UIImage *)GetImg;
- (BOOL)IsImgMsg;
- (BOOL)IsAtMe;
+ (void)GetPathOfAppThumb:(NSString *)senderID LocalID:(NSUInteger)mesLocalID retStrPath:(NSString **)pathBuffer;
@end

@interface WCRedEnvelopesControlData : NSObject
@property(retain, nonatomic) CMessageWrap *m_oSelectedMessageWrap; 
@end

@interface MMServiceCenter : NSObject
+ (instancetype)defaultCenter;
- (id)getService:(Class)service;
@end

// @interface WCRedEnvelopesControlMgr : NSObject
// - (unsigned int)startLogic:(id)arg1;
// @end

// @interface WCRedEnvelopesReceiveControlLogic : NSObject

// - (id)initWithData:(id)arg1;

// - (void)startLogic;

// - (void)WCRedEnvelopesReceiveHomeViewOpenRedEnvelopes;

// @end

@interface WCRedEnvelopesLogicMgr: NSObject{
    WCRedEnvelopesNetworkHelper* m_networkHelper;
}
//@property(readonly, retain) WCRedEnvelopesNetworkHelper* m_networkHelper;
-(void)AsyncBizSubcribeRequest:(id)request;
-(void)CheckAuthBizEnterpriseRedEnvelopesRequest:(id)request;
-(void)OpenBizEnterpriseRedEnvelopesRequest:(id)request;
-(void)ReceiveBizEnterpriseRedEnvelopesRequest:(id)request;
-(void)NotifyNoShareEnterpriseRedEnvelopesRequest:(id)request;
-(void)OpenAtomicEnterpriseRedEnvelopesRequest:(id)request;
-(void)ReceiveAtomicEnterpriseRedEnvelopesRequest:(id)request;
-(void)SendShareEnterpriseRedEnvelopesoRequest:(id)request;
-(void)OpenEnterpriseRedEnvelopesRequest:(id)request SendKey:(id)key;
-(void)ThanksForRedEnvelopesRequest:(id)redEnvelopesRequest;
-(void)ClearserSendOrReceiveRedEnveloperListRequest:(id)request;


- (void)OpenRedEnvelopesRequest:(id)params;
-(void)ReceiverQueryRedEnvelopesRequest:(id)request;
-(void)QueryRedEnvelopesDetailRequest:(id)request;

-(void)ClearserSendOrReceiveRedEnveloperListRequest:(id)request;  // crash
-(void)DeleteRedEnvelopesRecord:(id)record;                         // ...
-(void)GetHongbaoBusinessRequest:(id)request CMDID:(unsigned long)cmdid OutputType:(unsigned long)type;

-(void)ReceiverQueryRedEnvelopesRequest:(id)request;        // NO
-(void)SendShareRedEnvelopesoRequest:(id)request;           // NO
-(void)GenRedEnvelopesPayRequest:(id)request;               // ?
-(void)QueryRedEnvelopesUserInfoNoCache:(id)cache;          // ?


@end


@interface WCSnsRedEnvelopesLogicMgrV4: NSObject


-(void)ThanksForRedEnvelopesRequest:(id)redEnvelopesRequest;
-(void)ClearserSendOrReceiveRedEnveloperListRequest:(id)request;
-(void)DeleteRedEnvelopesRecord:(id)record;
-(void)QueryUserSendOrReceiveRedEnveloperListRequest:(id)request;
-(void)QueryRedEnvelopesDetailRequest:(id)request;
-(void)OpenRedEnvelopesRequest:(id)request;
-(void)ReceiverQueryRedEnvelopesRequest:(id)request;
-(void)SendShareRedEnvelopesoRequest:(id)request;
-(void)GenRedEnvelopesPayRequest:(id)request;
-(void)QueryRedEnvelopesUserInfoNoCache:(id)cache;
-(void)QueryRedEnvelopesUserInfo:(id)info;


@end

@interface MMMsgLogicManager: NSObject
- (id)GetCurrentLogicController;
@end

@interface CContact: NSObject
@property(retain, nonatomic) NSString *m_nsUsrName;
@property(retain, nonatomic) NSString *m_nsHeadImgUrl;
@property(retain, nonatomic) NSString *m_nsNickName;


- (id)getContactDisplayName;
@end

@interface WCBizUtil : NSObject

+ (id)dictionaryWithDecodedComponets:(id)arg1 separator:(id)arg2;
+(id)getWCRedEnvelopesLastRadomHBSelctedCountPath;
+(id)getWCRedEnvelopesUserInfoPath;
+(id)getWCMallFunctionListPath;
+(id)getWCPayServerDynamicWordingPath;

+(id)stringWithFormEncodedComponentsAscending:(id)formEncodedComponentsAscending ascending:(BOOL)ascending skipempty:(BOOL)skipempty separator:(id)separator;
@end

@interface CContactMgr : NSObject
- (id)getSelfContact;
@end

@interface NSMutableDictionary (SafeInsert)
- (void)safeSetObject:(id)arg1 forKey:(id)arg2;
@end

@interface NSObject (GTMNSStringURLArgumentsAdditions)
-(id)gtm_stringByEncodeByJsonAndUrlEncode;
-(id)gtm_stringByUnescapingFromURLArgument;
-(id)gtm_stringByEscapingForURLArgumentOnly;
-(id)gtm_stringByEscapingForURLArgument;
@end

@interface NSObject (SafeInsert)
-(void)safeRemoveObjectForKey:(id)key;
-(void)safeSetObject:(id)object forKey:(id)key;
@end

@interface NotificationActionsMgr : NSObject { }
-(void)handleReceiveLocalNotification:(id)notification;
-(void)handleStatusNotifyResp:(id)resp;
-(void)handleSendMsgResp:(id)resp;
-(void)handleSetPushMuteResp:(id)resp;
@end

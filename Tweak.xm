#import "WeChatRedEnvelop.h"
#import "HongBaoRes.h"
#import "SKBuiltinBuffer_t.h"
#import "HongBaoReq.h"
#import "ProtobufCGIWrap.h"


%hook CMessageMgr


- (void)AsyncOnAddMsg:(NSString *)msg MsgWrap:(CMessageWrap *)wrap {
	%orig;
	NSLog(@" type: %@ message : %@",msg , wrap);
	switch(wrap.m_uiMessageType) {
	case 49: { // AppNode

		CContactMgr *contactManager = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("CContactMgr") class]];
		CContact *selfContact = [contactManager getSelfContact];

		BOOL isMesasgeFromMe = NO;
		if ([wrap.m_nsFromUsr isEqualToString:selfContact.m_nsUsrName]) {
			isMesasgeFromMe = YES;
		}

		if ([wrap.m_nsContent rangeOfString:@"wxpay://"].location != NSNotFound) { // 红包
			if ([wrap.m_nsFromUsr rangeOfString:@"@chatroom"].location != NSNotFound ||
				(isMesasgeFromMe && [wrap.m_nsToUsr rangeOfString:@"@chatroom"].location != NSNotFound)) { // 群组红包或群组里自己发的红包

				NSString *nativeUrl = [[wrap m_oWCPayInfoItem] m_c2cNativeUrl];
				NSLog(@" receiveHongbao: %@", nativeUrl);
				nativeUrl = [nativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];

				NSDictionary *nativeUrlDict = [%c(WCBizUtil) dictionaryWithDecodedComponets:nativeUrl separator:@"&"];
	
				NSLog(@"  select: %@", [%c(WCBizUtil) getWCRedEnvelopesLastRadomHBSelctedCountPath]); 

				/** 构造参数 */
				NSMutableDictionary *params = [@{} mutableCopy];
				params[@"msgType"] = nativeUrlDict[@"msgtype"] ?: @"1";
				params[@"sendId"] = nativeUrlDict[@"sendid"] ?: @"";
				params[@"channelId"] = nativeUrlDict[@"channelid"] ?: @"1";
				params[@"nickName"] = [selfContact getContactDisplayName] ?: @"小锅";
				params[@"headImg"] = [selfContact m_nsHeadImgUrl] ?: @"";
				params[@"nativeUrl"] = [[wrap m_oWCPayInfoItem] m_c2cNativeUrl] ?: @"";
				params[@"sessionUserName"] = wrap.m_nsFromUsr ?: @"";
			
				NSLog(@"url params : %@",params); 

				WCRedEnvelopesLogicMgr *logicMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("WCRedEnvelopesLogicMgr") class]];
				[logicMgr OpenRedEnvelopesRequest:params];
				// [logicMgr AsyncBizSubcribeRequest:params];
				// [logicMgr ReceiverQueryRedEnvelopesRequest:params];
				// [logicMgr QueryRedEnvelopesDetailRequest:params];
				// [logicMgr GenRedEnvelopesPayRequest:params];


				// WCSnsRedEnvelopesLogicMgrV4  *logicMgr4 = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("WCSnsRedEnvelopesLogicMgrV4") class]];
				//[logicMgr4 GenRedEnvelopesPayRequest:params];


			}
		}	
		break;
	}
	default:
		break;
	}
	
}
%end




%hook WCRedEnvelopesLogicMgr


// Hook openRedEnvelop Event

- (void)OpenRedEnvelopesRequest:(id)params {
	%log;

	%orig;

	//NSLog(@" : %@",params);
}

/*
-(void)GetHongbaoBusinessRequest:(id)request CMDID:(unsigned long)cmdid OutputType:(unsigned long)type {

	%log;

	HongBaoReq * req = [[objc_getClass("HongBaoReq") alloc] init];  //  [%c(HongBaoReq) init];  //[[HongBaoReq alloc] init];	

	SKBuiltinBuffer_t * bufferA = [[objc_getClass("SKBuiltinBuffer_t")  alloc] init];  //[%c(SKBuiltinBuffer) init]; //[[SKBuiltinBuffer_t alloc] init];
	NSLog(@"------------------------------------------");
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	//NSString  * redEnv = @"WCRedEnvelopes";
	//NSData * data = [NSData dataWithBytes:[redEnv UTF8String] length:redEnv.length];

 	NSDictionary * dic = (NSDictionary *)request;
	
	[dic.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		NSString * key = (NSString *)obj;
		[dictionary safeSetObject:[[dic objectForKey:key] gtm_stringByEscapingForURLArgument] forKey:key];
		
	}];
  
 	//   	NSDictionary * newdic = @{redEnv:dictionary};
	
	NSString * strEncoding = [%c(WCBizUtil) stringWithFormEncodedComponentsAscending:dictionary ascending:YES skipempty:YES separator:@"&"];

	NSLog(@"string encoding : %@",strEncoding);	
	//NSLog(@"---- %@ ",newdic);	
	// Get request string.
	NSData * data1 = [NSData dataWithBytes:[strEncoding UTF8String] length:strEncoding.length];

	[bufferA setBuffer:data1];
	[bufferA setILen:strEncoding.length];
	
	[req setReqText:bufferA];
 	[req setCgiCmd:cmdid];
	[req setOutPutType:type];

	//WCRedEnvelopesLogicMgr *logicMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("WCRedEnvelopesLogicMgr") class]];
 	WCRedEnvelopesNetworkHelper * netHelper =  [[objc_getClass("WCRedEnvelopesNetworkHelper") alloc] init];
	//  [[ WCRedEnvelopesNetworkHelper alloc] init]; //[logicMgr m_networkHelper]; 

	netHelper.m_delegate = (id<WCRedEnvelopesNetworkHelperDelegate>)self;
	[netHelper WCToEnterpriseCommonBizReq:req];

	NSLog(@" ------- send ok -----------");


//	%orig;

//	%log;
}
*/


-(void)ReceiverQueryRedEnvelopesRequest:(id)request {

%log;

NSLog(@"rece res: %@",request);

%orig;
}

-(void)OnWCToHongbaoCommonResponse:(id)hongbaoCommonResponse Request:(id)request {
	%log;
	NSLog(@"================success hongbao  =============");

	NSLog(@"%@",[NSThread callStackSymbols]);

	HBLogDebug(@" hongbaoCommonResponse %@",hongbaoCommonResponse);

	HongBaoRes *hongbaores =  (HongBaoRes *)hongbaoCommonResponse;

 	SKBuiltinBuffer_t  *buffer = [hongbaores retText];

// JSON String:
	NSString * jsonstring = [[NSString alloc] initWithData:buffer.buffer encoding:NSUTF8StringEncoding];

	NSDictionary * dic = [NSDictionary dictionaryWithDictionary: [jsonstring JSONDictionary]];
	
	NSLog(@"dic %@",dic);

	if (dic != nil) {
		int aa = [[dic objectForKey:@"amount"] integerValue];
		int bb = [[dic objectForKey:@"totoalAmount"] integerValue];
		//int bb = (int)tamount;
		//int aa = (int)amount;
		NSString * notify = [NSString stringWithFormat:@"成功抢到红包%f元,总共：%f元",float(aa)/10,float(bb)/10 ] ;			
		
//定义本地通知对象
    UILocalNotification *notification=[[UILocalNotification alloc]init];
        notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:0.2];
	    notification.repeatInterval=1;
	        notification.alertBody= notify;
		    [[UIApplication sharedApplication] scheduleLocalNotification:notification];

	}


// JSON Requset:

	HongBaoReq * requests = (HongBaoReq *) request;

 	SKBuiltinBuffer_t  *bufferq = [requests reqText];


	NSString * jsonstringRes = [[NSString alloc] initWithData:bufferq.buffer encoding:NSUTF8StringEncoding];

	NSDictionary * dicRes = [NSDictionary dictionaryWithDictionary: [jsonstringRes JSONDictionary]];

	

//	WCRedEnvelopesLogicMgr *logicMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("WCRedEnvelopesLogicMgr") class]];
        
//	[logicMgr SendShareRedEnvelopesoRequest:request];

	NSLog(@"parseFromData :%@",dicRes  );
	NSLog(@" request data: %@ ", request );

	NSLog(@"============receive hongbao success end=================");

	%orig;

}

-(void)OnWCToHongbaoCommonErrorResponse:(id)hongbaoCommonErrorResponse Request:(id)request {

}

-(void)OnWCToHongbaoCommonSystemErrorResponse:(id)hongbaoCommonSystemErrorResponse Request:(id)request {


}

%end



%hook WCRedEnvelopesControlLogic
- (NSString* )debugDescription { %log; NSString*  r = %orig; HBLogDebug(@" = %@", r); return r; }
- (NSString* )description { %log; NSString*  r = %orig; HBLogDebug(@" = %@", r); return r; }
- (Class )superclass { %log; Class  r = %orig; HBLogDebug(@" = %@", r); return r; }
- (unsigned )hash { %log; unsigned  r = %orig; HBLogDebug(@" = %u", r); return r; }
-(void)OnWCRedEnvBizBaseRequestCommonSystemError:(id)error HBCmdType:(int)type { %log; %orig; }
-(void)OnWCRedEnvBizBaseRequestCommonError:(id)error HBCmdType:(int)type { %log; %orig; }
-(void)OnWCRedEnvEnterpriseBaseRequestCommonSystemError:(id)error HBCmdType:(int)type { %log; %orig; }
-(void)OnWCRedEnvEnterpriseBaseRequestCommonError:(id)error HBCmdType:(int)type { %log; %orig; }
-(void)OnWCRedEnvelopesBaseRequestCommonSystemError:(id)error HongbaoCmdType:(int)type { %log; %orig; }
-(void)OnWCRedEnvelopesBaseRequestCommonError:(id)error HongbaoCmdType:(int)type { %log; %orig; }
-(BOOL)onNeedToControlCurrentPublicError { %log; BOOL r = %orig; HBLogDebug(@" = %d", r); return r; }
-(BOOL)onError:(id)error { %log; BOOL r = %orig; HBLogDebug(@" = %d", r); return r; }
-(void)onErrorAlertViewDismiss:(id)dismiss { %log; %orig; }
-(void)onErrorAlertViewStopLogic:(id)logic { %log; %orig; }
-(BOOL)OnCheckDismissCurrentViewControllerAndStopLogicAfterDismiss { %log; BOOL r = %orig; HBLogDebug(@" = %d", r); return r; }
-(BOOL)OnCheckDismissCurrentViewControllerAndStopLogicBeforeDismiss { %log; BOOL r = %orig; HBLogDebug(@" = %d", r); return r; }
-(void)stopLoading { %log; %orig; }
-(void)startWCPayLoading { %log; %orig; }
-(void)startLoading { %log; %orig; }
-(void)stopLogic { %log; %orig; }
-(id)initWithData:(id)data { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
-(id)init { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
%end





%hook WCRedEnvelopesNetworkHelper
+(void)idkeyCmdReport:(unsigned long)report keyName:(id)name value:(unsigned long)value { %log; %orig; }
+(void)idkeyCmdReport:(unsigned long)report keyName:(id)name { %log; %orig; }
-(void)MessageReturn:(id)aReturn Event:(unsigned long)event { %log; %orig; }
-(void)MessageReturnOnAsyncBizSubScribe:(id)scribe Event:(unsigned long)event { %log; %orig; }
-(void)MessageReturnOnCommonBizHongbao:(id)hongbao Event:(unsigned long)event { %log; %orig;

	
	NSLog(@"========= message return on hongbao msg: ====================");


	NSLog(@"%@",[NSThread callStackSymbols]);

	HBLogDebug(@" hongbaoCommonResponse %@",hongbao);

	ProtobufCGIWrap *hongbaores =  (ProtobufCGIWrap *)hongbao;

// JSON String:
	NSString * jsonstring = [[NSString alloc] initWithData:hongbaores.m_dtResponseDecryptKey encoding:NSUTF8StringEncoding];

	NSDictionary * dic = [NSDictionary dictionaryWithDictionary: [jsonstring JSONDictionary]];
	
	NSLog(@"dic %@",dic);

	WXPBGeneratedMessage* m_pbResponse  =  hongbaores.m_pbResponse;
	
	NSLog(@"%@  - %lu -  %@ -  %@  - %@  -   %@ ",    hongbaores.m_eventHandlerClass, hongbaores.m_uiMessage, hongbaores.m_nsUri, hongbaores.m_nsCgiName,  hongbaores.m_pbRespClass, hongbaores.debugDescription);


	NSLog(@" ->>>   %@   %@", hongbaores.m_pbResponse  , m_pbResponse.baseResponse  );

	HongBaoRes *hongbaores1 =  (HongBaoRes *) hongbaores.m_pbResponse;

 	SKBuiltinBuffer_t  *buffer = [hongbaores1 retText];

// JSON String:
	NSString * jsonstring1 = [[NSString alloc] initWithData:buffer.buffer encoding:NSUTF8StringEncoding];

	NSDictionary * dic1 = [NSDictionary dictionaryWithDictionary: [jsonstring1 JSONDictionary]];
	
	NSLog(@"dic %@",dic1);

	if (dic1 != nil) {
		NSString * msg = (NSString *)[dic1 objectForKey:@"retmsg"];
		NSLog(@"error: %@",msg);
	}
	
}
-(void)MessageReturnOnEnterpriseHongbao:(id)hongbao Event:(unsigned long)event { %log; %orig; }
-(void)MessageReturnOnHongbao:(id)hongbao Event:(unsigned long)event { %log; %orig; 


	
	NSLog(@"========= message return on hongbao msg: ====================");


	NSLog(@"%@",[NSThread callStackSymbols]);

	HBLogDebug(@" hongbaoCommonResponse %@",hongbao);

	ProtobufCGIWrap *hongbaores =  (ProtobufCGIWrap *)hongbao;

// JSON String:
	NSString * jsonstring = [[NSString alloc] initWithData:hongbaores.m_dtResponseDecryptKey encoding:NSUTF8StringEncoding];

	NSDictionary * dic = [NSDictionary dictionaryWithDictionary: [jsonstring JSONDictionary]];
	
	NSLog(@"dic %@",dic);

	WXPBGeneratedMessage* m_pbResponse  =  hongbaores.m_pbResponse;
	
	NSLog(@"%@  - %lu -  %@ -  %@  - %@  -   %@ ",    hongbaores.m_eventHandlerClass, hongbaores.m_uiMessage, hongbaores.m_nsUri, hongbaores.m_nsCgiName,  hongbaores.m_pbRespClass, hongbaores.debugDescription);


	NSLog(@" ->>>   %@   %@", hongbaores.m_pbResponse  , m_pbResponse.baseResponse  );

	HongBaoRes *hongbaores1 =  (HongBaoRes *) hongbaores.m_pbResponse;

 	SKBuiltinBuffer_t  *buffer = [hongbaores1 retText];

// JSON String:
	NSString * jsonstring1 = [[NSString alloc] initWithData:buffer.buffer encoding:NSUTF8StringEncoding];

	NSDictionary * dic1 = [NSDictionary dictionaryWithDictionary: [jsonstring1 JSONDictionary]];
	
	NSLog(@"dic %@",dic1);

	if (dic1 != nil) {
		NSString * msg = (NSString *)[dic1 objectForKey:@"retmsg"];
		NSLog(@"error: %@",msg);
	}




}
-(void)WCToAsyncBizSubcribeReq:(id)asyncBizSubcribeReq { %log; %orig; 
}
-(void)WCToEnterpriseCommonBizReq:(id)enterpriseCommonBizReq { %log; %orig; }
-(void)WCToEnterpriseHBBizReq:(id)enterpriseHBBizReq { %log; %orig; }
-(void)WCToHongbaoCommonRequest:(id)hongbaoCommonRequest { %log; %orig; }
-(id)init { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
%end





%hook NotificationActionsMgr

-(void)handleReceiveLocalNotification:(id)notification {
	%log;

	%orig;
}

    -(void)handleStatusNotifyResp:(id)resp {
    	 %log;


	 %orig;
    }

-(void)handleSendMsgResp:(id)resp{
	%log;

	%orig;
	
}
	    
	    
-(void)handleSetPushMuteResp:(id)resp{
	%log;

	%orig;
}

%end



#import "SocketRocketUtility.h"
#import "WalletHeader.h"

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

NSString * const kNeedPayOrderNote               = @"kNeedPayOrderNote";
NSString * const kWebSocketDidOpenNote           = @"kWebSocketDidOpenNote";
NSString * const kWebSocketDidCloseNote          = @"kWebSocketDidCloseNote";
NSString * const kWebSocketdidReceiveMessageNote = @"kWebSocketdidReceiveMessageNote";

@interface SocketRocketUtility()<SRWebSocketDelegate>
{
    int _index;
    NSTimer * heartBeat;
    NSTimeInterval reConnectTime;
    
}

@property (nonatomic,strong) SRWebSocket *socket;

@property (nonatomic,copy) NSString *urlString;

@end

@implementation SocketRocketUtility

+ (SocketRocketUtility *)instance {
    static SocketRocketUtility *Instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        Instance = [[SocketRocketUtility alloc] init];
    });
    return Instance;
}

#pragma mark - **************** public methods
-(void)SRWebSocketOpenWithURLString:(NSString *)urlString
{
    if (self.socket) {
        return;
    }
    
    if (!urlString) {
        return;
    }
    
    self.urlString = urlString;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    self.socket = [[SRWebSocket alloc] initWithURLRequest:request];
    

    //SRWebSocketDelegate
    self.socket.delegate = self;   
    
    [self.socket open];
}

- (void)SRWebSocketClose {
    if (self.socket){
        [self.socket close];
        self.socket = nil;
        [self destoryHeartBeat];
    }
}

#define WeakSelf(ws) __weak __typeof(&*self)weakSelf = self
- (void)sendData:(id)data {
//    NSLog(@"socketSendData --------------- %@",data);
    
    WeakSelf(ws);
    dispatch_queue_t queue =  dispatch_queue_create("zy", NULL);
    
    dispatch_async(queue, ^{
        if (weakSelf.socket != nil) {
            if (weakSelf.socket.readyState == SR_OPEN) {
                [weakSelf.socket send:data];
                
            } else if (weakSelf.socket.readyState == SR_CONNECTING) {
                
                [self reConnect];
                
            } else if (weakSelf.socket.readyState == SR_CLOSING || weakSelf.socket.readyState == SR_CLOSED) {
                
                
                [self reConnect];
            }
        } else {
           
        }
    });
}

#pragma mark - **************** private mothodes
- (void)reConnect {
    [self SRWebSocketClose];

    if (reConnectTime > 64) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.socket = nil;
        [self SRWebSocketOpenWithURLString:self.urlString];
    });
    
    if (reConnectTime == 0) {
        reConnectTime = 2;
    } else {
        reConnectTime *= 2;
    }
}


- (void)destoryHeartBeat {
    dispatch_main_async_safe(^{
        if (heartBeat) {
            if ([heartBeat respondsToSelector:@selector(isValid)]){
                if ([heartBeat isValid]){
                    [heartBeat invalidate];
                    heartBeat = nil;
                }
            }
        }
    })
}

- (void)initHeartBeat {
    dispatch_main_async_safe(^{
        [self destoryHeartBeat];
        heartBeat = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(sentheart) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:heartBeat forMode:NSRunLoopCommonModes];
    })
}

- (void)sentheart {
    [self sendData:@"heart"];
}

//pingPong
- (void)ping {
    if (self.socket.readyState == SR_OPEN) {
        [self.socket sendPing:nil];
    }
}

#pragma mark - **************** SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    reConnectTime = 0;
    [self initHeartBeat];
    if (webSocket == self.socket) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketDidOpenNote object:nil];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    if (webSocket == self.socket) {
        _socket = nil;
        [self reConnect];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    if (webSocket == self.socket) {
       
        [self SRWebSocketClose];
        [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketDidCloseNote object:nil];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSLog(@"reply===%@",reply);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {
    
    if (webSocket == self.socket) {
        
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValueIfNotNil:_callbackId forKey:@"callbackId"];
        [dict setValueIfNotNil:_requestId forKey:@"requestId"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketdidReceiveMessageNote object:dict];
    }
}

#pragma mark - **************** setter getter
- (SRReadyState)socketReadyState {
    return self.socket.readyState;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

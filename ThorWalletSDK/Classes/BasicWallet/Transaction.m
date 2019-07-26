/**
 *  MIT License
 *
 *  Copyright (c) 2017 Richard Moore <me@ricmoo.com>
 *
 *  Permission is hereby granted, free of charge, to any person obtaining
 *  a copy of this software and associated documentation files (the
 *  "Software"), to deal in the Software without restriction, including
 *  without limitation the rights to use, copy, modify, merge, publish,
 *  distribute, sublicense, and/or sell copies of the Software, and to
 *  permit persons to whom the Software is furnished to do so, subject to
 *  the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included
 *  in all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 *  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 *  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 *  DEALINGS IN THE SOFTWARE.
 */
#import "Transaction.h"

#include "ecdsa.h"
#include "secp256k1.h"

#import "Account.h"
#import "RLPSerialization.h"
#import "SecureData.h"
#import "Utilities.h"

static NSErrorDomain ErrorDomain = @"wallet.TransactionError";

static NSData *stripDataZeros(NSData *data) {
    const char *bytes = data.bytes;
    NSUInteger offset = 0;
    while (offset < data.length && bytes[offset] == 0) { offset++; }
    return [data subdataWithRange:NSMakeRange(offset, data.length - offset)];
}

static NSData *dataWithByte(unsigned char value) {
    return [NSMutableData dataWithBytes:&value length:1];
}

NSString *chainName(ChainId chainId) {
    switch (chainId) {
        case ChainIdHomestead:  return @"homestead";
        case ChainIdMorden:     return @"morden";
        case ChainIdRopsten:    return @"ropsten";
        case ChainIdRinkeby:    return @"rinkeby";
        case ChainIdKovan:      return @"kovan";
        default:
            break;
    }
    return nil;
}

static NSData *NullData = nil;


#pragma mark -
#pragma mark - Signature

@interface Signature (private)

+ (instancetype)signatureWithData: (NSData*)data v: (char)v;

@end


#pragma mark -
#pragma mark - Transaction

@implementation Transaction

#pragma mark - Life-Cycle

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NullData = [NSData data];
    });
}

- (instancetype)initWithFromAddress: (Address*)fromAddress {
    self = [self init];
    if (self) {
        _fromAddress = fromAddress;
    }
    return self;
}

+ (instancetype)transaction {
    return [[Transaction alloc] init];
}

+ (instancetype)transactionWithFromAddress:(Address*)fromAddress {
    return [[Transaction alloc] initWithFromAddress:fromAddress];
}

+ (instancetype)transactionWithData: (NSData*)transactionData {
    
    // Thinking out loud: Is there ANY difference between a transaction without a gasPrice
    // and one with a gasPrice of zero? If not, we should instantiate BigNumbers for
    // gasPrice, gasLimit, value and NSData for data
    
    // Decode the RLP
    NSError *error = nil;
    NSArray *raw = (NSArray*)[RLPSerialization objectWithData:transactionData error:&error];
    if (error || ![raw isKindOfClass:[NSArray class]]) { return nil; }
    
    if (raw.count != 9) { return nil; }

    // Check that every item is data (and not a nested array)
    for (NSData *item in raw) {
        if (![item isKindOfClass:[NSData class]]) {
            return nil;
        }
    }
    
    Transaction *transaction = [Transaction transaction];
    
    {
        BigNumber *nonce = [BigNumber bigNumberWithData:[raw objectAtIndex:0]];
        if (!nonce.isSafeUnsignedIntegerValue) {
            NSLog(@"WARNING: Nonce is out of range (%@)", nonce);
        }
        transaction.nonce = [nonce unsignedIntegerValue];
    }
    
    {
        NSData *gasPriceCoef = [raw objectAtIndex:4];
        if (gasPriceCoef.length > 32) {
            return nil;
        } else {
            transaction.gasPrice = [BigNumber bigNumberWithData:gasPriceCoef];
        }
    }

    {
        NSData *gasLimit = [raw objectAtIndex:2];
        if (gasLimit.length > 32) {
            return nil;
        } else {
            transaction.gasLimit = [BigNumber bigNumberWithData:gasLimit];
        }
    }

    {
        NSData *toAddress = [raw objectAtIndex:3];
        if (toAddress.length) {
            transaction.toAddress = [Address addressWithData:toAddress];
            if (!transaction.toAddress) { return nil; }
        }
    }
    
    {
        NSData *value = [raw objectAtIndex:4];
        if (value.length > 32) {
            return nil;
        } else {
            transaction.value = [BigNumber bigNumberWithData:value];
        }
    }
    
    transaction.data = [raw objectAtIndex:5];

    {
        NSData *vObject = [raw objectAtIndex:6];
        if (vObject.length > 1) { return nil; }
        
        unsigned char v = 0;
        if (vObject.length == 1) {
            [vObject getBytes:&v range:NSMakeRange(0, 1)];
        }

        NSData *r = [raw objectAtIndex:7], *s = [raw objectAtIndex:8];;
        if (r.length > 32 || s.length > 32) { return nil; }
        
        NSMutableData *data = [NSMutableData dataWithLength:64];
        memset(data.mutableBytes, 0, 64);
        
        if (r.length) {
            [r getBytes:&data.mutableBytes[32 - r.length] range:NSMakeRange(0, r.length)];
        }
        
        if (s.length) {
            [s getBytes:&data.mutableBytes[64 - s.length] range:NSMakeRange(0, s.length)];
        }
        
        [transaction verifySignatureData:data v:v];
    }

    
    return transaction;
}


#pragma mark - Getters (prevent nil)

- (BigNumber*)gasLimit {
    if (!_gasLimit) { return [BigNumber constantZero]; }
    return _gasLimit;
}

- (BigNumber*)gasPrice {
    if (!_gasPrice) { return [BigNumber constantZero]; }
    return _gasPrice;
}

- (BigNumber*)value {
    if (!_value) { return [BigNumber constantZero]; }
    return _value;
}

- (NSData*)data {
    if (!_data) { return NullData; }
    return _data;
}

#pragma mark - Signature

- (void)_setSignature: (Signature*)signature {
    _signature = signature;
}

- (void)sign:(Account *)account {
    if (account) {
        NSMutableArray *raw = [self _packBasic];
        if (_chainId) {
            [raw addObject:dataWithByte(_chainId)];
            [raw addObject:NullData];
            [raw addObject:NullData];
        }
        NSError *error = nil;
        SecureData *digest = [SecureData BLAKE2B:[RLPSerialization dataWithObject:raw error:&error]];
        _fromAddress = account.address;
        _signature = [account signDigest:digest.data];
    } else {
        _fromAddress = nil;
        _signature = nil;
    }
}
- (NSData *)getSigntureMessage
{
    NSMutableArray *raw = [self _packBasic];
    NSError *error = nil;
    SecureData *digest = [SecureData BLAKE2B:[RLPSerialization dataWithObject:raw error:&error]];
    return digest.data;
}


- (void)verifySignatureData: (NSData*)signatureData v: (unsigned char)v {
    _signature = [Signature signatureWithData:signatureData v:v];

    // Use an int so we can detect underflow
    int chainId = (v - 35) / 2;
    if (chainId < 0) { chainId = 0; }

    _chainId = chainId;
    
    NSMutableArray *raw = [self _packBasic];
    if (_chainId) {
        [raw addObject:dataWithByte(_chainId)];
        [raw addObject:NullData];
        [raw addObject:NullData];
    }
    
    NSData *digest = [SecureData KECCAK256:[RLPSerialization dataWithObject:raw error:nil]];
    
    SecureData *publicKey = [SecureData secureDataWithLength:65];
    
    if (_chainId) {
        v -= (_chainId * 2 + 8);
    }

    int failed = ecdsa_verify_digest_recover(&secp256k1, publicKey.mutableBytes, signatureData.bytes, digest.bytes, v);
    if (!failed) {
        _fromAddress = [Address addressWithData:[[[publicKey subdataFromIndex:1] KECCAK256] subdataFromIndex:12].data];
    }
}

- (NSString *)txID:(Account *)account {
    if (account) {
        NSMutableArray *raw = [self _packBasic];
        if (_chainId) {
            [raw addObject:dataWithByte(_chainId)];
            [raw addObject:NullData];
            [raw addObject:NullData];
        }
        NSError *error = nil;
        SecureData *digest = [SecureData BLAKE2B:[RLPSerialization dataWithObject:raw error:&error]];
        SecureData *copy = digest.copy;
        [copy appendData:[SecureData secureDataWithHexString:account.address.checksumAddress].data];
        return [SecureData dataToHexString:[[SecureData BLAKE2B:copy.data] data]];
    }
    return nil;
}


- (NSString *)obersverTxID:(NSString *)address
{
    if (address) {
        NSMutableArray *raw = [self _packBasic];
        if (_chainId) {
            [raw addObject:dataWithByte(_chainId)];
            [raw addObject:NullData];
            [raw addObject:NullData];
        }
        NSError *error = nil;
        SecureData *digest = [SecureData BLAKE2B:[RLPSerialization dataWithObject:raw error:&error]];
        SecureData *copy = digest.copy;
        [copy appendData:[SecureData secureDataWithHexString:address].data];
        return [SecureData dataToHexString:[[SecureData BLAKE2B:copy.data] data]];
    }
    return nil;
}
#pragma mark - Serialization

- (NSMutableArray*)_packBasic {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:10];
    
    if (self.ChainTag) {
        [result addObject:stripDataZeros([SecureData hexStringToData:self.ChainTag.hexString])];
    } else {
        [result addObject:NullData];
    }
    
    if (self.BlockRef) {
        [result addObject:stripDataZeros([SecureData hexStringToData:self.BlockRef.hexString])];
    } else {
        [result addObject:NullData];
    }
    
    if (self.Expiration) {
        [result addObject:stripDataZeros(convertIntegerToData(self.Expiration))];
    } else {
        [result addObject:NullData];
    }

    if (self.Clauses) {
        [result addObject:self.Clauses];
    } else {
        [result addObject:NullData];
    }

    if (self.gasPrice) {
        NSData *gasPriceCoefData = stripDataZeros([SecureData hexStringToData:[self.gasPrice hexString]]);
        if (gasPriceCoefData.length > 32) { return nil; }
        [result addObject:gasPriceCoefData];
    } else {
        [result addObject:NullData];
    }

    if (self.gasLimit) {
        NSData *gasLimitData = stripDataZeros([SecureData hexStringToData:[self.gasLimit hexString]]);
        if (gasLimitData.length > 32) { return nil; }
        [result addObject:gasLimitData];
    } else {
        [result addObject:NullData];
    }

    [result addObject:self.dependsOn];


    {
        NSData *nonceData = stripDataZeros(convertIntegerToData(self.nonce));
        if (nonceData.length > 32) { return nil; }
        [result addObject:nonceData];
    }

    [result addObject:@[]];
    return result;
}

- (NSData*)serialize {
    NSMutableArray *raw = [self _packBasic];
    if (_signature) {
        
        NSMutableArray *subList = [NSMutableArray array];
        NSString *r = [SecureData dataToHexString:self.signature.r];
        [subList addObject: [r substringFromIndex:2]];
        NSString *s = [SecureData dataToHexString:self.signature.s];
        [subList addObject: [s substringFromIndex:2]];
       
        SecureData *vData = [SecureData new];
        [vData appendByte:self.signature.v];
        
        [subList addObject:vData.numberHexString];
        
        NSString *subStr = [subList componentsJoinedByString:@""];
        NSString *temp = [NSString stringWithFormat:@"0x%@",subStr];
        [raw addObject:[SecureData hexStringToData:temp]];
        
    } else {
        [raw addObject:dataWithByte(_chainId ? _chainId: 28)];
        [raw addObject:NullData];
        [raw addObject:NullData];
    }
    
    return [RLPSerialization dataWithObject:raw error:nil];
}

- (NSData*)unsignedSerialize {
    NSMutableArray *raw = [self _packBasic];

    if (_chainId) {
        [raw addObject:dataWithByte(_chainId)];
        [raw addObject:NullData];
        [raw addObject:NullData];
    }
    
    return [RLPSerialization dataWithObject:raw error:nil];
}

- (BOOL)populateSignatureWithR: (nonnull NSData*)r s: (nonnull NSData*)s address:(nonnull Address *)address {
    SecureData *publicKey = [SecureData secureDataWithLength:65];
    
    NSMutableData *sig = [r mutableCopy];
    [sig appendData:s];
    
    NSData *digest = [SecureData KECCAK256:[self unsignedSerialize]];

    for (uint8_t recid = 0; recid <= 3; recid++) {
        int failed = ecdsa_verify_digest_recover(&secp256k1, publicKey.mutableBytes, sig.bytes, digest.bytes, recid);
        if (!failed) {
            Address *fromAddress = [Address addressWithData:[[[publicKey subdataFromIndex:1] KECCAK256] subdataFromIndex:12].data];
            if ([fromAddress isEqualToAddress:address]) {
                _signature = [Signature signatureWithData:[NSData dataWithData:sig] v:recid];
                _fromAddress = fromAddress;
                return YES;
            }
        }
    }
    
    return NO;
}

- (Hash*)transactionHash {
    if (!_signature) { return nil; }
    return [Hash hashWithData:[SecureData KECCAK256:[self serialize]]];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    Transaction *transaction = [Transaction transactionWithFromAddress:self.fromAddress];
    transaction.nonce = self.nonce;
    transaction.gasPrice = [self.gasPrice copy];
    transaction.gasLimit = [self.gasLimit copy];
    transaction.toAddress = self.toAddress;
    transaction.value = [self.value copy];
    transaction.data = [self.data copy];
    transaction.chainId = self.chainId;
    [transaction _setSignature:_signature];
    
    return transaction;
}


#pragma mark - NSObject

- (NSString*)description {
    return [NSString stringWithFormat:@"<Transaction to=%@ from=%@ nonce=%d gasPrice=%@ gasLimit=%@ value=%@ data=%@ chainId=%d signature=%@>",
            self.toAddress, self.fromAddress, (int)self.nonce, [self.gasPrice decimalString], [self.gasLimit decimalString],
            [self.value decimalString], [SecureData dataToHexString:self.data], _chainId, _signature];
}

@end

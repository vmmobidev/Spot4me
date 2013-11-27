 //

//  Connection.m

//  PrivyText

//

//  Created by Mac Mini on 14/10/11.

//  Copyright 2011 __MyCompanyName__. All rights reserved.

//


#import "Connection.h"
#import "ConnectionDelegate.h"

@implementation Connection
@synthesize delegate,FinalDistanceArray2,FinalDistanceArray;


-(id)init

{
    
    finalResultArray=[[NSMutableArray alloc]init];
    zipOrigin=[[NSString alloc]init];
    
    return self;
    
}

- (void)nextPageToken:(NSString *)nextPageToken{
    
}

-(void) getMethod:(NSString *) getStr
{
    FinalDistanceArray = [[NSMutableArray alloc]init];
    FinalDistanceArray2 = [[NSMutableArray alloc]init];
    soapDictionary = [[NSMutableDictionary alloc] init];
    resultArray = [[NSMutableArray alloc] init];
    addressArray = [[NSMutableArray alloc] init];
//	NSLog(@"the get str is %@", getStr);
  	//Get the URL String and passed to the URL Request
 	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:getStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
	//Initialize the connection for NSURL Connection
	theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
 	if(theConnection)
	{
		//Initialize the data and retain the data
		receiveData = [NSMutableData data];
	}
	else {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please check internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        //[alert release];
		
	}
}
//If the connection is fails to load
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
	UIAlertView *aleart=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Connection faild" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[aleart show];
	//[aleart release];
 	
//	NSLog(@"......didFailWithError");
	//[connection release];
}

//Connection loads a data incrementally
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	NSLog(@"didReceiveResponse");
	[receiveData setLength:0];
    NSLog(@"didReceiveResponse.......%@",receiveData);
    
}

//If the connection has received the sufficient data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"didReceiveData");
	[receiveData appendData:data];
	
}
//If the connection finished successfully
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	// Get the data from the server
 	NSString *urlDataString = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
//	NSLog(@"urldata sreing is %@", urlDataString);
   	//Initialize the SBJSON and parsing the JSON data
    
  	//SBJSON *parser = [[SBJSON alloc] init];
   	NSError *error = nil;
	//Stored the JSON results into the Mutable Array
 	NSMutableDictionary *accountant = [NSJSONSerialization JSONObjectWithData:receiveData options: NSJSONReadingMutableContainers error: &error];//[parser objectWithString:urlDataString error:&error];
    
    
    NSArray *results = [accountant objectForKey:@"results"];
    
    NSString *nextPageToken = [accountant objectForKey:@"next_page_token"];
    
    [delegate nextPageToken:nextPageToken];

    
/*
	//Pass the result array into the delegate method
    accountant = [accountant objectForKey:@"responseData"];
	NSArray *results = [accountant objectForKey:@"results"];
    
*/
    
    
//	NSLog(@"results %@",results);
 	for(int i = 0 ; i < [results count];i++)
	{
		
		NSMutableDictionary *dict = [NSMutableDictionary new];

        NSDictionary *resultDictionary = [results objectAtIndex:i];
        NSDictionary *locationDictonary = [[resultDictionary objectForKey:@"geometry"] objectForKey:@"location"];
        NSString *lati = [locationDictonary objectForKey:@"lat"];
        NSString *longi = [locationDictonary objectForKey:@"lng"];
        
		
		NSString *title = [[results objectAtIndex:i]objectForKey:@"name"];

		NSString *addr = [[results objectAtIndex:i]objectForKey:@"vicinity"];
        
//		NSString *country = [[results objectAtIndex:i]objectForKey:@"country"];
//		NSString *city = [[results objectAtIndex:i]objectForKey:@"city"];
//		NSString *region = [[results objectAtIndex:i]objectForKey:@"region"];
		
//		NSLog(@"addrs %@",addr);
        @try {
            [dict setObject:title forKey:@"title"];
            [dict setObject:addr forKey:@"Address"];
            [dict setObject:longi forKey:@"longitude"];
            [dict setObject:lati forKey:@"latitude"];
//            [dict setObject:country forKey:@"country"];
//            [dict setObject:city forKey:@"city"];
//            
//            [dict setObject:region forKey:@"region"];
            
//            NSLog(@"the dict value= %@",dict);
            
            [resultArray addObject:dict];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        @finally {
            NSLog(@"Finally");
        }
    }
    
    
//}
    for (int i = 0; i<[resultArray count]; i++) {
//        NSMutableDictionary *latLongDict = [[NSMutableDictionary alloc] init];
        NSString *resltStrlat = [[resultArray objectAtIndex:i]objectForKey:@"latitude"];
        NSString *resltStrLong = [[resultArray objectAtIndex:i]objectForKey:@"longitude"];
       // [latLongDict setObject:resltStrlat forKey:<#(id<NSCopying>)#>];
        [addressArray addObject:[NSString stringWithFormat:@"%@,%@",resltStrlat,resltStrLong]];
        //NSLog(@"Result Array>>> for Address %@", addressArray);
    }
    [self FinalJsonDistance];
 	[self soapResult:resultArray];
	//Release the JSON string
	//[urlDataString release];
	//Release the SBJSON parser instance
	//[parser release];
	
}

//It returns the result array for the partical request
//-(void)getResult:(id)_result{
//  	//Stored the results in the _result of the Connection delegate Method
//	[delegate getResult:_result];
//}



//If the connection finished successfully
  
-(void)FinalJsonDistance{
    int temp=0;
    int x=25;
    int k=0;
    int j=[addressArray count]/25;
    int elsevalue=[addressArray count]%25;
    NSLog(@"Address Array %d",[addressArray count]);
    if([addressArray count]>25)
    {
        for(int i=0;i<j;i++)
        {
            NSMutableString *string=[[NSMutableString alloc]init];
            for( k=x*i;k<(x*(i+1));k++)
            {
                [string appendString:[addressArray objectAtIndex:temp]];
                [string appendString:@"|"];
                NSLog(@"%d %d",k,x);
                temp++;
                
            }
            [self makeConnection:string];
        }
    }
    if(elsevalue>0)
        
    { 
        NSMutableString *string1=[[NSMutableString alloc]init];
        for(int elseValueis=0;elseValueis<elsevalue;elseValueis++)
            
        {
            [string1 appendString:[addressArray objectAtIndex:temp]];
            [string1 appendString:@"|"];
            NSLog(@"elseValue is %d and temp value is %d",elseValueis,elsevalue);
            temp++;
            
        }
        [self makeConnection:string1];
    }
    
}

-(void)makeConnection:(NSString*)str

{
    NSLog(@"%d",temp1);
    BOOL addrs = [[NSUserDefaults standardUserDefaults] boolForKey:@"Address"];
    if (addrs) {
        
        finalAdd=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"AddrsStr"]];
        
        NSLog(@"....origin...>>>>>>.%@",finalAdd);
        //str =[str stringByReplacingOccurrencesOfString:@", " withString:@"+"];
        NSString *string1 =[str stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        urlstring=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%@&destinations=%@&sensor=false&units=imperial",finalAdd,string1];
    }else{
    finalAdd=[NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Latitude"],[[NSUserDefaults standardUserDefaults] objectForKey:@"Longitude"]];
   
    NSLog(@"....origin.current..>>>>>>.%@",finalAdd);
    //str =[str stringByReplacingOccurrencesOfString:@", " withString:@"+"];
    NSString *string1 =[str stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    urlstring=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%@&destinations=%@&sensor=false&units=imperial",finalAdd,string1];
    // NSString *encode = [string1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    NSString *encode2 = [urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urlFromString = [NSURL URLWithString:encode2];
   // NSStringEncoding encodingType = NSUTF8StringEncoding;
	NSData *data = [[NSData alloc] initWithContentsOfURL:urlFromString];
//	NSLog(@"the data=%@",data);
	NSString *contents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//	NSLog(@"the content=%@",contents);
	
    NSError *er;
   // NSString *reverseGeoString = [NSString stringWithContentsOfURL:urlFromString encoding:encodingType error:nil];
   // SBJSON *parser = [[SBJSON alloc] init];
    NSDictionary *locationResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&er];//[reverseGeoString copy]; //
    //[parser objectWithString:reverseGeoString];
//    NSLog(@"..uuurrrrlll..adddddddd %@",urlFromString);
    //[locationResult1 addObject:locationResult];
//    NSLog(@"....adddddddd %@",locationResult);
    NSString *status = (NSString *)[locationResult objectForKey:@"status"];
    // NSString *retVal = nil;
    NSMutableArray *retValArray = [[NSMutableArray alloc] init];
    //NSLog(@"dfgdfgjhgdjhdfg  %@",status);
    if([status isEqualToString:@"NOT_FOUND"])
        {
    
            NSLog(@"Nothing");
    
       }
    if([status isEqualToString:@"OK"])
        
    {
        NSArray *results = [locationResult objectForKey:@"rows"];
        if([results count] > 0)
            
        {
            NSDictionary *address=[results objectAtIndex:0];
            NSArray *resultZero=[[address objectForKey:@"elements"]valueForKey:@"status"];
            NSString *resultZero1=[resultZero objectAtIndex:0];
            NSLog(@">>>>>>>>>>>>>>%@",resultZero1);
            if ([resultZero1 isEqual:@"ZERO_RESULTS"]) {
                
                if([resultArray count]>0){
                [resultArray removeLastObject];
                }
                else
                {
                UIAlertView *aleart=[[UIAlertView alloc]initWithTitle:@"Techinical Difficulties!" message:@"Please try after some time" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [aleart show];
            }
            }
            else {
                retValArray = [[[address objectForKey:@"elements"]valueForKey:@"distance"]valueForKey:@"text"];
                // NSLog(@"address is.>>>>>>>>>distance..%@",retValArray);
                NSMutableString *distStr = [[NSMutableString alloc]init];
                for (int i = 0; i < [retValArray count]; i++) {
                    NSString *str = [retValArray objectAtIndex:i];
                    str = [str stringByReplacingOccurrencesOfString:@"," withString:@""];
                    NSArray *array2 = [str componentsSeparatedByString:@" "];
//                    NSLog(@"address is..formatted.%@",array2);
                    NSLog(@"teh value is %@", trimmedStr);
                    float getvalue = [[array2 objectAtIndex:0]floatValue];
                    NSString *dis=[NSString stringWithFormat:@"%@",[array2 objectAtIndex:1]];
                    float dist;
                    if([dis isEqualToString:@"mi"])
                        
                    {
                        dist= getvalue*1.61;
                    }
                    if([dis isEqualToString:@"ft"])
                    {
                        dist= getvalue*0.000189394;
                        
                    }
                    
                    distStr = [[NSString stringWithFormat:@"%f",dist] mutableCopy];
                    NSLog(@"value is...%f",getvalue);
                    NSLog(@"value is.distance...>>>>>..%f",dist);
                    [FinalDistanceArray addObject:distStr];
                }
 //               NSLog(@"Final Result %@",finalResultArray);
                
                for (int i=0; i<[FinalDistanceArray count]; i++) {
                    [[resultArray objectAtIndex:i]setValue:[FinalDistanceArray objectAtIndex:i] forKey:@"Distance"];
                }
//        NSLog(@"result array %@",resultArray);
            }
            NSLog(@"FinalDistanceArray %d, result array %d",[FinalDistanceArray count],[resultArray count]);
            for(int i=temp1;i<[FinalDistanceArray count];i++)
            {
                
                [[resultArray objectAtIndex:temp1]setValue:[FinalDistanceArray objectAtIndex:i] forKey:@"Distance"];
                NSLog(@"FinalDistanceArray %d temp %d",[FinalDistanceArray count],temp1);
                temp1++;
               
                
            }
//             NSLog(@"ResultArray %@",resultArray);
            
            
            
            
//            if([FinalDistanceArray count]==[resultArray count]){   
//                
//                
//                
//                NSArray *sortedArray = [resultArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//                    
//                    NSDictionary *first=(NSDictionary *)obj1;
//                    NSDictionary *second=(NSDictionary *)obj2;
//                    obj1=[first valueForKey:@"Distance"];
//                    obj2=[second valueForKey:@"Distance"];
//                    if ([obj1 floatValue] > [obj2 floatValue])
//                        return NSOrderedDescending;
//                    else if ([obj1 floatValue] < [obj2 floatValue])
//                        return NSOrderedAscending;
//                    
//                    return NSOrderedSame;
//                }];
//                NSLog(@"%@",sortedArray);
//                for(int i=0;i<[resultArray count];i++)
//                {
//                    if([[(NSDictionary*)[sortedArray objectAtIndex:i]valueForKey:@"Distance"]floatValue]<=20&&[[(NSDictionary*)[sortedArray objectAtIndex:i]valueForKey:@"CompanyId"]floatValue]>0)
//                    {
//                        
//                        [finalResultArray addObject:[sortedArray objectAtIndex:i]];
//                    }
//                }
//                
//                resultArray=[finalResultArray copy];
//            }
            
        }  
        
    }
}




-(void)soapResult:(id)_result{
    
    [delegate soapResult:_result];
}





@end

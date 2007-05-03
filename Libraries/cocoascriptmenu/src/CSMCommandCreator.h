

@protocol CSMCommandCreator <NSObject>

-(id)initWithScriptPath:(NSString*) aPath;

@end

@interface CSMCommandCreator : NSObject <CSMCommandCreator>
{    
}

-(id)initWithScriptPath:(NSString*) aPath;


@end
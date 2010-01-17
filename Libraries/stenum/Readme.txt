So this framework adds the standard SmallTalk enumeration patterns to the main cocoa collection classes, using functions pointers.

The benefit is instead of having to write something like this:
---
NSEnumerator *enumerator = [testArray objectEnumerator];
id object;
id tempArray = [NSMutableArray arrayWithCapacity:[self count]]; 
while (object = [enumerator nextObject]) {
    if([object intValue] < 0)
         [tempArray addObject:object];
}
---

You can write this:
(note later versions of mac os x don't like nested functions so they have to declared outside of the obj-c implmentation)
---
BOOL selectNegative(id each, void* context){
        return ([each intValue] < 0);  
}
id tempArray2 = [testArray selectUsingFunction:selectNegative context:nil];
---

This Framework adds the following methods to NSArray, NSDictionary, and NSSet and their subclasses.

- (void) doUsingFunction:(STDoFunction ) doFunction
                 context:(void *) context;

- (id) collectUsingFunction:(STCollectFunction ) collectingFunction 
                    context: (void *) context;

- ( id ) selectUsingFunction: (STSelectFunction ) selectingFunction  
                     context: (void *) context;

- (id) detectUsingFunction:(STSelectFunction ) detectingFunction
                   context: (void *) context;

- ( id ) rejectUsingFunction: (STSelectFunction ) rejectingFunction
                     context: (void *) context;


- ( id ) injectUsingFunction:(STInjectFunction ) injectingFunction  
                        into: (id ) object  
                     context: (void *) context;
    or                 

- ( id ) injectObject: (id ) anObject 
         intoFunction: (STInjectFunction ) injectingFunction 
          context: (void *) context;

You can read more in the Doc/ folder, and build your own from source in the Source/

This framework was  built to be embedded, thus to use in your xcode projects, you need to add a copy phase that adds it to the bundles Frameworks folder.



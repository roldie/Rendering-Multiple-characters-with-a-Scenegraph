//
//  ViewController.m
//  openglesinc
//
//  Created by Harold Serrano on 2/9/15.
//  Copyright (c) 2015 www.roldie.com. All rights reserved.
//

#import "ViewController.h"
#include "Character.h"
#include "Button.h"
#include "Joystick.h"
#include "CharacterAsset.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1, Allocate a EAGLContext object and initialize a context with a specific version.
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    //2. Check if the context was successful
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    //3. Set the view's context to the newly created context
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    glViewport(0, 0, view.frame.size.height, view.frame.size.width);
    
    //4. This will call the rendering method glkView 60 Frames per second
    view.enableSetNeedsDisplay=60.0;
    
    //5. Make the newly created context the current context.
    [EAGLContext setCurrentContext:self.context];
    
    
    //6. create an instance of the Joystick class
    joystick=new Joystick(680,800,"joyStickBackground.png",100,100,"joystickDriver.png",60,60,self.view.bounds.size.height,self.view.bounds.size.width);
    
    //7. begin the OpenGL setup for the joystick
    joystick->setupOpenGL();
    
    currentXTouchPoint=0.0;
    currentYTouchPoint=0.0;
    
    touchBegan=false;
    
    //8. create a Character class instance
    //Note, since the ios device will be rotated, the input parameters of the character constructor
    //are swapped.
    house=new Character(smallHouse1_vertices,smallHouse1_normal,smallHouse1_uv,smallHouse1_index,3372,"smallhouse1.png",self.view.bounds.size.height,self.view.bounds.size.width);
    
    //9. Begin the OpenGL setup for the character
    house->setupOpenGL();
    
    //10. Create a second character called "little mansion"
    Character *littleMansion=new Character(littleMansion_vertices,littleMansion_normal,littleMansion_uv,littleMansion_index,2205,"little_mansion.png",self.view.bounds.size.height,self.view.bounds.size.width);
    
    //11. Add it as a child to the "house" character
    house->addChild(littleMansion);
    
    littleMansion->setupOpenGL();
    
    house->translateTo(-1.0, 0.0, 0.0);
    
    littleMansion->translateTo(5.0, 10.0, 0.0);
    
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    
    //1. test if the touch falls within the coordinates of the button
    if (touchBegan==true) {
        
        joystick->update(currentXTouchPoint, currentYTouchPoint);
        
        //2.test if the touch falls within the coordinates of the joystick
        if(joystick->getJoystickIsPress()==true){
            
            //3. update the character to rotate
            house->rotateTo(joystick->getDisplacementInXDirection(), 0.0, 0.0, 1.0);
           
            
        }
        
        
    }else{
        
        //4. reset the position of the joystick driver
        joystick->resetPosition();
    }
    
    Character *child=house;
    while(child!=NULL){
        
        if(child->isRoot()){
            //update position
            
            child->absoluteModelSpace=child->modelSpace;
            
        }else{
            
            //update position of child
            child->absoluteModelSpace=GLKMatrix4Multiply(child->parent->absoluteModelSpace, child->modelSpace);
            
        }
        
        child->update();
        child=child->next;
    }
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    
    //1. Clear the color to black
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    //2. Clear the color buffer and depth buffer
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //3. Render the character
    
    Character *child=house;
    
    while(child!=NULL){
        
        child->draw();
        child=child->next;
    }
    
    //5. Render the joystick
    joystick->draw();
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *myTouch in touches) {
        CGPoint touchPosition = [myTouch locationInView: [myTouch view]];
        
        touchBegan=true;
        
        float xPoint=(touchPosition.x-self.view.bounds.size.width/2)/(self.view.bounds.size.width/2);
        float yPoint=(self.view.bounds.size.height/2-touchPosition.y)/(self.view.bounds.size.height/2);
        
        currentXTouchPoint=xPoint;
        currentYTouchPoint=yPoint;
        
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *myTouch in touches) {
        CGPoint touchPosition = [myTouch locationInView: [myTouch view]];
        
        touchBegan=false;
        
        currentXTouchPoint=0.0;
        currentYTouchPoint=0.0;
        
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *myTouch in touches) {
        CGPoint touchPosition = [myTouch locationInView: [myTouch view]];
        
        touchBegan=true;
        
        float xPoint=(touchPosition.x-self.view.bounds.size.width/2)/(self.view.bounds.size.width/2);
        float yPoint=(self.view.bounds.size.height/2-touchPosition.y)/(self.view.bounds.size.height/2);
        
        currentXTouchPoint=xPoint;
        currentYTouchPoint=yPoint;
        
    }
}

- (void)dealloc
{
    //call teardown
    house->teadDownOpenGL();
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    [_context release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        //call teardown
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
    
    // Dispose of any resources that can be recreated.
}



@end

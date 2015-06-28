//
//  Character.h
//  OpenGL_Template_CPLUSPLUS
//
//  Created by Harold Serrano on 7/25/14.
//  Copyright (c) 2015 www.roldie.com. All rights reserved.
//

#ifndef __OpenGL_Template_CPLUSPLUS__Character__
#define __OpenGL_Template_CPLUSPLUS__Character__

#include <iostream>
#include <math.h>
#include <vector>
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#define MAX_SHADER_LENGTH   8192

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

#define OPENGL_ES

using namespace std;

class Character{
    
private:
    
    GLuint textureID[16];   //Array for textures
    GLuint programObject;   //program object used to link shaders
    GLuint vertexArrayObject; //Vertex Array Object
    GLuint vertexBufferObject; //Vertex Buffer Object
    
    float aspect; //widthDisplay/heightDisplay ratio
    GLint modelViewProjectionUniformLocation;  //OpenGL location for our MVP uniform
    GLint normalMatrixUniformLocation;  //OpenGL location for the normal matrix
    GLint modelViewUniformLocation; //OpenGL location for the Model-View uniform
    GLint UVMapUniformLocation; //OpenGL location for the Texture Map
    
    //Matrices for several transformation
    GLKMatrix4 projectionSpace;
    GLKMatrix4 cameraViewSpace;
    //GLKMatrix4 modelSpace;
    GLKMatrix4 worldSpace;
    GLKMatrix4 modelWorldSpace;
    GLKMatrix4 modelWorldViewSpace;
    GLKMatrix4 modelWorldViewProjectionSpace;
    
    GLKMatrix3 normalMatrix;
    
    float screenWidth;  //Width of current device display
    float screenHeight; //Height of current device display
    
    GLuint positionLocation; //attribute "position" location
    GLuint normalLocation;   //attribute "normal" location
    GLuint uvLocation; //attribute "uv"location
    
    vector<unsigned char> image;
    unsigned int imageWidth, imageHeight;
    
    int vertexSize; //size of the vertex data array
    int normalSize; //size of the normal data array
    int uvSize;     //size of the UV data array
    int indexSize;  //size of the index data array
    
    float *vertexData;  //pointer to the vertex data array
    float *normalData;  //pointer to the normal data array
    float *uvData;      //pointer to the UV data array
    int *indexData;   //pointer to the index data array
    
    
    const char* textureName; //character's texture
    
public:
    
    //Constructor
    Character(float *uVertex, float *uNormal, float *uUV, int *uIndex, int uIndexSize, const char* uTextureName,float uScreenWidth,float uScreenHeight);
    ~Character();
    
    void setupOpenGL(); //Initialize the OpenGL
    void teadDownOpenGL(); //Destroys the OpenGL
    
    void translateTo(float uX, float uY, float uZ); //translate the character to this position;
    void rotateTo(float uAngle, float uXAngle, float uYAngle, float uZAngle); //rotate the character to these angles
    
    //loads the shaders
    void loadShaders(const char* uVertexShaderProgram, const char* uFragmentShaderProgram);
    
    //Set the transformation for the object
    void setTransformation();
    
    GLKMatrix4 modelSpace;
    GLKMatrix4 absoluteModelSpace;
    
    //updates the mesh
    void update();
    
    //draws the mesh
    void draw();
    
    //scenegraph
    
    //root node
    Character *parent;
    
    //previous sibling
    Character *prevSibling;
    
    //next in pre-order
    Character *next;
    
    //leaf points to itself
    Character *lastDescendant;
    
    //get the first child
    Character *getFirstChild();
    
    //get last child
    Character *getLastChild();
    
    //get next sibling
    Character *getNextSibling();
    
    //get previous sibling
    Character *getPrevSibling();
    
    //get previous in pre order traversal
    Character *prevInPreOrderTraversal();
    
    //get next in pre order traversal
    Character *nextInPreOrderTraversal();
    
    //add child
    void addChild(Character *uChild);
    
    //remove child
    void removeChild(Character *uChild);
    
    //change last descendant
    void changeLastDescendant(Character *uNewLastDescendant);
    
    //is child a leaf
    bool isLeaf();
    
    //is child a root
    bool isRoot();
    
    
    
    //files used to loading the shader
    bool loadShaderFile(const char *szFile, GLuint shader);
    void loadShaderSrc(const char *szShaderSrc, GLuint shader);
    
    //method to decompress image
    bool convertImageToRawImage(const char *uTexture);
    
    //degree to rad
    inline float degreesToRad(float angle){return (angle*M_PI/180);};
    
};


#endif /* defined(__OpenGL_Template_CPLUSPLUS__Character__) */

#!/usr/bin/env python3
# -*- coding: utf-8 -*
# see examples below
# also read all the comments below.

import glfw
from OpenGL.GL import *

import os
import sys
import pdb  # use pdb.set_trace() for debugging
import code # or use code.interact(local=dict(globals(), **locals()))  for debugging.
import xml.etree.ElementTree as ET
import numpy as np
import math
from PIL import Image

#Calculate class
class CCalculateVector:
    def __init__(self):
        self.m_limit = 0.000000001

    def CalUnitVector(self, vec):
        return (1./np.sqrt(math.pow(vec[2], 2) + math.pow(vec[1], 2) + math.pow(vec[0], 2)))*vec

    def CalPixelVector(self, viewDir, imageHeight, imageWidth , heightPixelsize, widthPixelsize, distance, i, j, viewUp):
        xAxis = self.CalUnitVector(np.cross(viewDir, viewUp))
        yAxis = self.CalUnitVector(np.cross(viewDir, xAxis))
        vectorIndex = (distance * viewDir) + (-(imageWidth/2))*xAxis +(-(imageHeight)/2)*yAxis + ((imageWidth/widthPixelsize)/2)*xAxis + ((imageHeight/heightPixelsize)/2)*yAxis + ((imageWidth/widthPixelsize)*j)*xAxis + ((imageHeight/heightPixelsize)*i)*yAxis
        return self.CalUnitVector(vectorIndex)

    def CalEqual(self, value1, value2):
        if (abs(value1 - value2) < self.m_limit):
            return True
        else :
            False

    def CalDiscriminant(self, start_point, ray, radius):
        if(np.dot(start_point, ray)*np.dot(start_point, ray)-np.dot(start_point, start_point)+math.pow(radius ,2) < 0):
            return False
        else:
            return True

calVector = CCalculateVector()

#Shader class
class CShader:
    def __init__(self, name , type , diffuseColor, specularColor , exponent):
        self.m_name = name
        self.m_type = type
        self.m_diffuseColor = diffuseColor
        self.m_specularColor = specularColor
        self.m_exponent = exponent

#Light class
class CLight:
    def __init__(self , position, intensity):
        self.m_position = position
        self.m_intensity = intensity

class CBringSetting:
    def __init__(self, np_viewPoint, np_viewDir, np_viewUp, np_projNormal, np_viewWidth, np_viewHeight, np_projDistance):
        self.m_viewPoint = np_viewPoint
        self.m_viewDir = np_viewDir
        self.m_viewUp = np_viewUp
        self.m_projNormal = np_projNormal
        self.m_viewWidth = np_viewWidth
        self.m_viewHeight = np_viewHeight
        self.m_projDistance = np_projDistance
        self.m_light_arr = []

    def CameraSetiing(self, root):
        for c in root.findall('camera'):
                self.m_viewPoint =np.array(c.findtext('viewPoint').split()).astype(np.float)#point
                self.m_viewDir =calVector.CalUnitVector( np.array(c.findtext('viewDir').split()).astype(np.float))#vector
                self.m_projNormal = calVector.CalUnitVector( np.array(c.findtext('projNormal').split()).astype(np.float))
                self.m_viewUp = calVector.CalUnitVector(np.array(c.findtext('viewUp').split()).astype(np.float))
                np_tempViewWidth =np.array(c.findtext('viewWidth').split()).astype(np.float)#viewplane size
                np_tempViewHeight =np.array(c.findtext('viewHeight').split()).astype(np.float)#viewplane size
                if(c.findtext('projDistance')!=None):
                    temp_projDistance =np.array(c.findtext('projDistance').split()).astype(np.float)
                    self.m_projDistance = temp_projDistance[0]
                self.m_viewWidth = np_tempViewWidth[0]
                self.m_viewHeight = np_tempViewHeight[0]

    def ImageSizeSetting(self, root):
        return np.array(root.findtext('image').split()).astype(np.int)

    def ShaderSetting(self, root, shader_arr):
        for c in root.findall('shader'):
            shader_name_c = c.get('name')
            shader_type_c = c.get('type')
            diffuseColor_c = np.array(c.findtext('diffuseColor').split()).astype(np.float)
            if(shader_type_c == "Phong"):
                specularColor_c = np.array(c.findtext('specularColor').split()).astype(np.float)
                exponent_c = np.array(c.findtext('exponent').split()).astype(np.int)
            else:
                specularColor_c = np.array([0.,0.,0.])
                exponent_c = np.array([0])
            shader_arr[shader_name_c] = CShader(shader_name_c, shader_type_c, diffuseColor_c ,specularColor_c ,exponent_c)

    def LightSetting(self, root):
        for c in root.findall('light'):
            position_c = np.array(c.findtext('position').split()).astype(np.float)
            intensity_c = np.array(c.findtext('intensity').split()).astype(np.float)
            self.m_light_arr.append(CLight(position_c ,intensity_c))

#sphere class
class CSphere:
    def __init__(self , center , radius , shader_name):
        self.center = center
        self.radius = radius
        self.shader_name = shader_name

    def bCheckintersect(self, ray , eye_point):
        start_point = self.center - eye_point
        return calVector.CalDiscriminant(start_point, ray, self.radius)

    def InterSectSpherePoint(self, ray, eye_point):
        start_point = self.center-eye_point
        if((np.dot(start_point, ray)*np.dot(start_point, ray)-np.dot(start_point, start_point)+self.radius*self.radius) > 0):
            return np.dot(start_point,ray) -np.sqrt(np.dot(start_point,ray)*np.dot(start_point,ray)-np.dot(start_point,start_point)+self.radius*self.radius)
        else:
            return -1
    
    def GetNormalVector(self , surfacePoint , viewPoint):
        return calVector.CalUnitVector(surfacePoint - self.center)


#box class
class CBox:
    def __init__(self , minPoint , maxPoint , shader_name):
        self.m_minPoint = minPoint
        self.m_maxPoint = maxPoint
        self.shader_name = shader_name
        self.m_center = (1./2.)*(minPoint + maxPoint)
        self.m_min_t = 0
        self.m_max_t = 0
        self.m_min_y = 0
        self.m_max_y = 0
        self.m_min_z = 0
        self.m_max_z = 0

    def InterSectBoxPoint(self, ray, eye_point):
        if(ray[0] == 0. or ray[1] == 0. or ray[2] == 0.):
            return np.Infinity

        self.m_min_t = (self.m_minPoint[0] - eye_point[0])/ray[0]
        self.m_max_t = (self.m_maxPoint[0] - eye_point[0])/ray[0]
        if(self.m_min_t > self.m_max_t):
            self.m_min_t, self.m_max_t = self.m_max_t, self.m_min_t

        self.m_min_y = (self.m_minPoint[1] - eye_point[1])/ray[1]
        self.m_max_y = (self.m_maxPoint[1] - eye_point[1])/ray[1]
        if(self.m_min_y > self.m_max_y):
            self.m_min_y, self.m_max_y = self.m_max_y, self.m_min_y

        if(self.m_min_t > self.m_max_y or self.m_max_t < self.m_min_y):
            return np.Infinity

        if(self.m_min_t < self.m_min_y):
            self.m_min_t = self.m_min_y
        if(self.m_max_t > self.m_max_y):
            self.m_max_t = self.m_max_y

        self.m_min_z = (self.m_minPoint[2] - eye_point[2])/ray[2]
        self.m_max_z = (self.m_maxPoint[2] - eye_point[2])/ray[2]
        if(self.m_min_z >self.m_max_z):
            self.m_min_z, self.m_max_z = self.m_max_z, self.m_min_z

        if(self.m_min_t > self.m_max_z or self.m_max_t < self.m_min_z):
            return np.Infinity

        if(self.m_min_t < self.m_min_z):
            self.m_min_t = self.m_min_z
        if(self.m_max_t > self.m_max_z):
            self.m_max_t = self.m_max_z
        return self.m_min_t

    def GetNormalVector(self , surfacePoint , viewPoint):
        if(calVector.CalEqual(self.m_minPoint[0], surfacePoint[0])):
            if(np.dot(np.array([-1.,0.,0.]),(surfacePoint-self.m_center)) > 0):
               return np.array([-1.,0.,0.])
            else:
               return np.array([1,0,0])
        elif(calVector.CalEqual(self.m_maxPoint[0], surfacePoint[0])):
            if(np.dot(np.array([1.,0.,0.]),(surfacePoint-self.m_center)) > 0):
                  return np.array([1.,0.,0.])
            else:
                  return np.array([-1,0,0])
        elif(calVector.CalEqual(self.m_minPoint[1], surfacePoint[1])):
            if(np.dot(np.array([0.,-1.,0.]),(surfacePoint-self.m_center)) > 0):
                  return np.array([0.,-1.,0.])
            else:
                  return np.array([0,1,0])
        elif(calVector.CalEqual(self.m_maxPoint[1], surfacePoint[1])):
            if( np.dot(np.array([0.,1.,0.]) , (surfacePoint - self.m_center)) > 0):
                  return np.array([0.,1.,0.])
            else:
                  return np.array([0,-1,0])
        elif(calVector.CalEqual(self.m_minPoint[2], surfacePoint[2])):
            if(np.dot(np.array([0,0.,-1]),(surfacePoint-self.m_center)) > 0):
                return np.array([0,0.,-1])
            else:
                return np.array([0,0,1])
        elif(calVector.CalEqual(self.m_maxPoint[2], surfacePoint[2])):
            if(np.dot(np.array([0,0,1]),(surfacePoint-self.m_center))>0):
                return np.array([0,0,1])
            else:
                return np.array([0,0,-1])

class CDrawShape(CSphere, CBox):
    def __init__(self):
        self.m_surfaceType = None
        self.m_sphereArray = []
        self.m_boxArray = []
        self.m_numSphere = 0
        self.m_numBox = 0
        self.m_shapeT = np.Infinity
        self.m_surfaceP = None
        self.m_randered = None

    def SurfaceSetting(self, root):
        for c in root.findall('surface'):
            self.m_surfaceType = c.get('type')
            for b in c.iter('shader'):
                ref_c = b.get('ref')
            if(self.m_surfaceType == 'Sphere'):#sphere 일때
                center_c = np.array(c.findtext('center').split()).astype(np.float)
                radius_c = np.array(c.findtext('radius').split()).astype(np.float)
                self.m_sphereArray.append(CSphere(center_c , radius_c[0] , ref_c ))
            elif(self.m_surfaceType == 'Box'):#box 일때
                minPt_c = np.array(c.findtext('minPt').split()).astype(np.float)
                maxPt_c = np.array(c.findtext('maxPt').split()).astype(np.float)
                self.m_boxArray.append(CBox(minPt_c, maxPt_c, ref_c ))

    def GetSurface(self, arraySphere, arrayBox, pixelVector, viewPoint):
        self.m_shapeT = np.Infinity
        for sphere in np.arange(len(arraySphere)):
            if(arraySphere[sphere].bCheckintersect(pixelVector,viewPoint)):   
                if(self.m_shapeT > arraySphere[sphere].InterSectSpherePoint(pixelVector,viewPoint)):
                    self.m_shapeT = arraySphere[sphere].InterSectSpherePoint(pixelVector,viewPoint)
                    self.m_surfaceP = (self.m_shapeT*pixelVector)+viewPoint
                    self.m_randered = arraySphere[sphere]

        for box in np.arange(len(arrayBox)):
            if(self.m_shapeT > arrayBox[box].InterSectBoxPoint(pixelVector , viewPoint)):
                self.m_shapeT = arrayBox[box].InterSectBoxPoint(pixelVector , viewPoint)
                self.m_surfaceP = (self.m_shapeT*pixelVector)+viewPoint
                self.m_randered = arrayBox[box]

    def CheckBlockFlag(self, light, surfacep, type):
        if type == 'Sphere':
            for sphere in np.arange(self.m_numSphere):
                if(self.m_sphereArray[sphere].InterSectSpherePoint(light, surfacep) > 0 and self.m_sphereArray[sphere].InterSectSpherePoint(light, surfacep) != np.Infinity):
                    return True
        elif type == 'Box':
            for box in np.arange(self.m_numBox):
                if(self.m_boxArray[box].InterSectBoxPoint(light, surfacep) > 0 and self.m_boxArray[box].InterSectBoxPoint(light, surfacep) != np.Infinity):
                    return True
        return False


class Color:
    def __init__(self, R, G, B):
        self.color=np.array([R,G,B]).astype(np.float)
    # Gamma corrects this color.
    # @param gamma the gamma value to use (2.2 is generally used).
    def gammaCorrect(self, gamma):
        inverseGamma = 1.0 / gamma
        self.color=np.power(self.color, inverseGamma)

    def toUINT8(self):
        return (np.clip(self.color, 0,1)*255).astype(np.uint8)

def main():
    tree = ET.parse(sys.argv[1])
    root = tree.getroot()
    # set default values
    viewDir=np.array([0,0,-1]).astype(np.float)
    viewUp=np.array([0,1,0]).astype(np.float)
    ProjNormal=-1*viewDir  # you can safely assume this. (no examples will use shifted
    viewWidth=1.0
    viewHeight=1.0
    projDistance=1.0
    intensity=np.array([1,1,1]).astype(np.float)  # how bright the light is.
    viewPoint = np.array([0, 0, 0])
    imgSize = 0

    #Default Setting
    m_BringSetting = CBringSetting(viewPoint, viewDir, viewUp, ProjNormal, viewWidth, viewHeight, projDistance)

    #Camera
    m_BringSetting.CameraSetiing(root)
    viewPoint = m_BringSetting.m_viewPoint
    viewDir = m_BringSetting.m_viewDir
    ProjNormal = m_BringSetting.m_projNormal
    viewUp = m_BringSetting.m_viewUp
    viewWidth = m_BringSetting.m_viewWidth
    viewHeight = m_BringSetting.m_viewHeight
    projDistance = m_BringSetting.m_projDistance

    #Image Size
    imgSize = m_BringSetting.ImageSizeSetting(root)

    #Shader
    shaderArray = {}
    m_BringSetting.ShaderSetting(root, shaderArray)

    #Surface
    drawShape = CDrawShape()
    drawShape.SurfaceSetting(root)
    if(drawShape.m_surfaceType == 'Sphere'):
        drawShape.m_numSphere = len(drawShape.m_sphereArray)
    elif(drawShape.m_surfaceType == 'Box'):
        drawShape.m_numBox = len(drawShape.m_boxArray)
    
    #Light
    m_BringSetting.LightSetting(root)

    # Create an empty image
    channels=3
    img = np.zeros((imgSize[1], imgSize[0], channels), dtype=np.uint8)
    img[:,:]=0
    
    # replace the code block below!
    for y_axis in np.arange(imgSize[1]):
        for x_axis in np.arange(imgSize[0]):
            
            pixelVector = calVector.CalPixelVector(viewDir, viewHeight, viewWidth, imgSize[1], imgSize[0], projDistance, y_axis, x_axis, viewUp)
            PixelColor = np.array([0,0,0])
            ColorRGB =np.array([0,0,0])
            
            drawShape.GetSurface(drawShape.m_sphereArray, drawShape.m_boxArray, pixelVector, viewPoint)

            if (drawShape.m_randered is not None and drawShape.m_surfaceP is not None):
                SurfaceN = drawShape.m_randered.GetNormalVector(drawShape.m_surfaceP,viewPoint)
                PixelShader = shaderArray[drawShape.m_randered.shader_name]
            else:
                PixelShader = None
            
            if(drawShape.m_shapeT != np.Infinity):
                for v in np.arange(len(m_BringSetting.m_light_arr)):
                    Light = calVector.CalUnitVector(m_BringSetting.m_light_arr[v].m_position - drawShape.m_surfaceP)
                    bSphereBlock = drawShape.CheckBlockFlag(Light, drawShape.m_surfaceP, 'Sphere')
                    if (bSphereBlock == False):
                        bBoxBlock = drawShape.CheckBlockFlag(Light, drawShape.m_surfaceP, 'Box')
                        if(bBoxBlock == False):
                            if(PixelShader.m_type == "Phong"):
                                ColorRGB = max(0,np.dot(SurfaceN,Light)) * m_BringSetting.m_light_arr[v].m_intensity *PixelShader.m_diffuseColor + math.pow((max(0,np.dot(SurfaceN,calVector.CalUnitVector(Light - viewDir)))), PixelShader.m_exponent[0]) * m_BringSetting.m_light_arr[v].m_intensity*PixelShader.m_specularColor
                            elif(PixelShader.m_type == "Lambertian"):
                                ColorRGB = max(0,np.dot(SurfaceN,Light)) * m_BringSetting.m_light_arr[v].m_intensity *PixelShader.m_diffuseColor
                        else:
                            ColorRGB = np.array([0,0,0])
                    
                    PixelColor = PixelColor + ColorRGB
            
            color = Color(PixelColor[0] ,PixelColor[1], PixelColor[2])
            color.gammaCorrect(2.2)
            img[y_axis][x_axis]=color.toUINT8()

    rawimg = Image.fromarray(img, 'RGB')
    rawimg.save('out.png')
    rawimg.save(sys.argv[1]+'.png')
    
if __name__=="__main__":
    main()
# This script demonstrate the Assignment of the ArcGIS+Python topic
#
# by Zorigt Munkhjargal
#
# File: Assignment.py

###
# Section 1: Import module/Load licences
###

import arcpy
from arcpy import env
from arcpy.sa import *

arcpy.AddMessage(arcpy.ListEnvironments())
arcpy.AddMessage(env.workspace)
arcpy.AddMessage(env.overwriteOutput)

arcpy.CheckOutExtension("Spatial")

###
# Section 2: Set-up Environment + Parameter and set variables
###
arcpy.env.overwriteOutput = True
###arcpy.env.workspace = "C:Assignment ARCGIS.gdb"



# 2.1 Get parameters
theBoundary = arcpy.GetParameterAsText(0)
theCont = arcpy.GetParameterAsText(1)
theSpot = arcpy.GetParameterAsText(2)
#theClipLayer = arcpy.GetParameterAsText(3)
#theLayerList = arcpy.GetParameterAsText(4)
#theWorkspace = arcpy.GetParameterAsText(5)


# 2.2 Set local variables
theBnd = "Boundary"
arcpy.CopyFeatures_management(theBoundary, theBnd)


# 2.3 Create output variables for names
theClipCont = "Contours_clip"
theClipSpot = "Spotheight_clip"
theDEM = "DEM"
theFDir = "FlowDirection"
theFAccum = "FlowAccum"
theSOrder = "stream_order"
theSOrderMethod = "STRAHLER"
theStreamsPolyline = "Streams_Poly"
theStreamNetwork = "StreamToFeature"

###
# Section 3: Search cursor and loop
###


theSearchCursor = arcpy.SearchCursor(theBoundary)
for rec in theSearchCursor:
    theCatName = rec.getValue('CATNAME')
    arcpy.AddMessage(theCatName)
desc = arcpy.Describe(theBoundary)


# First check if variable exists then print the Describe Object properties
#
if hasattr(desc, "name"):
    arcpy.AddMessage( "Name:        " + desc.name)
if hasattr(desc, "dataType"):
    arcpy.AddMessage("Data Type:    " + desc.dataType)
if hasattr(desc, "featureType"):
    arcpy.AddMessage("Feature Type:    " + desc.featureType)
if hasattr(desc, "shapeType"):
    arcpy.AddMessage("Shape Type:    " + desc.shapeType)
if hasattr(desc, "catalogPath"):
    arcpy.AddMessage("Catalog Path: " + desc.catalogPath)


###
# Section 4: Create DEM
###


try:
    # Clip out contours
    arcpy.Clip_analysis(theCont, theBnd, theClipCont)
    arcpy.Clip_analysis(theSpot, theBnd, theClipSpot)

    # Set topo variables
    inContours = TopoContour([[theClipCont, "ELEVATION"]])
    inSpotHeight = TopoPointElevation([[theClipSpot, "ELEVATION"]])
    inBoundary = TopoBoundary([theBnd])
    inFeatures = [inContours, inSpotHeight, inBoundary]

    # Create DEM
    arcpy.AddMessage("Creating DEM")
    outTTR = TopoToRaster(inFeatures)

    # Fill DEM and save
    arcpy.AddMessage("Running fill")
    outFill = Fill(outTTR)
    outFill.save(theDEM)

    # Flow direction and save
    arcpy.AddMessage("Creating Flow Direction")
    outFDir = FlowDirection(theDEM)
    outFDir.save(theFDir)

    # Flow accumulation and save
    arcpy.AddMessage("Creating Flow Accumulation")
    outFAccum = FlowAccumulation(outFDir)
    outFAccum.save(theFAccum)

    # Create streem threshold
    arcpy.AddMessage("Creating Stream raster")
    outStream = Con(outFAccum > 1000, 1)
    # outStream.save("stream")

    # Create stream order
    outSOrder = StreamOrder(outStream, outFDir, theSOrderMethod)
    outSOrder.save(theSOrder)

    # Create streams polyline
    StreamToFeature(outSOrder, outFDir, theStreamsPolyline, "SIMPLIFY")

except:
    arcpy.AddWarning(arcpy.GetMessages())




###
# Section 5: Clip Layer
###


def clipRaster(layer, name):
    # clip raster by mask
    arcpy.AddMessage("Processing layer " + name)
    outExtractByMask = arcpy.sa.ExtractByMask(layer, theBoundary)
    outExtractByMask.save(name)
    arcpy.AddMessage("Completed layer " + name)


def clipVector(layer, name):
    # clip vector layer
    arcpy.AddMessage("Processing layer " + name)
    arcpy.analysis.Clip(layer, theBoundary, name)
    arcpy.AddMessage("Completed layer " + name)


for l in inFeatures:
    desc = arcpy.Describe(l)
    dataType = desc.dataType
    arcpy.AddMessage(dataType)
    name = str(l).translate({ord(c): "_" for c in " !@#$%^&*()[]{};:,./<>?\|`~-=_+"})
    if dataType == 'RasterDataset' or dataType == 'RasterLayer':
        clipRaster(l, name)
    if dataType == 'FeatureClass' or dataType == 'FeatureLayer':
        clipVector(l, name)

###
# Section 6: Make File Geodatabase
###

thePath = arcpy.Describe(arcpy.env.workspace).path
arcpy.CreateFileGDB_management(thePath, "fGDB")


###
# Section 5: Clip Layer
###

def clipRaster(layer, name):
    # clip raster by mask
    arcpy.AddMessage("Processing layer " + name)
    outExtractByMask = arcpy.sa.ExtractByMask(layer, theBoundary)
    outExtractByMask.save(name)
    arcpy.AddMessage("Completed layer " + name)


def clipVector(layer, name):
    # clip vector layer
    arcpy.AddMessage("Processing layer " + name)
    arcpy.analysis.Clip(layer, theBoundary, name)
    arcpy.AddMessage("Completed layer " + name)


for l in theCont:
    desc = arcpy.Describe(l)
    dataType = desc.dataType
    arcpy.AddMessage(dataType)
    name = str(l).translate({ord(c): "_" for c in " !@#$%^&*()[]{};:,./<>?\|`~-=_+"})
    if dataType == 'RasterDataset' or dataType == 'RasterLayer':
        clipRaster(l, name)
    if dataType == 'FeatureClass' or dataType == 'FeatureLayer':
        clipVector(l, name)

    ###
    # Section 6: Make File Geodatabase
    ###
    thePath = arcpy.Describe(arcpy.env.workspace).path
    arcpy.CreateFileGDB_management(thePath, theBoundary)

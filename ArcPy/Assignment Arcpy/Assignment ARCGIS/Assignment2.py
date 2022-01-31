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
arcpy.env.workspace = "Assignment ARCGIS.gdb"



# 2.1 Get parameters
theBoundary = arcpy.GetParameterAsText(0)
theCont = arcpy.GetParameterAsText(1)
theSpot = arcpy.GetParameterAsText(2)


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

###
# Section 4: Create DEM
###


try:
    # Clip out layers
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

    # Create stream threshold
    arcpy.AddMessage("Creating Stream raster")
    outStream = Con(outFAccum > 1000, 1)
    outStream.save("stream")

    # Create stream order
    outSOrder = StreamOrder(outStream, outFDir, theSOrderMethod)
    outSOrder.save(theSOrder)

    # Create streams polyline
    StreamToFeature(outSOrder, outFDir, theStreamsPolyline, "SIMPLIFY")


except:
    arcpy.AddWarning(arcpy.GetMessages())



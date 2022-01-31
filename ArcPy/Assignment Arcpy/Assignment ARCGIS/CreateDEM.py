# This script demonstrate the Assignment of the ArcGIS+Python topic
#
# by Zorigt Munkhjargal
#
# File: Assignment.py

###


import arcpy
from arcpy import env


# Check out any necessary licenses
arcpy.CheckOutExtension("Spatial")

# Get parameters
theBoundary = arcpy.GetParameterAsText(0)
theCont = arcpy.GetParameterAsText(1)
theSpot = arcpy.GetParameterAsText(2)

# Set env variables
env.overwriteOutput = True

# Set local variables
theBnd = "Boundary"
arcpy.CopyFeatures_management(theBoundary, theBnd)

# Create output variables for names
theClipCont = "Contours_clip"
theClipSpot = "Spotheight_clip"
theDEM = "DEM"
theFDir = "FlowDirection"
theFAccum = "FlowAccum"
theSOrder = "stream_order"
theSOrderMethod = "STRAHLER"
theStreamsPolyline = "Streams"

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

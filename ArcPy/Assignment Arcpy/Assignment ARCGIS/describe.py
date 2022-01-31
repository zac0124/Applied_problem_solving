# This script demonstrate the Assignment of the ArcGIS+Python topic
#
# by Zorigt Munkhjargal
#
# File: Assignment.py

###

import arcpy

# Create a Describe object
#
theLayer = arcpy.GetParameterAsText(0)

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

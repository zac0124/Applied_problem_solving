# This script demonstrate the Assignment of the ArcGIS+Python topic
#
# by Zorigt Munkhjargal
#
# File: Assignment.py

###

import arcpy

theLayer = arcpy.GetParameterAsText(0)

theSearchCursor = arcpy.SearchCursor(theLayer)
for rec in theSearchCursor:
    theCatName = rec.getValue('CATNAME')
    arcpy.AddMessage(theCatName)
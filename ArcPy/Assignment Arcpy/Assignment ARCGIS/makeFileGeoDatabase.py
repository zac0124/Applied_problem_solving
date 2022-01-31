# This script demonstrate the Assignment of the ArcGIS+Python topic
#
# by Zorigt Munkhjargal
#
# File: Assignment.py

###

import arcpy

theName = arcpy.GetParameterAsText(0)

thePath = arcpy.Describe(arcpy.env.workspace).path

arcpy.CreateFileGDB_management(thePath, theName)
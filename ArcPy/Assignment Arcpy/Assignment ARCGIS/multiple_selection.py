# This script demonstrate the Assignment of the ArcGIS+Python topic
#
# by Zorigt Munkhjargal
#
# File: multiple_selection.py

###

### 1. Import module

import arcpy

arcpy.AddMessage(arcpy.ListEnvironments())
arcpy.AddMessage(env.workspace)
arcpy.AddMessage(env.overwriteOutput)

arcpy.env.overwriteOutput = True

theCatchmentLayer = arcpy.GetParameterAsText(0)
theSearchCursor = arcpy.SearchCursor(theCatchmentLayer)
for rec in theSearchCursor:
    theDatabase = rec.getValue('theClipCont')
    arcpy.AddMessage(theDatabase)


### 2. Set-up environment
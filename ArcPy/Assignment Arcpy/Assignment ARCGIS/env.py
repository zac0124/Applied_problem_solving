# This script demonstrate the Assignment of the ArcGIS+Python topic
#
# by Zorigt Munkhjargal
#
# File: Assignment.py

###

# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.


def print_hi(name):
    # Use a breakpoint in the code line below to debug your script.
    print(f'Hi, {name}')  # Press ⌘F8 to toggle the breakpoint.


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    print_hi('PyCharm')

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
import arcpy
from arcpy import env

arcpy.AddMessage(arcpy.ListEnvironments())
arcpy.AddMessage(env.workspace)
arcpy.AddMessage(env.overwriteOutput)

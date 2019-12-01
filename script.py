# these commands get executed in the current scope
# of each new shell (but not for canned commands)
#pylint: disable=all
import clr
import csv
clr.AddReference('RevitApi')
from Autodesk.Revit.DB import *
clr.AddReference('RevitServices')
import RevitServices
from RevitServices.Persistence import DocumentManager
doc = __revit__.ActiveUIDocument.Document	

clr.AddReferenceByPartialName('PresentationCore')
clr.AddReferenceByPartialName("PresentationFramework")
clr.AddReferenceByPartialName('System')
clr.AddReferenceByPartialName('System.Windows.Forms')

from Autodesk.Revit import DB
from Autodesk.Revit import UI

# creates variables for selected elements in global scope
# e1, e2, ...
max_elements = 5
gdict = globals()
uidoc = __revit__.ActiveUIDocument
if uidoc:
    doc = __revit__.ActiveUIDocument.Document
    selection = [doc.GetElement(x) for x in uidoc.Selection.GetElementIds()]
    for idx, el in enumerate(selection):
        if idx < max_elements:
            gdict['e{}'.format(idx+1)] = el
        else:
            break

# alert function
def alert(msg):
    TaskDialog.Show('RPS', msg)

# quit function
def quit():
    __window__.Close()

import json

SmokeDetectorLocations=[]
print('Smoke')
Rl=FilteredElementCollector(doc)
Rl.OfCategory(BuiltInCategory.OST_FireAlarmDevices)
Rl.WhereElementIsNotElementType()
for el in Rl:
	SmokeDetectorLocations.append(el.Location.Point)

print('rooms')
Rl=FilteredElementCollector(doc)
Rl.OfCategory(BuiltInCategory.OST_Rooms)
Rl.WhereElementIsNotElementType()

SD_List=[]
for el in Rl:
	temp=0
	
	room_li=[el.Location.Point[0],el.Location.Point[1],el.Location.Point[2]]
	smoke_li=[]
	for coord in SmokeDetectorLocations:
		if el.IsPointInRoom(XYZ(coord[0],coord[1],(coord[2]-5))):
			temp+=1
			smoke_li.append([coord[0],coord[1],coord[2]])
	
	#SD_Dict[el.LookupParameter('Number').AsString()]=\
	SD_List.append(
	{'Room_Number':el.LookupParameter('Number').AsString(),
	'Building_Occupancy':'Medical Building',
    'Fire_Sprinkler':'Yes',
	'Room_Name':el.LookupParameter('Name').AsString(),
	'Room_Area':el.LookupParameter('Area').AsDouble(),
	#'Room_Perimeter':el.LookupParameter('Perimeter').AsDouble(),
	#'Room Coordinates': room_li,\
	#'Smoke Detector Coordinates': smoke_li,\
	'Smoke_Detector': temp}) 

SD_Dict={"SD_Location":{"Room_Details":SD_List}}	
j=json.dumps(SD_Dict,indent=2)

j2=json.dumps(SD_List,indent=2)

with open('data1-json.json','w') as f:
	f.write(j2)
	f.close()

with open('SmokeDetector_Dictionary.json','w') as f:
	f.write(j)
	f.close()

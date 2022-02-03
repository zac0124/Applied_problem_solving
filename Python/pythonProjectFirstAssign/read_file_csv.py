import os
import csv




# with open(os.path.join("Data","country_latlon.csv"),"r") as csvfile:
#         for row in csvfile:
#             print(row)

latlon = {}
with open(os.path.join("Data", "country_latlon.csv"), "r") as csvfile:
        csvreader = csv.reader(csvfile)
        for row in csvreader:
            if len(row) !=6:
                continue
            if row[0] == "Country":
                continue
            latlon[row[2]] = (float(row[4]), float(row[5]))
# i=0
# for country in latlon:
#     i+=1
#     if i == 10:
#         break
#     print("{}: {}".format(country, latlon[country]))

countries = sorted(list(latlon.keys()))
for c in countries[0:10]:
    print("{}: {}".format(c, latlon[c]))
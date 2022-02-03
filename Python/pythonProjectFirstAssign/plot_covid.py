import os
import csv
from typing import List, Any

import matplotlib.pyplot as plt
import seaborn as sns
from datetime import date

countrycovid = {}
with open(os.path.join("covid_data", "data.csv"), "r") as csvfile:
    csvreader = csv.reader(csvfile)
    for row in csvreader:
        if row[0] == "dateRep":
            continue
        d = date(int(row[3]), int(row[2]), int(row[1]))
        if row[8] not in countrycovid:
            countrycovid[row[8]] = {}
        if row[-1] =='':
            continue
        countrycovid[row[8]][d] = float(row[-1])
testcountry= 'MNG'
testcountry2='AUS'
testcountry3='JPN'
dates = sorted(countrycovid[testcountry].keys())
cases = [countrycovid[testcountry][d] for d in dates]
cases2 = [countrycovid[testcountry2][d] for d in dates]
cases3 = [countrycovid[testcountry3][d] for d in dates]
ax = sns.scatterplot(x=dates, y=cases, color= 'black', label=testcountry)
sns.scatterplot(x=dates, y=cases2, color= 'red', label = testcountry2)
sns.scatterplot(x=dates, y=cases3, color= 'blue', label = testcountry3)
#sns.scatterplot(x=dates, y=cases2, ax=ax)
ax.set_title("COVID cases comparison in 2020")
ax.set_ylabel("14 day moving average of cases")
ax.set_xlabel("COVID Date")
plt.legend(loc='center left', bbox_to_anchor=(1.0, 0.5))
plt.tight_layout()
plt.gcf().autofmt_xdate()
plt.show()



















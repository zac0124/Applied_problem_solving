import os
import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
import plotly.graph_objects as go
import datetime



df = pd.read_csv(os.path.join("data_map", "data.csv"),
                 doublequote=True,
                 skipinitialspace=True
                 )
df[(df['dateRep']> "24/01/20") & (df['dateRep']< "24/01/20")]

fig= go.Figure(data = go.Choropleth(
    locations= df['countryterritoryCode'],
    z= df ['Cumulative_number_for_14_days_of_COVID-19_cases_per_100000'],
    text= df ['countriesAndTerritories'],
    colorscale='earth',
    autocolorscale= False,
    reversescale= True,
    marker_line_color= 'black',
    marker_line_width= .5,
    colorbar_title = 'COVID spread 2020',
))

fig.show()



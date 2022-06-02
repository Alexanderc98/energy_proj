# Exploratory analysis of energy data from a select portfolio of City-owned buildings in NYC

* Created a tableau dashboard: https://public.tableau.com/app/profile/alexander4055/viz/energy_proj/Dashboard1
* Used advanced SQL techniques to explore the data.
* Created a database in third normal form with sqlite3 package in python.
* Performed data cleaning in R and microsoft excel.

## Code and Resources Used
**Data:** https://data.cityofnewyork.us/Environment/Energy-Usage-From-DOE-Buildings/mq6n-s45c

**Python Version:** 3.79

**R Version:** 4.1.3

**SQLite Version:** 3.31.0

**Tableau Public Version:** 2022.1.2

**Packages:** stringr, pandas, sqlite3

## Data Cleaning
After downloading the data, I made the following changes and created the following variables:

* Removed unnecessary columns needed to conduct my analysis
* Renamed columns so their name better reflect the content
* Transformed the data so that dates were rows and not columns
* Feature engineered the building name from the adress column
* Separated the data to four different sheets and removed duplicates in microsoft excel, so that I could create a great relational database

## EDA
Below are a few highlights of my exploratory analysis.

![alt text](https://github.com/Alexanderc98/energy_proj/blob/main/pictures/state_owned_buildings_visualised.PNG "state_owned_buildings_visualised")


![alt text](https://github.com/Alexanderc98/energy_proj/blob/main/pictures/average_monthly_electricity_bill_per_borough_with_usd.PNG "average_monthly_electricity_bill_per_borough")


![alt text](https://github.com/Alexanderc98/energy_proj/blob/main/pictures/average_yearly_energy_bill_per_building.PNG "average_yearly_energy_bill_per_building")



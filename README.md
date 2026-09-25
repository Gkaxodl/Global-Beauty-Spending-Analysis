# Global Beauty Spending & Socioeconomic Factors

An interactive R Shiny project exploring how beauty spending varies with economic development, gender inequality, and female labor force participation across 50 countries.

## Project Overview

This project examines whether countries with similar economic and gender conditions still differ in beauty-related spending. It combines country-level socioeconomic indicators with beauty spending estimates and provides an interactive Shiny dashboard for exploring cross-country and regional patterns.

**Project Type:** Academic Final Project  
**Course:** DATS 2102 / PSC 2102, The George Washington University  
**Data Year:** 2023  
**Countries:** 50

## Research Question

Do countries with similar levels of economic development and gender equality still differ in beauty spending, and what regional patterns appear in the data?

## Data & Variables

The analysis uses the following country-level variables:

- GDP per capita
- Gender Inequality Index (GII)
- Female Labor Force Participation Rate (FLFPR)
- Beauty spending per capita
- Beauty spending as a percentage of household income
- Continent / region

Official socioeconomic indicators were drawn from the World Bank, UNDP, and ILOSTAT. Beauty-spending variables were manually compiled for the original academic project from figures reported across Statista and other market reports. Because these values combine multiple secondary sources, they should be treated as project-level estimates rather than a standardized official dataset.

## Interactive Dashboard

The R Shiny app allows users to:

- Select economic or gender-related variables for comparison
- Compare beauty spending across regions
- Filter countries by continent
- Explore scatter plots with trend lines and descriptive Pearson correlations
- Compare regional distributions with box plots
- Explore GDP, beauty spending, and labor-force participation together with a bubble chart

## Technologies

R · Shiny · ggplot2 · dplyr · readr · viridis · ggrepel

## Repository Structure

```text
Global-Beauty-Spending-Analysis/
├── app.R
├── data/
│   └── beauty_data_final_50.csv
└── README.md
```

## Running the App

Install the required packages if needed:

```r
install.packages(c("shiny", "dplyr", "readr", "ggplot2", "viridis", "ggrepel"))
```

Then run:

```r
shiny::runApp()
```

## Key Findings

The exploratory analysis suggested that higher-income countries generally had higher beauty spending per capita, while lower-income countries often devoted a larger share of income to beauty spending. Regional differences remained visible even among countries with similar economic or gender indicators.

These patterns should be interpreted as exploratory associations rather than causal effects.

## Limitations

- The dataset contains one year (2023), so it does not measure changes over time.
- Beauty-spending data were manually compiled from multiple secondary market sources and may not be fully consistent across countries.
- The included CSV is a small project dataset assembled for academic analysis; source providers retain rights to their original publications and underlying materials.
- The sample includes 50 countries and does not represent every country.
- Broad regional categories may hide important within-region differences.
- Observed relationships are descriptive and do not establish causation.

## Author

**Andrew Ham**  
Data Science, The George Washington University

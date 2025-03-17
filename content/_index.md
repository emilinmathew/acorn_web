---
title: "Environmental and Structural Drivers of Acorn Production in Coast Live Oak"
authors: "Emilin Mathew"
output: html_document
---

![Team Purple](/images/jasper.png)

# Abstract
Acorn production in Quercus agrifolia (Coast Live Oak) is influenced by multiple environmental and structural factors, yet the extent of these influences remains unclear. We hypothesized that (1) the south-facing sides of trees would produce more acorns due to greater sunlight exposure, (2) trees with larger diameters at breast height (DBH) and greater crown diameters would have higher acorn production, and (3) acorn yield would decrease with lower vegetation density. We measured acorn production using quadrat sampling, analyzed the tree's structural attributes, and assessed vegetation density through the Normalized Difference Vegetation Index (NDVI). Our results indicated weak correlations between acorn yield and all tested variables, with p-values exceeding 0.05 and low R² values, suggesting these factors do not significantly correlate to acorn production. The findings highlight the complexity of acorn yield dynamics, likely influenced by unmeasured factors such as genetic variability, soil composition, and masting cycles. Future research with larger sample sizes and refined environmental metrics is needed to improve predictive models. These insights contribute to oak conservation efforts and understanding of acorn availability for wildlife.

# Methods
## Study Area
This study was conducted at Jasper Ridge Biological Preserve (‘Ootchamin ‘Ooyakma), a protected ecological research site in the eastern foothills of the Santa Cruz Mountains in Woodside, California (Figure 1). The preserve spans approximately 1,198 acres and has various habitats, including oak woodlands, chaparral, and grasslands. The Mediterranean climate in the preserve also provides natural variations in sunlight exposure, soil moisture, and vegetation density, making it an ideal location to assess the environmental and structural drivers of acorn production. 

## Data Collection
We collected data from 16 mature coast live oak trees within the preserve in January of Winter 2024 and 2025. These trees were healthy, free from major diseases, and of varying sizes. The structural measurements we took from each tree were diameter at breast height (DBH), crown diameters, and canopy exposures. DBH was measured at 1.4 m above the ground using diameter tape. The DBH of the three largest trunks was recorded for trees with multiple trunks, and one final DBH was taken from such trees by taking the square root of the sum of all three DBHs. We measured two central diameters: (1) the diameter of the maximum axis and (2) the axis perpendicular to the maximum axis. We acquired acorn production measurements using the quadrat method. The quadrats, which measured 62cm x 62cm, were placed in each cardinal direction of the focal tree, ensuring that the quadrat was aligned to the edge of the tree crown. Only acorn caps within the quadrats were counted and incorporated into the dataset to prevent double counting. Additionally, we incorporated the Normalized Difference Vegetation Index (NDVI) from the Sentinel-2 satellite for the 2024 and 2025 winter seasons to obtain vegetation density near our 16 trees. 

## Data Analysis
To assess the impact of cardinal direction on acorn production, we ran a paired t-test to compare the difference between acorn production on the north and south sides of the trees; we controlled for year-to-year variation by using a linear mixed-effects model to account for both fixed, such as the year, and random effects. We used simple linear regression to understand correlations between the DBH or crown diameter and acorn production. We then incorporated these findings into a multiple linear regression to assess the impact of DBH and crown diameter on acorn production. Additionally, we analyzed the impact of vegetation density on acorn production using simple linear regression and a linear mixed-effects model to account for both fixed and random effects. 


# Overview of Results
Acorn production across 2024 and 2025 demonstrated minimal correlations with tree size metrics, NDVI index, and regional grouping. Box plots of acorn count across groups showed no statistically significant differences between each tree's North and South regions, with all p-values exceeding 0.1. Analysis of tree size metrics, including DBH and crown diameters, revealed weak correlations with total acorn production, with R² values below 0.07 and p-values consistently above 0.3. Similarly, 3D regression analysis of acorn production against DBH and average crown diameter in 2024 and 2025 indicated weak explanatory power (R² = 0.073 and 0.07, respectively), emphasizing the limited predictive utility of these variables. Finally, the relationship between acorn production and the NDVI across 2024, 2025, and combined years also demonstrated minimal correlation, with low R² values (0.005 to 0.045) and high p-values (p > 0.4). 

## Relationship Between Cardinal Direction & Acorn Production


<img src="/_index_files/figure-html/plot-card-1.png" width="672" />

## Relationship Between NDVI and Acorn Production
This analysis examines the relationship between NDVI (Normalized Difference Vegetation Index) and acorn production across two years (2024 and 2025).



### NDVI vs Acorn Production (2024)

<img src="/_index_files/figure-html/plot-2024-1.png" width="672" />

### NDVI vs Acorn Production (2025)

<img src="/_index_files/figure-html/plot-2025-1.png" width="672" />

### Combined Analysis (2024 & 2025)

<img src="/_index_files/figure-html/plot-combined-1.png" width="672" />

### Statistical Summary


```
## 2024 Model: R² = 0.043 , p-value = 0.44
```

```
## 2025 Model: R² = 0.045 , p-value = 0.433
```

```
## Combined Mixed Model: R² = 0.005 , p-value = 0.806
```

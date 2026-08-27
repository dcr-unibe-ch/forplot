# Demonstration data set with continous outcomes

Simulated summary data from 10 outcomes to be presented in a forest
plot. Each row represents the summary of one outcome variable for two
treatment groups with columns for the variable name (vlabel), number of
observations and mean (sd) for each group (n1, n2, n3 and n4), the
difference between groups with 95% CI as a formatted text column
(beta_format) and as numeric variables to draw the forest (beta,
beta_lci, beta_uci), and a p-value (p1)

## Usage

``` r
forplotdata
```

## Format

A data frame with 10 columns: `vlabel`, `n1`, `n2`, `n3`, `n4`,
`beta_format`, `beta`, `beta_lci`, `beta_uci` and `p1`.

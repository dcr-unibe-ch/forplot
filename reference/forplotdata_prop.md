# Demonstration data set with binary outcomes

Simulated summary data from 10 outcomes to be presented in a forest
plot. Each row represents the summary of one outcome variable for two
treatment groups with columns for the variable name (vlabel), number of
observations and n (%) for each group (n1, n2, n3 and n4), the crude
proporion in each group (prop1, prop2) the risk difference between
groups (beta), with 95% CI (beta_lci and beta_uci), the formatted risk
differnce (beta_format) and a p-value (p1)

## Usage

``` r
forplotdata_prop
```

## Format

A data frame with 12 columns: `vlabel`, `n1`, `n2`, `n3`, `n4`, `prop1`,
`prop2`, `beta`, `beta_lci`, `beta_uci`, `beta_format` and `p1`.

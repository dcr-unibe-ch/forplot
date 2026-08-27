# Modify boxplot (b) items of a forest plot object (fobj).

Passed to [`boxplot`](https://rdrr.io/r/graphics/boxplot.html).

## Usage

``` r
b_boxplot(fobj, item = NULL, ...)
```

## Arguments

- fobj:

  a forest plot object of class 'fobj'

- item:

  item to be modified, either a number or the name of the column in
  fobj\$dat. If NULL (the default), all items of type 'b' are affected

- ...:

  options to be passed to
  [`boxplot`](https://rdrr.io/r/graphics/boxplot.html)

## Value

a forest plot object of class 'fobj'

## Examples

``` r

fobj<-genfobj(layout = c("t","t","t","t","t","b","t","f","t"),
dat = forplotdata, obs = forplotdata_bp,
 lwidths = c(0.6,0.4,0.6,0.4,0.6,1,1,1,0.5))
fobj<-b_boxplot(fobj, boxwex = 0.2)
plotfobj(fobj)

```

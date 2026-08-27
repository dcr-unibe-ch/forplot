# Modify axis in density (d) items of a forest plot object (fobj)

Passed to [`axis`](https://rdrr.io/r/graphics/axis.html).

## Usage

``` r
d_axis(fobj, item = NULL, ...)
```

## Arguments

- fobj:

  a forest plot object of class 'fobj'

- item:

  item to be modified, either a number or the name of the column in
  fobj\$dat. If NULL (the default), all items of type 'b' are affected.

- ...:

  options to be passed to
  [`axis`](https://rdrr.io/r/graphics/axis.html).

## Value

a forest plot object of class 'fobj'

## Examples

``` r

fobj<-genfobj(layout = c("t","t","t","t","t","d","t","f","t"),
dat = forplotdata, obs = forplotdata_bp,
 lwidths = c(0.6,0.4,0.6,0.4,0.6,1,1,1,0.5))
fobj<-d_axis(fobj, at = seq(2,10,by=2))
plotfobj(fobj)

```

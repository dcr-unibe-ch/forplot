# Modify points in forest (f) items of a forest plot object (fobj)

Passed to [`points`](https://rdrr.io/r/graphics/points.html).

## Usage

``` r
f_points(fobj, item = NULL, ...)
```

## Arguments

- fobj:

  a forest plot object of class 'fobj'

- item:

  item to be modified, either a number or the name of the column in
  fobj\$dat. If NULL (the default), all items of type 'f' are affected

- ...:

  options to be passed to
  [`points`](https://rdrr.io/r/graphics/points.html)

## Value

a forest plot object of class 'fobj'

## Examples

``` r

fobj<-genfobj(layout = c("t","t","t","t","t","t","f","t"),
  dat = forplotdata, lwidths = c(0.8,0.4,0.6,0.4,0.6,1,1,0.5))
fobj<-f_points(fobj = fobj, pch = 16, cex = 1.5)
plotfobj(fobj)
```

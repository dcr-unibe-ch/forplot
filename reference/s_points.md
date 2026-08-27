# Modify points in stripe (s) items of a forest plot object (fobj).

Passed to [`points`](https://rdrr.io/r/graphics/points.html).

## Usage

``` r
s_points(fobj, item = NULL, pointnr = NULL, ...)
```

## Arguments

- fobj:

  a forest plot object of class 'fobj'

- item:

  item to be modified, either a number or the name of the column in
  fobj\$dat. If NULL (the default), all items of type 's' are affected

- pointnr:

  points to be modified. If NULL (the default), all points are affected.

- ...:

  options to be passed to
  [`points`](https://rdrr.io/r/graphics/points.html)

## Value

a forest plot object of class 'fobj'

## Examples

``` r

fobj<-genfobj(layout = c("t","t","t","t","t","s2","t","f","t"),
dat = forplotdata_prop,
lwidths = c(0.6,0.4,0.6,0.4,0.6,1.0,1.2,1,0.5))
fobj<-s_points(fobj=fobj, pch = 16, cex=1.5)
fobj<-s_points(fobj=fobj, pointnr = 1, col = "red")
fobj<-s_points(fobj=fobj, pointnr = 2, col = "blue")
plotfobj(fobj)


```

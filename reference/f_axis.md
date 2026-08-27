# Modify axis in forest (f) items of a forest plot object (fobj)

Passed to [`axis`](https://rdrr.io/r/graphics/axis.html).

## Usage

``` r
f_axis(fobj, item = NULL, ...)
```

## Arguments

- fobj:

  a forest plot object of class 'fobj'

- item:

  item to be modified, either a number or the name of the column in
  fobj\$dat. If NULL (the default), all items of type 'f' are affected

- ...:

  options to be passed to [`axis`](https://rdrr.io/r/graphics/axis.html)

## Value

a forest plot object of class 'fobj'

## Examples

``` r

fobj<-genfobj(layout = c("t","t","t","t","t","t","f","t"),
  dat = forplotdata, lwidths = c(0.8,0.4,0.6,0.4,0.6,1,1,0.5))
fobj<-f_axis(fobj = fobj, at = seq(-1,0.2, by=0.4),
tck=-0.03, mgp = c(2,0.5,0))
plotfobj(fobj)
```

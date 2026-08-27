# Modify axis of stripchart (s) items of a forest plot object (fobj)

Passed to [`axis`](https://rdrr.io/r/graphics/axis.html).

## Usage

``` r
s_axis(fobj, item = NULL, ...)
```

## Arguments

- fobj:

  a forest plot object of class 'fobj'

- item:

  item to be modified, either a number or the name of the column in
  fobj\$dat. If NULL (the default), all items of type 's' are affected

- ...:

  options to be passed to [`axis`](https://rdrr.io/r/graphics/axis.html)

## Value

a forest plot object of class 'fobj'

## Examples

``` r

fobj<-genfobj(layout = c("t","t","t","t","t","s2","t","f","t"),
dat = forplotdata_prop,
lwidths = c(0.6,0.4,0.6,0.4,0.6,1.0,1.2,1,0.5))
fobj<-s_axis(fobj=fobj, xlim = c(0,1),
 at = seq(0,1,by=0.25), labels = seq(0,100,by=25))
plotfobj(fobj)
```

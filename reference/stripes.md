# Add and customize stripes in a forest plot object (fobj)

Passed to [`rect`](https://rdrr.io/r/graphics/rect.html). With no
argument, every second row is coloured using rgb(.1,.1,.1,.1). Options
'xright' and 'xleft' of [`rect`](https://rdrr.io/r/graphics/rect.html)
are always set to the left and right end of the plotting region.

## Usage

``` r
stripes(fobj, item = NULL, ...)
```

## Arguments

- fobj:

  a forest plot object of class 'fobj'

- item:

  item to be modified, either a number with the position in layout or
  the name of the column in fobj\$dat. If NULL (the default), all items
  are affected.

- ...:

  options to be passed to [`rect`](https://rdrr.io/r/graphics/rect.html)

## Value

a forest plot object of class 'fobj'

## Examples

``` r

fobj<-genfobj(layout = c("ttttttft"),
  dat = forplotdata,
lwidths = c(0.8,0.4,0.6,0.4,0.6,1,1,0.5))
fobj<-stripes(fobj = fobj)
plotfobj(fobj)
```

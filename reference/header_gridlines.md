# Add and customize horizontal and vertical lines in the header of a forest plot object (fobj)

Passed to [`abline`](https://rdrr.io/r/graphics/abline.html). With no
argument, horizontal lines are added at the top and bottom (h = c(0,1)).
Note that the x-and y-scale of each item is c(0,1).

## Usage

``` r
header_gridlines(fobj, item = NULL, ...)
```

## Arguments

- fobj:

  a forest plot object of class 'fobj' or 'cfobj'

- item:

  if only the header above an item should be modified, either a number
  with the position in layout or the name of the column in fobj\$dat. If
  NULL (the default), the whole header is affected.

- ...:

  options to be passed to Passed to
  [`abline`](https://rdrr.io/r/graphics/abline.html).

## Value

a forest plot object of class 'fobj'

## Examples

``` r

fobj<-genfobj(layout = c("ttttttft"),
  dat = forplotdata,
lwidths = c(0.8,0.4,0.6,0.4,0.6,1,1,0.5))
fobj<-header_gridlines(fobj = fobj)
plotfobj(fobj)
```

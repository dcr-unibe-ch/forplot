# Add and customize horizontal or vertical lines in a forest plot object (fobj).

Passed to [`abline`](https://rdrr.io/r/graphics/abline.html). With no
argument, horizontal lines are added at the top and bottom. Note that
the x-scale of all times is set to c(0,1). I.e. v=c(0,1) will generate
gridlines at the border between items.

## Usage

``` r
gridlines(fobj, item = NULL, ...)
```

## Arguments

- fobj:

  a forest plot object of class 'fobj'

- item:

  item to be modified, either a number with the position in layout or
  the name of the column in fobj\$dat. If NULL (the default), all items
  are affected.

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
fobj<-gridlines(fobj = fobj)
plotfobj(fobj)
```

# Add and customize horizontal lines in the header of a forest plot object (fobj)

Passed to [`abline`](https://rdrr.io/r/graphics/abline.html).

## Usage

``` r
header_gridlines(fobj, ...)
```

## Arguments

- fobj:

  a forest plot object of class 'fobj' or 'cfobj'

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

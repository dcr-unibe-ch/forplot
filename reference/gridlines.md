# Customize horizontal lines in a forest plot object (fobj)

Passed to [`abline`](https://rdrr.io/r/graphics/abline.html).

## Usage

``` r
gridlines(fobj, ...)
```

## Arguments

- fobj:

  a forest plot object of class 'fobj'

- ...:

  options to be passed to Passed to
  [`abline`](https://rdrr.io/r/graphics/abline.html).

## Value

a forest plot object of class 'fobj'

## Examples

``` r

fobj<-genfobj(layout = c("t","t","t","t","t","t","f","t"),
  dat = forplotdata,
lwidths = c(0.8,0.4,0.6,0.4,0.6,1,1,0.5))
fobj<-gridlines(fobj = fobj)
plotfobj(fobj)
```

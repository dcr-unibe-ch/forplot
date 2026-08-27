# Customize stripes in a forest plot object (fobj)

Passed to [`rect`](https://rdrr.io/r/graphics/rect.html).

## Usage

``` r
stripes(fobj, ...)
```

## Arguments

- fobj:

  a forest plot object of class 'fobj'

- ...:

  options to be passed to [`rect`](https://rdrr.io/r/graphics/rect.html)

## Value

a forest plot object of class 'fobj'

## Examples

``` r

fobj<-genfobj(layout = c("t","t","t","t","t","t","f","t"),
  dat = forplotdata,
lwidths = c(0.8,0.4,0.6,0.4,0.6,1,1,0.5))
fobj<-stripes(fobj = fobj)
plotfobj(fobj)
```

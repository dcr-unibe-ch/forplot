# Add and modify borders of a sripe (s) item of a forest plot object (fobj).

Passed to [`abline`](https://rdrr.io/r/graphics/abline.html). Without
options two vertical lines are plotted at x-axis limits.

## Usage

``` r
s_borders(fobj, item = NULL, ...)
```

## Arguments

- fobj:

  a forest plot object of class 'fobj'

- item:

  item to be modified, either a number or the name of the column in
  fobj\$dat. If NULL (the default), all items of type 's' are affected

- ...:

  options to be passed to
  [`abline`](https://rdrr.io/r/graphics/abline.html)

## Value

a forest plot object of class 'fobj'

## Examples

``` r

fobj<-genfobj(layout = c("t","t","t","t","t","s2","t","f","t"),
dat = forplotdata_prop,
lwidths = c(0.6,0.4,0.6,0.4,0.6,1.0,1.2,1,0.5))
fobj<-s_borders(fobj=fobj)
plotfobj(fobj)

```

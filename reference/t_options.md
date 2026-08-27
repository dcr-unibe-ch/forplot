# Modify text (t) items of a forest plot object (fobj).

Passed to [`text`](https://rdrr.io/r/graphics/text.html).

## Usage

``` r
t_options(fobj, item = NULL, ...)
```

## Arguments

- fobj:

  a forest plot object of class fobj

- item:

  item to be modified, either a number or the name of the column in
  fobj\$dat. If NULL (the default), all items of type 't' are affected

- ...:

  options to be passed to [`text`](https://rdrr.io/r/graphics/text.html)

## Value

a forest plot object of class 'fobj'

## Examples

``` r

fobj<-genfobj(layout = c("t","t","t","t","t","t","f","t"),
  dat = forplotdata, lwidths = c(0.8,0.4,0.6,0.4,0.6,1,1,0.5))
fobj<-t_options(fobj = fobj, item = 1, col = 2)
plotfobj(fobj)
```

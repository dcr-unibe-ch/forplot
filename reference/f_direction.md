# Add and modify direction indicator in forest (f) items of a forest plot object (fobj).

Passed to [`mtext`](https://rdrr.io/r/graphics/mtext.html).

## Usage

``` r
f_direction(fobj, item = NULL, ...)
```

## Arguments

- fobj:

  a forest plot object of class 'fobj'

- item:

  item to be modified, either a number or the name of the column in
  fobj\$dat. If NULL (the default), all items of type 'f' are affected

- ...:

  options to be passed to
  [`mtext`](https://rdrr.io/r/graphics/mtext.html)

## Value

a forest plot object of class 'fobj'

## Examples

``` r

fobj<-genfobj(layout = c("t","t","t","t","t","t","f","t"),
  dat = forplotdata, lwidths = c(0.8,0.4,0.6,0.4,0.6,1,1,0.5))
fobj<-f_direction(fobj = fobj, text = "A better    B better",
  line = 1.6)
plotfobj(fobj)
```

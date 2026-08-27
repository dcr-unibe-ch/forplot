# Modify lines in density (d) items of a forest plot object (fobj).

Passed to [`lines`](https://rdrr.io/r/graphics/lines.html).

## Usage

``` r
d_lines(fobj, item = NULL, linenr = NULL, ...)
```

## Arguments

- fobj:

  a forest plot object of class 'fobj'

- item:

  item to be modified, either a number or the name of the column in
  fobj\$dat. If NULL (the default), all items of type 's' are affected

- linenr:

  lines to be modified. A vector of length 2 refering to the variable
  and the arm. If NULL (the default), all lines are affected. If one
  number is NA, all lines are affected.

- ...:

  options to be passed to
  [`lines`](https://rdrr.io/r/graphics/lines.html)

## Value

a forest plot object of class 'fobj'

## Examples

``` r

fobj<-genfobj(layout = c("t","t","t","t","t","d","t","f","t"),
dat = forplotdata, obs = forplotdata_bp,
 lwidths = c(0.6,0.4,0.6,0.4,0.6,1,1,1,0.5))
#all lines:
fobj<-d_lines(fobj=fobj, lw=2)
plotfobj(fobj)

#only one arm:
fobj<-d_lines(fobj=fobj, linenr=c(NA,2), col=1)
plotfobj(fobj)


```

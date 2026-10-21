# Modify the background of the header of a forest plot object (fobj)

Passed to [`rect`](https://rdrr.io/r/graphics/rect.html). If the xright,
xleft, ytop and ybottom are not given, the whole plotting region is
used. With no argument, the default col = rgb(.1,.1,.1,.1) is used. If
there are several headers, the 'stripes' argument is added to the first
one but applies to all.

## Usage

``` r
header_stripes(fobj, ...)
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

fobj<-genfobj(layout = c("ttttttft"),
  dat = forplotdata,
lwidths = c(0.8,0.4,0.6,0.4,0.6,1,1,0.5))
#Add default background color:
fobj<-header_stripes(fobj = fobj)
plotfobj(fobj)


#Other color
fobj<-header_stripes(fobj = fobj, col = rgb(1,0,0,0.1))
plotfobj(fobj)

```

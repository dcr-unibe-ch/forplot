# Plot a forest plot (fobj) object

Plot a forest plot (fobj) object

## Usage

``` r
plotfobj(fobj)
```

## Arguments

- fobj:

  a forest plot object or a combined forest plot object

## Value

a plot

## Examples

``` r

fobj<-genfobj(layout = c("t","t","t","t","t","t","f","t"),
  dat = forplotdata,
lwidths = c(0.8,0.4,0.6,0.4,0.6,1,1,0.5))
plotfobj(fobj)

```

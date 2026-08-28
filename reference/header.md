# Modify the header of a forest plot object (fobj)

Passed to [`text`](https://rdrr.io/r/graphics/text.html).

## Usage

``` r
header(fobj, hlayout = NULL, headernr = NULL, ...)
```

## Arguments

- fobj:

  a forest plot object of class 'fobj'

- hlayout:

  layout of header columns. Numeric vector with the same length as the
  labels.

- headernr:

  header row to be modified. If NULL (the default), all header rows are
  affected

- ...:

  options to be passed to [`text`](https://rdrr.io/r/graphics/text.html)

## Value

a forest plot object of class 'fobj'

## Examples

``` r

fobj<-genfobj(layout = c("t","t","t","t","t","t","f","t"),
  dat = forplotdata,
lwidths = c(0.8,0.4,0.6,0.4,0.6,1,1,0.5))
#Custom names
fobj<-header(fobj = fobj,
 labels = c("","Group1\nN","Group1\nmean (sd)","Group2\nN","Group2\nmean (sd)",
"Mean difference\n95% CI","","P-value"),
 y = 0.6)
plotfobj(fobj)


#Several lines
fobj<-header(fobj = fobj, hlayout = c(1,2,2,3,3,4,4,5),  headernr = 1,
labels=c("","Arm A","Arm B","Mean diff (95% CI)","P-value"),
y = 0.9)
fobj<-header(fobj = fobj, hlayout = c(1,2,3,4,5,6,7,8), headernr = 2,
labels=c("","N","Mean (sd)","N","Mean (sd)","","",""),y=0.3)
plotfobj(fobj)

```

# Combine multiple forest plot objects (fobj)

Combines a list of fobj. Changes the fobj to an cfobj.

## Usage

``` r
combinefobj(
  lfobj,
  atrows = NA,
  subtitle = NA,
  lheights = NA,
  keepiheadfoot = c(TRUE, TRUE)
)
```

## Arguments

- lfobj:

  a list of forest plot objects of class 'fobj'

- atrows:

  number of the row(s) at which the fibj should be split. The split is
  always before the indicated rows.

- subtitle:

  optional character vector with subtitles, has to be of the same length
  as atrows

- lheights:

  Optional numeric vector with the relative heights of header,
  subtitles, main panels and footer. The length has to correspond to 3 +
  2\*number of inserted subtitles.

- keepiheadfoot:

  logical of length 2, whether the header and footers of the individual
  fobjs are kept.

## Value

a combined forest plot object of class 'cfobj'

## Examples

``` r

fobj1<-genfobj(dat = forplotdata[1:5,],
 layout = c("t","t","t","t","t","t","f","t"),
  lwidths = c(0.8,0.4,0.6,0.4,0.6,1,1,0.5))

fobj2<-genfobj(dat = forplotdata[6:10,],
  layout = c("t","t","t","t","t","t","f","t"),
  lwidths = c(0.8,0.4,0.6,0.4,0.6,1,1,0.5))

cfobj<-combinefobj(list(fobj1,fobj2))
plotfobj(cfobj)

```

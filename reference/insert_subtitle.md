# Insert subtitles over the whole width of an fobj

Changes to fobj to an cfobj.

## Usage

``` r
insert_subtitle(fobj, atrows, subtitle = NA, lheights = NA)
```

## Arguments

- fobj:

  a forest plot object of class 'fobj'

- atrows:

  number of the row(s) at which the fibj should be split. The split is
  always before the indicated rows.

- subtitle:

  optional character vector with subtitles, has to be of the same length
  as atrows

- lheights:

  Optional numeric vector with the relative heights of over header,
  subtitles, main panels and overall footer.

## Value

a combined forest plot object of class 'cfobj'

## Examples

``` r

fobj<-genfobj(layout = c("t","t","t","t","t","t","f","t"),
 dat = forplotdata,
lwidths = c(0.8,0.4,0.6,0.4,0.6,1,1,0.5))
cfobj<-insert_subtitle(fobj,
atrows=c(3, 5),
subtitle=c("A first long title is added here",
 "A second even longer title is added here"))
  plotfobj(cfobj)

```

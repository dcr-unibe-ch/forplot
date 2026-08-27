# Create a forest plot (fobj) object

First step to generate a forest plot. Generates a fobj that can be
plotted.

## Usage

``` r
genfobj(
  layout,
  dat,
  obs = NULL,
  lwidths = NA,
  lheights = NA,
  y.at = NA,
  ylim = NA
)
```

## Arguments

- layout:

  layout of the plot, character vector with 't' (text), 'f' (forest),
  's' (strip), 'b' (boxplot) or 'd' (density plot).

- dat:

  data frame that should be plotted

- obs:

  Optional data frame with the observations for the boxplot. Required of
  layout includes 'b' or 'd'.

- lwidths:

  Optional numeric vector with the relative widths of the columns. Must
  have the same length as layout.

- lheights:

  Optional numeric vector of length 3 with the relative heights of
  header, main panel and footer.

- y.at:

  Optional numeric vector with the position of the rows. Usually not
  required.

- ylim:

  Optional limits of the rows. Usually not required.

## Value

a forest plot object of class 'fobj'

## Examples

``` r

fobj<-genfobj(layout = c("t","t","t","t","t","t","f","t"),
  dat = forplotdata,
lwidths = c(0.8,0.4,0.6,0.4,0.6,1,1,0.5))
plotfobj(fobj)

```

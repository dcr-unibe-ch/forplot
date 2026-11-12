#' Plot a forest plot object (fobj)
#'
#' @param fobj a forest plot object or a combined forest plot object
#'
#' @returns a plot
#'
#' @export
#'
#' @importFrom graphics abline rect
#' @importFrom stats aggregate sd
#'
#' @examples
#'
#' fobj<-genfobj(layout = c("ttttttft"),
#' 	dat = forplotdata,
#'	lwidths = c(0.8,0.4,0.6,0.4,0.6,1,1,0.5))
#' plotfobj(fobj)
#'
plotfobj<- function(fobj) {

	isfobj<-"fobj" %in% class(fobj)
	iscfobj<-"cfobj" %in% class(fobj)
	islistfobj<-FALSE

	if (!isfobj & !iscfobj) {
		cc<-do.call(rbind,lapply(fobj,function(x) class(x)))
		islistfobj<-is.list(fobj) & all(cc[,1]=="fobj")
	}

	if (!(isfobj | islistfobj | iscfobj)) {
		stop("'fobj' must have class 'fobj' or 'cfobj'. Use genfobj to generate it.")
	}

	if (!isfobj & !iscfobj & islistfobj) {

		#check compatability

		le<-unlist(lapply(fobj,function(x) length(x$setup$layout)))
		le1<-unique(le)
		if (length(le1)!=1) {
			warning("Not all fobj have the same number of columns. Different sized fobj are evenly distributed. ")
		}

		#find least common multiple
		lec<-lcm_vector(le)
		lefact<-lec/le

		#combine lheights and lwidths
		cheights<-unlist(lapply(fobj, function(x) x$setup$lheights))

		#cwidthsm<-do.call(rbind,lapply(fobj, function(x) x$setup$lwidths))
		cwidthsm<-t(sapply(1:length(fobj), function(x) rep(fobj[[x]]$setup$lwidths,each=lefact[x])))
		cwidthsm<-t(apply(cwidthsm,1,function(x) x/sum(x)))

		dw<-sum(apply(cwidthsm,2,sd))
		if (abs(dw)>10^(-5)) {
			warning("lwidths are not the same in all fobj. The average is used.")
		}
		cwidths<-apply(cwidthsm,2,mean)

		#create new layout matrix
		mac<-numeric(0)
		for (i in 1:length(fobj)) {

			#main panel
			mainp<-1:le[i]
			mainp<-rep(mainp,each=lefact[i])
			if (i!=1) {
				mainp<-mainp + max(mac)
			}

			#header and footer
			mai<-rbind(rep(max(mainp)+2,length(cwidths)),
				mainp,
				rep(max(mainp)+1,length(cwidths)))

			mac<-rbind(mac,mai)

		}

		#left and right margin not included
		#mac<-cbind(max(mac)+1,mac,max(mac)+2)
		#layout
		#margin<-sum(cwidths)/100

		layout(mac,
			heights = cheights,
			widths=c(cwidths))

		par(mar=c(0,0,0,0))

		for (fi in 1:length(fobj)) {

			fobji<-fobj[[fi]]

			#common widths
			fobji$setup$lwidths<-cwidths

			#adapt header layout:
			for (fj in 1:length(fobj[[fi]]$header)) {
				fobji$header[[fj]]$hlayout<-rep(fobji$header[[fj]]$hlayout,each=lefact[fi])
			}

			plotfobj1(fobj = fobji)

			if (is.null(fobji$header)) {
				plot(x=0, type="n", xlim=c(0,1), ylim=c(0,1),
					ylab="", xlab="", axes=FALSE, xaxs="i", yaxs="i")
			}

		}
	}

	if (isfobj) {

		#left and right margin not included:
		#margin<-sum(fobj$setup$lwidths)/100
		#layout(fobj$setup$lmatrix,
		#	heights=fobj$setup$lheights,
		#	widths=c(margin,fobj$setup$lwidths,margin))
		
		layout(fobj$setup$lmatrix,
			heights=fobj$setup$lheights,
			widths=c(fobj$setup$lwidths))
			
		par(mar=c(0,0,0,0))

		plotfobj1(fobj = fobj)

	}

	if (iscfobj) {

		layout(fobj$setup$lmatrix,
			heights=fobj$setup$lheights,
			widths=c(fobj$setup$lwidths))

		par(mar=c(0,0,0,0))

		#ovearall header
		if (!is.null(fobj$header)) {
			hobj<-list(header=fobj$header,setup=list(lwidths=fobj$setup$lwidths))
			plotfobj1(fobj = hobj, additems=FALSE, addfoot=FALSE)
		} else {
			plot(x=0, type="n", xlim=c(0,1), ylim=c(0,1),
				ylab="", xlab="", axes=FALSE, xaxs="i", yaxs="i")
		}

		#individual fobjs
		for (ir in 1:length(fobj$fobjs)) {
			plotfobj1(fobj = fobj$fobjs[[ir]],
				addhead = fobj$setup$iheadfoot[1],
				addfoot = fobj$setup$iheadfoot[2])
		}

	}
}


#' plotfobj1
#'
#' @param fobj a forest plot object or a list of fobj with the same layout length
#' @param additems logical, whether items are plotted
#' @param addfoot logical, whether a footer is added
#' @param addhead logical, whether a header is added
#'
#' @returns a plot
#'
#' @importFrom graphics abline rect
#' @importFrom stats aggregate
#'
#' @noRd
#'
#'
plotfobj1<- function(fobj, additems = TRUE, addfoot = TRUE, addhead = TRUE) {

	#items
	if (additems) {
		for (i in 1:length(fobj$setup$layout)) {

			if (fobj$setup$layout[i]=="t") {
				
				do.call(plot, fobj$items[[i]]$plot)
				
				if (!is.null(fobj$stripes[[i]])) {
					fobj$stripes[[i]]$xleft<-par("usr")[1]
					fobj$stripes[[i]]$xright<-par("usr")[2]
					do.call(rect, fobj$stripes[[i]])
				}
				
				if (!is.null(fobj$gridlines[[i]])) {
					if (!is.null(fobj$gridlines[[i]]$v)) {
						xp<-par("usr")[1:2]
						fobj$gridlines[[i]]$v<-xp[1]+fobj$gridlines[[i]]$v*(diff(xp))
					}
					do.call(abline, fobj$gridlines[[i]])
				}
				
				do.call(text, fobj$items[[i]]$text)

				
			}

			if (fobj$setup$layout[i]=="f") {

				do.call(plot, fobj$items[[i]]$plot)
				
				if (!is.null(fobj$stripes[[i]])) {
					fobj$stripes[[i]]$xleft<-par("usr")[1]
					fobj$stripes[[i]]$xright<-par("usr")[2]
					do.call(rect, fobj$stripes[[i]])
				}
				
				if (!is.null(fobj$gridlines[[i]])) {
					if (!is.null(fobj$gridlines[[i]]$v)) {
						xp<-par("usr")[1:2]
						fobj$gridlines[[i]]$v<-xp[1]+fobj$gridlines[[i]]$v*(diff(xp))
					}
					do.call(abline, fobj$gridlines[[i]])
				}
				
				if (!is.null(fobj$items[[i]]$axis)) {
					do.call(axis, fobj$items[[i]]$axis)
				}

				#if (!is.null(fobj$items[[i]]$refline)) {
				#	lapply(fobj$items[[i]]$refline, function(x) do.call(lines, x))
				#}

				if (!is.null(fobj$items[[i]]$refline)) {
					do.call(abline, fobj$items[[i]]$refline)
				}

				do.call(points, fobj$items[[i]]$points)
				do.call(mapply, c(FUN = arrows, fobj$items[[i]]$arrows))

				if (!is.null(fobj$items[[i]]$direction)) {
					do.call(mtext, fobj$items[[i]]$direction)
				}	
			}

			if (grepl("s\\d+",fobj$setup$layout[i])) {

				do.call(plot, fobj$items[[i]]$plot)
				
				if (!is.null(fobj$stripes[[i]])) {
					fobj$stripes[[i]]$xleft<-par("usr")[1]
					fobj$stripes[[i]]$xright<-par("usr")[2]
					do.call(rect, fobj$stripes[[i]])
				}
				
				if (!is.null(fobj$gridlines[[i]])) {
					if (!is.null(fobj$gridlines[[i]]$v)) {
						xp<-par("usr")[1:2]
						fobj$gridlines[[i]]$v<-xp[1]+fobj$gridlines[[i]]$v*(diff(xp))
					}
					do.call(abline, fobj$gridlines[[i]])
				}
				
				if (!is.null(fobj$items[[i]]$axis)) {
					do.call(axis, fobj$items[[i]]$axis)
				}

				do.call(abline, fobj$items[[i]]$hline)

				nstrip<-as.numeric(substr(fobj$setup$layout[i],2,nchar(fobj$setup$layout[i])))

				for (nsi in 1:nstrip) {
					do.call(points, fobj$items[[i]][[paste0("points",nsi)]])
				}

				if (!is.null(fobj$items[[i]]$borders)) {
					do.call(abline,fobj$items[[i]]$borders)
				}
			}

			if (fobj$setup$layout[i]=="b") {

				do.call(plot, fobj$items[[i]]$plot)
				
				if (!is.null(fobj$stripes[[i]])) {
					fobj$stripes[[i]]$xleft<-par("usr")[1]
					fobj$stripes[[i]]$xright<-par("usr")[2]
					do.call(rect, fobj$stripes[[i]])
				}
				
				if (!is.null(fobj$gridlines[[i]])) {
					if (!is.null(fobj$gridlines[[i]]$v)) {
						xp<-par("usr")[1:2]
						fobj$gridlines[[i]]$v<-xp[1]+fobj$gridlines[[i]]$v*(diff(xp))
					}
					do.call(abline, fobj$gridlines[[i]])
				}
				
				do.call(boxplot, fobj$items[[i]]$boxplot)

				if (!is.null(fobj$items[[i]]$axis)) {
					do.call(axis, fobj$items[[i]]$axis)
				}

			}

			if (fobj$setup$layout[i]=="d") {

				do.call(plot, fobj$items[[i]]$plot)
				
				if (!is.null(fobj$stripes[[i]])) {
					fobj$stripes[[i]]$xleft<-par("usr")[1]
					fobj$stripes[[i]]$xright<-par("usr")[2]
					do.call(rect, fobj$stripes[[i]])
				}
				
				if (!is.null(fobj$gridlines[[i]])) {
					if (!is.null(fobj$gridlines[[i]]$v)) {
						xp<-par("usr")[1:2]
						fobj$gridlines[[i]]$v<-xp[1]+fobj$gridlines[[i]]$v*(diff(xp))
					}
					do.call(abline, fobj$gridlines[[i]])
				}
				
				if (!is.null(fobj$items[[i]]$axis)) {
					do.call(axis, fobj$items[[i]]$axis)
				}

				lapply(fobj$items[[i]]$lines, function(x) lapply(x, function(u) do.call(lines,u)))
			}
		}
	}

	#footer
	if (addfoot) {
		plot(x=0, type="n", xlim=c(0,1), ylim=c(0,1),
			ylab="", xlab="", axes=FALSE, xaxs="i", yaxs="i")
	}

	#header
	if (addhead) {
		headernr<-length(fobj$header$main)

		if (headernr>0) {

			plot(x=0, type="n", xlim=c(0,1), ylim=c(0,1),
				ylab="", xlab="", axes=FALSE, xaxs="i", yaxs="i")
			
			xsize<-par("usr")[2]-par("usr")[1]
			rwidth<-fobj$setup$lwidths
			cwidth<-(xsize/sum(rwidth)*rwidth)
			ccwidth<-cumsum(cwidth)
			
			if (!is.null(fobj$header$stripes)) {
				
				for (hi in 1:length(fobj$header$stripes)) {
				
					if (!is.null(fobj$header$stripes[[hi]])) {
					
						xleft<-c(par("usr")[1],ccwidth)[hi]
						xright<-ccwidth[hi]
						reph<-max(length(fobj$header$stripes[[hi]]$ybottom),
							length(fobj$header$stripes[[hi]]$ytop))
					
						if (all(is.na(fobj$header$stripes[[hi]]$xleft))) {
							fobj$header$stripes[[hi]]$xleft<-rep(xleft,each=reph)
						}
						if (all(is.na(fobj$header$stripes[[hi]]$xright))) {
							fobj$header$stripes[[hi]]$xright<-rep(xright,each=reph)
						}
						if (all(is.na(fobj$header$stripes[[hi]]$ybottom))) {
							fobj$header$stripes[[hi]]$ybottom<-par("usr")[3]
						}
						if (all(is.na(fobj$header$stripes[[hi]]$ytop))) {
							fobj$header$stripes[[hi]]$ytop<-par("usr")[4]
						}
						do.call(rect, fobj$header$stripes[[hi]])
					}
				}	
			}
			
				
			if (!is.null(fobj$header$gridlines)) {
	
				for (hi in 1:length(fobj$header$gridlines)) {
				
					if (!is.null(fobj$header$gridlines[[hi]])) {
				
						xleft<-c(par("usr")[1],ccwidth)[hi]
						xright<-ccwidth[hi]
						lplot<-fobj$header$gridlines[[hi]]
						sel<-lplot[names(lplot) %in% c("v", "h")]
						nline<-length(unlist(sel))
						lplot<-lapply(lplot,function(x) {
							if (length(x) < nline) rep_len(x, nline) else x
						})
						lplot<-lplot[!names(lplot) %in% c("h","v")]
							
						s<-1
						ih<-1
						counter<-1
						if (!is.null(sel)) {
							for (s in 1:length(sel)) {
								if (names(sel)[s]=="h") {
									for (ih in 1:length(sel[[s]])) {
										yp<-fobj$header$gridlines[[hi]]$h[ih]
										lploti<-lapply(lplot, function(x) x[[counter]])
										lploti$x<-c(xleft,xright)
										lploti$y<-c(yp,yp)
										do.call(lines, lploti)
										counter<-counter+1
									}
								}	
								if (names(sel)[s]=="v") {
									for (ih in 1:length(sel[[s]])) {
										xp<-fobj$header$gridlines[[hi]]$v[ih]
										xp<-xleft+xp*(xright-xleft)
										lploti<-lapply(lplot, function(x) x[[counter]])
										lploti$x<-c(xp,xp)
										lploti$y<-c(par("usr")[3],par("usr")[4])
										do.call(lines, lploti)
										counter<-counter+1
									}
								}	
							}
						}	
					}	
				}	
			}
			
			#if (!is.null(fobj$header[[1]]$gridlines)) {
			#	do.call(abline, fobj$header[[1]]$gridlines)
			#}
				
			hi<-1
			for (hi in 1:headernr) {

				if (is.null(fobj$header$main[[hi]]$text$x)) {

					wdf<-cbind(ind=fobj$header$main[[hi]]$hlayout,cwidth)
					wdf<-aggregate(cwidth ~ ind, data = wdf, FUN = sum)
					cwidthi<-wdf$cwidth

					if (length(cwidthi)!=length(fobj$header$main[[hi]]$text$labels)) {
						stop("Length of 'labels' must match number of distinct values in 'hlayout'")
					}

					lb<-c(par("usr")[1],par("usr")[1] + cumsum(cwidthi)[-length(cwidthi)])
					ub<-par("usr")[1] + cumsum(cwidthi)
					fobj$header$main[[hi]]$text$x<-(lb+ub)/2

				}

				do.call(text, fobj$header$main[[hi]]$text)
			}
		} else {
			plot(x=0, type="n", xlim=c(0,1), ylim=c(0,1),
				ylab="", xlab="", axes=FALSE, xaxs="i", yaxs="i")
			
		}
	}

}


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
#' fobj<-genfobj(layout = c("t","t","t","t","t","t","f","t"),
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

		#add side
		mac<-cbind(max(mac)+1,mac,max(mac)+2)

		#layout
		margin<-sum(cwidths)/100

		layout(mac,
			heights = cheights,
			widths=c(margin,cwidths,margin))

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
				plot(0,type = "n", axes=FALSE, xlab="", ylab="")
			}

		}
	}

	if (isfobj) {

		ma<-lma(rows = 1, cols = length(fobj$setup$layout),
			commonx1 = TRUE, commonx2 = TRUE)

		margin<-sum(fobj$setup$lwidths)/100

		layout(ma,
			heights=fobj$setup$lheights,
			widths=c(margin,fobj$setup$lwidths,margin))

		par(mar=c(0,0,0,0))

		plotfobj1(fobj = fobj)

	}

	if (iscfobj) {

		#layout
		margin<-sum(fobj$setup$lwidths)/100

		layout(fobj$setup$lmatrix,
			heights=fobj$setup$lheights,
			widths=c(margin,fobj$setup$lwidths,margin))

		par(mar=c(0,0,0,0))

		#ovearall header
		if (!is.null(fobj$header)) {
			hobj<-list(header=fobj$header,setup=list(lwidths=fobj$setup$lwidths))
			plotfobj1(fobj = hobj, additems=FALSE, addfoot=FALSE)
		} else {
			plot(0,type="n",axes=FALSE,ylim=c(0,1),xlim=c(0,1),xlab="",ylab="")
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
				do.call(text, fobj$items[[i]]$text)

				if (!is.null(fobj$gridlines)) {
					do.call(abline, fobj$gridlines)
				}

				if (!is.null(fobj$stripes)) {
					fobj$stripes$xleft<-par("usr")[1]
					fobj$stripes$xright<-par("usr")[2]
					do.call(rect, fobj$stripes)
				}
			}

			if (fobj$setup$layout[i]=="f") {

				do.call(plot, fobj$items[[i]]$plot)

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

				if (!is.null(fobj$gridlines)) {
					do.call(abline, fobj$gridlines)
				}

				if (!is.null(fobj$stripes)) {
					fobj$stripes$xleft<-par("usr")[1]
					fobj$stripes$xright<-par("usr")[2]
					do.call(rect, fobj$stripes)
				}
			}

			if (grepl("s\\d+",fobj$setup$layout[i])) {

				do.call(plot, fobj$items[[i]]$plot)

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

				if (!is.null(fobj$gridlines)) {
					do.call(abline, fobj$gridlines)
				}

				if (!is.null(fobj$stripes)) {
					fobj$stripes$xleft<-par("usr")[1]
					fobj$stripes$xright<-par("usr")[2]
					do.call(rect, fobj$stripes)
				}
			}

			if (fobj$setup$layout[i]=="b") {

				do.call(plot, fobj$items[[i]]$plot)

				do.call(boxplot, fobj$items[[i]]$boxplot)

				if (!is.null(fobj$items[[i]]$axis)) {
					do.call(axis, fobj$items[[i]]$axis)
				}

				if (!is.null(fobj$gridlines)) {
					do.call(abline, fobj$gridlines)
				}

				if (!is.null(fobj$stripes)) {
					fobj$stripes$xleft<-par("usr")[1]
					fobj$stripes$xright<-par("usr")[2]
					do.call(rect, fobj$stripes)
				}

			}

			if (fobj$setup$layout[i]=="d") {

				do.call(plot, fobj$items[[i]]$plot)

				if (!is.null(fobj$items[[i]]$axis)) {
					do.call(axis, fobj$items[[i]]$axis)
				}

				lapply(fobj$items[[i]]$lines, function(x) lapply(x, function(u) do.call(lines,u)))

				if (!is.null(fobj$gridlines)) {
					do.call(abline, fobj$gridlines)
				}

				if (!is.null(fobj$stripes)) {
					fobj$stripes$xleft<-par("usr")[1]
					fobj$stripes$xright<-par("usr")[2]
					do.call(rect, fobj$stripes)
				}
			}
		}
	}

	#footer
	if (addfoot) {
		plot(0,type="n",axes=FALSE,ylim=c(0,1),xlim=c(0,1),xlab="",ylab="")
	}

	#header
	if (addhead) {
		headernr<-length(fobj$header)

		if (headernr>0) {

			plot(x = 0, type="n", xlim=c(0,1), ylim=c(0,1), yaxt="n", ylab="", xlab="", axes=FALSE)

			xsize<-par("usr")[2]-par("usr")[1]
			rwidth<-fobj$setup$lwidths
			cwidth<-(xsize/sum(rwidth)*rwidth)

			hi<-1
			for (hi in 1:headernr) {

				if (is.null(fobj$header[[hi]]$text$x)) {

					wdf<-cbind(ind=fobj$header[[hi]]$hlayout,cwidth)
					wdf<-aggregate(cwidth ~ ind, data = wdf, FUN = sum)
					cwidthi<-wdf$cwidth

					if (length(cwidthi)!=length(fobj$header[[hi]]$text$labels)) {
						stop("Length of 'labels' must match number of distinct values in 'hlayout'")
					}

					lb<-c(par("usr")[1],par("usr")[1] + cumsum(cwidthi)[-length(cwidthi)])
					ub<-par("usr")[1] + cumsum(cwidthi)
					fobj$header[[hi]]$text$x<-(lb+ub)/2

				}

				do.call(text, fobj$header[[hi]]$text)
			}
		} else {
			plot(0,type="n",axes=FALSE,ylim=c(0,1),xlim=c(0,1),xlab="",ylab="")
		}
	}

}


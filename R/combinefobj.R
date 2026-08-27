
#' Combine multiple forest plot objects (fobj)
#'
#' Combines a list of fobj. Changes the fobj to an cfobj.
#'
#' @param lfobj a list of forest plot objects of class 'fobj'
#' @param atrows number of the row(s) at which the fibj should be split. The split is always before the indicated rows.
#' @param subtitle optional character vector with  subtitles, has to be of the same length as atrows
#' @param lheights Optional numeric vector with the relative heights of header, subtitles, main panels and footer.
#'	The length has to correspond to 3 + 2*number of inserted subtitles.
#' @param keepiheadfoot logical of length 2, whether the header and footers of the individual fobjs are kept.
#'
#' @returns a combined forest plot object of class 'cfobj'
#'
#' @export
#'
#' @importFrom utils modifyList
#'
#' @examples
#'
#' fobj1<-genfobj(dat = forplotdata[1:5,],
#'  layout = c("t","t","t","t","t","t","f","t"),
#' 	lwidths = c(0.8,0.4,0.6,0.4,0.6,1,1,0.5))
#'
#' fobj2<-genfobj(dat = forplotdata[6:10,],
#' 	layout = c("t","t","t","t","t","t","f","t"),
#' 	lwidths = c(0.8,0.4,0.6,0.4,0.6,1,1,0.5))
#'
#' cfobj<-combinefobj(list(fobj1,fobj2))
#' plotfobj(cfobj)
#'
combinefobj<-function(lfobj, atrows = NA, subtitle = NA, lheights = NA, keepiheadfoot = c(TRUE, TRUE))	{

		#check if list
		cc<-do.call(rbind,lapply(lfobj,function(x) class(x)))
		islistfobj<-is.list(lfobj) & all(cc[,1]=="fobj")

		if (!islistfobj) {
			stop("combinefobj requires a list of fobj")
		}

		#check compatability

		le<-unlist(lapply(lfobj,function(x) length(x$setup$layout)))
		le1<-unique(le)
		if (length(le1)!=1) {
			warning("Not all fobj have the same number of columns. Different sized fobj are evenly distributed. ")
		}

		#check keepiheadfoot
		if (!is.logical(keepiheadfoot) || length(keepiheadfoot) != 2 || any(is.na(keepiheadfoot))) {
			stop("Argument 'keepiheadfoot' must be a logical vector of length 2.")
		}

		#find least common multiple
		lec<-lcm_vector(le)
		lefact<-lec/le

		#combine lheights and lwidths
		avhead<-mean(unlist(lapply(lfobj, function(x) x$setup$lheights[1])))
		cheightl<-lapply(lfobj, function(x) x$setup$lheights)

		if (!keepiheadfoot[1]) {
			cheightl<-lapply(cheightl, function(x) x[-1])
		}
		if (!keepiheadfoot[2]) {
			cheightl<-lapply(cheightl, function(x) x[-length(x)])
		}
		#cheights<-unlist(lapply(lfobj, function(x) x$setup$lheights[-c(1,length(x$setup$lheights))]))

		cheights<-unlist(cheightl)
		cheights<-c(avhead,cheights,sum(cheights)/100)

		cwidthsm<-t(sapply(1:length(lfobj), function(x) rep(lfobj[[x]]$setup$lwidths,each=lefact[x])))
		cwidthsm<-t(apply(cwidthsm,1,function(x) x/sum(x)))
		dw<-sum(apply(cwidthsm,2,sd))
		if (abs(dw)>10^(-5)) {
			warning("lwidths are not the same in all fobj. The average is used.")
		}
		cwidths<-apply(cwidthsm,2,mean)

		#create new layout matrix
		mac<-numeric(0)
		for (i in 1:length(lfobj)) {

			#main panel
			mainp<-1:le[i]
			mainp<-rep(mainp,each=lefact[i])
			if (i!=1) {
				mainp<-mainp + max(mac)
			}

			#individual headers and footers
			if (all(keepiheadfoot)) {
				mai<-rbind(rep(max(mainp)+2,length(cwidths)),
					mainp,rep(max(mainp)+1,length(cwidths)))
			} else {
				if (all(!keepiheadfoot)) {
					mai<-mainp
				} else {
					if (keepiheadfoot[1]) {
						mai<-rbind(rep(max(mainp)+1,length(cwidths)),mainp)
					}
					if (keepiheadfoot[2]) {
						mai<-rbind(mainp,rep(max(mainp)+1,length(cwidths)))
					}
				}
			}

			mac<-rbind(mac,mai)
		}

		#overall header and footer:
		mac<-rbind(rep(1,ncol(mac)),mac+1,rep(max(mac)+2,ncol(mac)))

		#add side
		mac<-cbind(max(mac)+1,mac,max(mac)+2)
		mac<-unname(mac)

		#adapt widths and header layout in each element
		for (fi in 1:length(lfobj)) {

			#common widths
			lfobj[[fi]]$setup$lwidths<-cwidths

			#adapt header layout:
			if (keepiheadfoot[1]) {
				for (fj in 1:length(lfobj[[fi]]$header)) {
					lfobj[[fi]]$header[[fj]]$hlayout<-rep(lfobj[[fi]]$header[[fj]]$hlayout,each=lefact[fi])
				}
			} else {
				lfobj[[fi]]$header<-NULL
			}
		}


		cfobj<-list(
			setup = list(lmatrix=mac,
				lwidths=cwidths,
				lheights=cheights,
				iheadfoot=keepiheadfoot),
			header=NULL,
			fobjs=lfobj)

		class(cfobj) <- c("cfobj", class(cfobj))

		return(cfobj)
}


#' Insert subtitles over the whole width of an fobj
#'
#'	Changes to fobj to an cfobj.
#'
#' @param fobj a forest plot object of class 'fobj'
#' @param atrows number of the row(s) at which the fibj should be split. The split is always before the indicated rows.
#' @param subtitle optional character vector with  subtitles, has to be of the same length as atrows
#' @param lheights Optional numeric vector with the relative heights of over header,
#'	subtitles, main panels and overall footer.
#'
#' @returns a combined forest plot object of class 'cfobj'
#'
#' @export
#'
#' @importFrom utils modifyList
#'
#' @examples
#'
#' fobj<-genfobj(layout = c("t","t","t","t","t","t","f","t"),
#'  dat = forplotdata,
#'	lwidths = c(0.8,0.4,0.6,0.4,0.6,1,1,0.5))
#' cfobj<-insert_subtitle(fobj,
#'	atrows=c(3, 5),
#'	subtitle=c("A first long title is added here",
#'	 "A second even longer title is added here"))
#' 	plotfobj(cfobj)
#'
insert_subtitle<-function(fobj, atrows, subtitle = NA, lheights = NA)	{

	if (any(atrows>nrow(fobj$dat))) {
		stop("atrows must not be larger than the number of rows of the data frame.")
	}

	#generate new layout matrix:
	#-----------------

	nr<-2*length(atrows) + 1
	inspos<-seq(2,l=length(atrows),by=2)
	if (1 %in% atrows) {
		nr<-nr - 1
		inspos<-seq(1,l=length(atrows),by=2)
	}
	le<-length(fobj$setup$layout)

	mac<-numeric(0)
	r<-1
	for (r in 1:nr) {

		#main panel
		if (r %in% inspos) {
			mainp<-rep(1,le)
		} else {
			mainp<-1:le
		}
		if (r!=1) {
			mainp<-mainp + max(mac)
		}

		#header and footer
		#not included...
		#mainp<-rbind(rep(max(mainp)+2,le),
		#	mainp,
		#	rep(max(mainp)+1,le))

		mac<-rbind(mac,mainp)

	}

	#overall header and footer:
	mac<-rbind(rep(1,ncol(mac)),mac+1,rep(max(mac)+2,ncol(mac)))

	#add side
	mac<-cbind(max(mac)+1,mac,max(mac)+2)
	mac<-unname(mac)


	#split data and y positions
	#-----------------

	splits <- cumsum(1:nrow(fobj$dat) %in% atrows)
	dlist <- split(fobj$dat, splits)
	y.atlist<-split(fobj$setup$y.at, splits)
	yspacelist<-lapply(y.atlist,function(x) ifelse(length(x)>1,abs(mean(diff(x)))/2,0.25))
	ylimlist<-lapply(1:length(y.atlist),function(x)
		c(min(y.atlist[[x]])-yspacelist[[x]], max(y.atlist[[x]])+yspacelist[[x]]))

	if  (sum(!is.na(lheights))==0) {

		lheights<-rep(NA,nrow(mac))
		lheights[1]<-fobj$setup$lheights[1]
		lheights[length(lheights)]<-fobj$setup$lheights[length(fobj$setup$lheights)]

		if (1 %in% atrows) {
			lheights[2]<-fobj$setup$lheights[1]
		}

		rheights<-length(dlist)/nrow(fobj$dat)*unlist(lapply(dlist,function(x) nrow(x)))
		nfact<-fobj$setup$lheights[2]/sum(rheights)
		lheights[is.na(lheights)][seq(1,sum(is.na(lheights)), by = 2)]<-rheights*nfact

		lheights[is.na(lheights)]<-fobj$setup$lheights[1]

	} else {
		if (length(lheights)!=(nrow(mac))) {
			stop("'lheights' must be a numeric vector of length 3 + 2*number of inserted subtitles
				(-1 if atrows includes 1).")
		}
	}

	#prepare output
	#-----------------
	if (all(is.na(subtitle))) {
		subtitle<-rep("",length(atrows))
	}

	fobjs<-vector(mode="list",length=length(dlist) + length(atrows))

	#subtitle rows
	for (ir in (1:length(inspos))) {
		fobjs[[inspos[ir]]]<-genfobj(dat = data.frame(subtitle[ir]),layout="t")
		fobjs[[inspos[ir]]]<-t_options(fobjs[[inspos[ir]]], x=0, adj=c(0,0.5))
	}

	cfobj<-list(
		setup = list(lmatrix=mac,
			lwidths=fobj$setup$lwidths,
			lheights=lheights,
			iheadfoot=c(FALSE, FALSE)),
		header = fobj$header,
		fobjs=fobjs)

	#generate split fobjs
	#-----------------
	ir<-1
	splitf<-which(unlist(lapply(fobjs,function(x) is.null(x))))
	for (ir in 1:length(dlist)) {

		#adapt setup
		fobji<-fobj
		fobji$dat<-dlist[[ir]]
		fobji$setup$y.at<-y.atlist[[ir]]
		fobji$setup$ylim<-ylimlist[[ir]]

		#for all text items: adapt y
		i<-7
		j<-3
		z<-4
		za<-1
		for (i in 1:length(fobj$setup$layout)) {

			for (j in 1:length(fobji$items[[i]])) {

				itemsub<-fobji$items[[i]][[j]]

				if (!is.list(itemsub)) {
					if (length(itemsub)==ncol(fobj$dat)) {
						fobji$items[[i]][[j]]<-
							split(fobj$items[[i]][[j]], splits)[[ir]]
					}
					if (names(fobji$items[[i]])[j]=="ylim") {
						fobji$items[[i]][[j]]<-ylimlist[[ir]]
					}
				} else {
					for (z in 1:length(fobji$items[[i]][[j]])) {
						itemsub<-fobji$items[[i]][[j]][[z]]

						if (!is.list(itemsub)) {

							if (length(itemsub)==ncol(fobj$dat)) {
								fobji$items[[i]][[j]][[z]]<-
									split(fobj$items[[i]][[j]][[z]], splits)[[ir]]
							}
							if (names(fobji$items[[i]][[j]])[z]=="ylim") {
								fobji$items[[i]][[j]][[z]]<-ylimlist[[ir]]
							}
						} else {
							for (za in 1:length(fobji$items[[i]][[j]][[z]])) {

								itemsub<-fobji$items[[i]][[j]][[z]][[za]]

								if (length(itemsub)==ncol(fobj$dat)) {
									fobji$items[[i]][[j]][[z]][[za]]<-
									split(fobj$items[[i]][[j]][[z]][[za]], splits)[[ir]]
								}
								if (names(fobji$items[[i]][[j]][[z]])[za]=="ylim") {
									fobji$items[[i]][[j]][[z]][[za]]<-ylimlist[[ir]]
								}
							}
						}
					}

				}
			}
		}
		cfobj[["fobjs"]][[splitf[ir]]]<-fobji

	}

	class(cfobj) <- c("cfobj", class(cfobj))

	return(cfobj)

}

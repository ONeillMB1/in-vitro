library(ggplot2)
require(ape)
require(ggtree)
require(phytools)
require(phangorn)
setwd("C:/Users/Mary/PepLab/data/Duplication/")

seg <- read.table("Master.simplified", header=F, sep='\t')
rep <- read.table("160129_Mtb_removeRegions_mergedCloserThan1000bp.bed", header=F, sep='\t')

rep$ymin = -Inf
rep$ymax = Inf

rect <- data.frame(xmin=1e6, xmax=2e6, ymin=-Inf, ymax=Inf)

z <- ggplot(seg) + 
  geom_segment(aes(x=V2, y=V1, xend=V3, yend=V1)) + 
  theme_bw() + 
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  #scale_x_continuous(limits=c(0e06, 1e06)) +
  ylab("Sample") +
  xlab("Genomic Position")
z
 
q <- p + geom_rect(data=rep, aes(xmin=V2, xmax=V3, ymin=ymin, ymax=ymax),
              fill = "lightblue",
              alpha = 0.75,
              inherit.aes = FALSE)

q + coord_polar()

------
WH <- seg[1:51,]

p2 <- ggplot(WH) + 
  geom_segment(aes(x=V2, y=V1, xend=V3, yend=V1)) + 
  theme_bw() + 
  theme(#axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  ylab("") +
  xlab("Genomic Position") +
  geom_rect(data=rep, aes(xmin=V2, xmax=V3, ymin=ymin, ymax=ymax),
            fill = "lightblue",
            alpha = 0.75,
            inherit.aes = FALSE)
p2
----
  
dup_tree <- read.tree("dup_tree.out")

tre <- midpoint(dup_tree)

tre.dat <- fortify(tre)
tre.dat$panel <- 'Tree'
tre.dat$label <- gsub("pilon_", "", tre.dat$label)

t <- ggtree(tre)



#Try ordering plot by tree order
#samps = sapply(strsplit(tre$tip.label, "_"), "[[", 2)
#samps2 = gsub(".vcf", "", samps)

#df.sort <- df[order(match(df$V1, samps)),]




-----
#Combine plots
tre.dat$panel <- factor(tre.dat$panel, levels = c("Tree", "Dups"))
seg$x <- tre.dat[match(seg$V1, tre.dat$label), 'x']
seg$y <- tre.dat[match(seg$V1, tre.dat$label), 'y']
seg$panel <- 'Dups'
seg$panel <- factor(seg$panel, levels = c("Tree", "Dups"))
rep$ymin = min(seg$y, na.rm=TRUE)
rep$ymax = max(seg$y, na.rm=TRUE)
rep$panel <- 'Dups'
rep$panel <- factor(rep$panel, levels = c("Tree", "Dups"))

expEvo <- c("5500.vcf", "5504.vcf", "3120.vcf", "3108.vcf", "3100.vcf", "3112.vcf", "3116.vcf")
exp55 <- c("5500.vcf", "5504.vcf")
exp31 <- c("3120.vcf", "3108.vcf", "3100.vcf", "3112.vcf", "3116.vcf")
eld <- c("ERR459440", "ERR459441", "ERR459442", "ERR459443", "ERR459444", "ERR459445", "ERR459446", "ERR459447", "ERR459448")



samps = c('55','31','eldholm')
xmin = rep(-Inf, 3)
xmax = rep(Inf, 3)
ymin = c(81, 84, 94)
ymax = c(82, 88, 102)
panel = 'Dups'
hi2 = data.frame(cbind(samps,xmin,xmax,ymin,ymax,panel))
hi2$panel <- factor(hi2$panel, levels = c("Tree", "Dups"))
hi2$xmin <- as.numeric(as.character(hi2$xmin))
hi2$xmax <- as.numeric(as.character(hi2$xmax))
hi2$ymin <- as.numeric(as.character(hi2$ymin))
hi2$ymax <- as.numeric(as.character(hi2$ymax))
hi2$col <- as.factor(c("ExpEvo", "ExpEvo", "Within-Host"))

hi <- hi2
hi$panel <- 'Tree'
hi$panel <- factor(hi$panel, levels = c("Tree", "Dups"))


p <- ggplot(mapping=aes(x=x, y=y)) + facet_grid(.~panel, scale="free_x") + theme_tree2()
p + geom_tree(data=tre.dat) + 
  geom_segment(data = seg, aes(x=V2, y=y, xend=V3, yend=y)) +
  theme(strip.background = element_blank(),
        strip.text.x = element_blank()) +
  geom_rect(data=rep, aes(xmin=V2, xmax=V3, ymin=ymin, ymax=ymax),
            fill = "lightblue",
            alpha = 0.50,
            inherit.aes = FALSE) +
  geom_rect(data=hi2, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill=col),
            alpha = 0.50,
            inherit.aes = FALSE) +
  geom_rect(data=hi, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill=col),
            alpha = 0.80,
            inherit.aes = FALSE)
  


#eldholm node = 320
#31 node = 315
#55 node = 313

+ 
  geom_rect(data=rep, aes(xmin=V2, xmax=V3, ymin=ymin, ymax=ymax), fill = "lightblue", alpha = 0.75, inherit.aes = FALSE)


temp <- ggtree(tre.dat)

require(ggplot2)

mtb26 <- read.table("C:/Users/Mary/PepLab/data/Mtb_invitro/160728_pi_theta/cleaned/ERR867527_rand50_w100K_n10K.pi", header=F, sep="\t", na.strings="na") #sputum (enriched)
mtb36 <- read.table("C:/Users/Mary/PepLab/data/Mtb_invitro/160728_pi_theta/cleaned/ERR867537_rand50_w100K_n10K.pi", header=F, sep="\t", na.strings="na") #culture
mtb19 <- read.table("C:/Users/Mary/PepLab/data/Mtb_invitro/160728_pi_theta/cleaned/ERR867520_rand50_w100K_n10K.pi", header=F, sep="\t", na.strings="na") #sputum (enriched)
mtb29 <- read.table("C:/Users/Mary/PepLab/data/Mtb_invitro/160728_pi_theta/cleaned/ERR867530_rand50_w100K_n10K.pi", header=F, sep="\t", na.strings="na") #Culture

all.pi.cleaned <- rbind(data.frame(samp="mtb26", window=mtb26$V2, pi=mtb26$V5),
                        data.frame(samp="mtb36", window=mtb36$V2, pi=mtb36$V5),
                        data.frame(samp="mtb19", window=mtb19$V2, pi=mtb19$V5),
                        data.frame(samp="mtb29", window=mtb29$V2, pi=mtb29$V5))

mtb26 <- read.table("C:/Users/Mary/PepLab/data/Mtb_invitro/160728_theta_theta/cleaned/ERR867527_rand50_w100K_n10K.theta", header=F, sep="\t", na.strings="na") #sputum (enriched)
mtb36 <- read.table("C:/Users/Mary/PepLab/data/Mtb_invitro/160728_theta_theta/cleaned/ERR867537_rand50_w100K_n10K.theta", header=F, sep="\t", na.strings="na") #culture
mtb19 <- read.table("C:/Users/Mary/PepLab/data/Mtb_invitro/160728_theta_theta/cleaned/ERR867520_rand50_w100K_n10K.theta", header=F, sep="\t", na.strings="na") #sputum (enriched)
mtb29 <- read.table("C:/Users/Mary/PepLab/data/Mtb_invitro/160728_theta_theta/cleaned/ERR867530_rand50_w100K_n10K.theta", header=F, sep="\t", na.strings="na") #Culture

all.theta.cleaned <- rbind(data.frame(samp="mtb26", window=mtb26$V2, theta=mtb26$V5),
                           data.frame(samp="mtb36", window=mtb36$V2, theta=mtb36$V5),
                           data.frame(samp="mtb19", window=mtb19$V2, theta=mtb19$V5),
                           data.frame(samp="mtb29", window=mtb29$V2, theta=mtb29$V5))


pmtb26 <- read.table("C:/Users/Mary/PepLab/data/Mtb_invitro/160728_pi_theta/uncleaned/ERR867527_rand50_w100K_n10K.pi", header=F, sep="\t", na.strings="na") #sputum (enriched)
pmtb36 <- read.table("C:/Users/Mary/PepLab/data/Mtb_invitro/160728_pi_theta/uncleaned/ERR867537_rand50_w100K_n10K.pi", header=F, sep="\t", na.strings="na") #culture
pmtb19 <- read.table("C:/Users/Mary/PepLab/data/Mtb_invitro/160728_pi_theta/uncleaned/ERR867520_rand50_w100K_n10K.pi", header=F, sep="\t", na.strings="na") #sputum (enriched)
pmtb29 <- read.table("C:/Users/Mary/PepLab/data/Mtb_invitro/160728_pi_theta/uncleaned/ERR867530_rand50_w100K_n10K.pi", header=F, sep="\t", na.strings="na") #Culture

all.pi.uncleaned <- rbind(data.frame(samp="pmtb26", window=pmtb26$V2, pi=pmtb26$V5),
                          data.frame(samp="pmtb36", window=pmtb36$V2, pi=pmtb36$V5),
                          data.frame(samp="pmtb19", window=pmtb19$V2, pi=pmtb19$V5),
                          data.frame(samp="pmtb29", window=pmtb29$V2, pi=pmtb29$V5))


pmtb26 <- read.table("C:/Users/Mary/PepLab/data/Mtb_invitro/160728_theta_theta/uncleaned/ERR867527_rand50_w100K_n10K.theta", header=F, sep="\t", na.strings="na") #sputum (enriched)
pmtb36 <- read.table("C:/Users/Mary/PepLab/data/Mtb_invitro/160728_theta_theta/uncleaned/ERR867537_rand50_w100K_n10K.theta", header=F, sep="\t", na.strings="na") #culture
pmtb19 <- read.table("C:/Users/Mary/PepLab/data/Mtb_invitro/160728_theta_theta/uncleaned/ERR867520_rand50_w100K_n10K.theta", header=F, sep="\t", na.strings="na") #sputum (enriched)
pmtb29 <- read.table("C:/Users/Mary/PepLab/data/Mtb_invitro/160728_theta_theta/uncleaned/ERR867530_rand50_w100K_n10K.theta", header=F, sep="\t", na.strings="na") #Culture

all.theta.uncleaned <- rbind(data.frame(samp="pmtb26", window=pmtb26$V2, theta=pmtb26$V5),
                             data.frame(samp="pmtb36", window=pmtb36$V2, theta=pmtb36$V5),
                             data.frame(samp="pmtb19", window=pmtb19$V2, theta=pmtb19$V5),
                             data.frame(samp="pmtb29", window=pmtb29$V2, theta=pmtb29$V5))




## Plots

piP <- ggplot(all.pi.cleaned) + 
  geom_line(aes(x=window, y=pi)) + 
  facet_wrap(~samp, nrow = 1) +
  ylab(expression(pi)) + 
  theme(plot.background=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position="right",
        legend.title=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.x=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_text(vjust = 1, size = rel(2)),
        axis.line=element_line(),
        plot.margin = unit(c(0.15, 0.5, 0.05, 0.5), "lines")
  )
piP


thP <- ggplot(all.theta.uncleaned) + 
  geom_line(aes(x=window, y=theta)) + 
  facet_wrap(~samp, nrow = 1) +
  ylab(expression(theta)) + 
  theme(plot.background=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position="none",
        legend.title=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.x=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_text(vjust = 1, size = rel(2)),
        axis.line=element_line(),
        plot.margin = unit(c(0.15, 0.5, 0.05, 0.5), "lines")
  )
thP
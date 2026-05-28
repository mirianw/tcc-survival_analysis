#Diretorio
setwd("C:/Users/souza/Downloads/tcc")

#Carregando pacotes
#install.packages("png")
library(survival)
library(survminer)
library(readxl)
library(png)

# Leitura dos dados
onco <- read_excel("base_oncologica.xlsx")


# Objeto de sobrevivência
ekm <- Surv(time = onco$Time, event = onco$Y)


# Plotar GRADE
onco$GRADE <- ifelse(onco$GRADE == 9, NA, onco$GRADE) #tratanto NA da variavel
table(onco$GRADE, useNA = "ifany")

grade <- survfit(ekm ~ GRADE, data = onco) #ajuste da curva p GRADE


png("figures/grade.png", width = 800, height = 600, res = 120)
ggsurvplot(grade, data = onco,     
           legend.title = "GRADE",
           xlab = "Tempo",
           ylab = "Prob.Sobrevivência")
dev.off()


# Plotar SITE
site <- survfit(ekm ~ SITE, data = onco)

png("figures/site.png", width = 800, height = 600, res = 120)
ggsurvplot(site, data = onco,
           xlab = "Tempo",
           ylab = "Prob.Sobrevivência")
dev.off()

# Plotar T STAGE
tstage <- survfit(ekm ~ T_STAGE, data = onco)

png("figures/tstage.png", width = 800, height = 600, res = 120)
ggsurvplot(tstage, data = onco,
           xlab = "Tempo",
           ylab = "Prob.Sobrevivência")
dev.off()

# Plotar N STAGE
nstage <- survfit(ekm ~ N_STAGE, data = onco)

png("figures/nstage.png", width = 800, height = 600, res = 120)
ggsurvplot(nstage, data = onco,
           xlab = "Tempo",
           ylab = "Prob.Sobrevivência")
dev.off()


# Plotar COND
onco$COND <- ifelse(onco$COND == 9, NA, onco$COND) #tratanto o NA da variavel
table(onco$COND, useNA = "ifany")

cond <- survfit(ekm ~ COND, data = onco)

png("figures/cond.png", width = 800, height = 600, res = 120)
ggsurvplot(cond, data = onco,
           legend.title = "COND",
           xlab = "Tempo",
           ylab = "Prob.Sobrevivência")
dev.off()




# TESTE LOGRANK
#install.packages("coin")
library(coin)
logrank_test(Surv(onco$Time,onco$Y)~factor(onco$GRADE),type="logrank")
logrank_test(Surv(onco$Time,onco$Y)~factor(onco$SITE),type="logrank")
logrank_test(Surv(onco$Time,onco$Y)~factor(onco$T_STAGE),type="logrank")
logrank_test(Surv(onco$Time,onco$Y)~factor(onco$N_STAGE),type="logrank")
logrank_test(Surv(onco$Time,onco$Y)~factor(onco$COND),type="logrank")
logrank_test(Surv(onco$Time,onco$Y)~factor(onco$SEX),type="logrank")


#Diretorio
setwd("C:/Users/souza/Downloads/tcc")

library(survival)
library(survminer)
library(readxl)

onco2 <- read_excel("base_dicotomizada.xlsx")

# objeto de sobrevivencia
ekm2 <- Surv(time = onco2$Time, event = onco2$Y)


# COX em todas as variaveis, decidindo quais vão entrar no modelo multivariado
fit_grade <- coxph(ekm2 ~ GRADE_bin, data = onco2)
summary(fit_grade) #p valor = 0.0429, entra 

fit_site <- coxph(ekm2 ~ SITE_bin, data = onco2)
summary(fit_site) #p valor =0.284, não entra 

fit_t <- coxph(ekm2 ~ T_STAGE_bin, data = onco2)
summary(fit_t) #p valor= 0.00192, entra

fit_n <- coxph(ekm2 ~ N_STAGE_bin, data = onco2)
summary(fit_n) #p valor = 0.0026, entra

fit_cond <- coxph(ekm2 ~ COND_bin, data = onco2)
summary(fit_cond) #p valor = 9.44e-10, entra

fit_sexo <- coxph(ekm2 ~ SEX_bin, data = onco2)
summary(fit_sexo) #p valor = 0.408, não entra

fit_trt <- coxph(ekm2 ~ TRT_bin, data = onco2)
summary(fit_trt) #p valor = 0.336, não entra



# modelo ajustado 
fit <- coxph(
  ekm2 ~ GRADE_bin + T_STAGE_bin + N_STAGE_bin + COND_bin,
  data = onco2
)

summary(fit)

#proporcionalidade dos riscos
teste_ph <- cox.zph(fit)
teste_ph

png("figures/teste_ph.png", width = 800, height = 600, res = 120)
plot(teste_ph)
dev.off()


#Graficos do modelo final  logaritimo do risco acumulado

library(survival)

# Configuração da área gráfica
par(mar = c(4,4,2,2))
par(mfrow = c(2,2))

# --- GRÁFICO 1: GRADE_bin ---
fit1 <- survfit(Surv(Time, Y) ~ GRADE_bin, data = onco2)

plot(fit1, fun = "cloglog", lty = c(1,2),
     xlab = "Tempo (dias)",
     ylab = expression(log(Lambda(t))),
     main = "GRADE",
     bty = "n")

legend("bottomright",
       legend = c("GRADE = 0", "GRADE = 1"),
       lty = c(1,2),
       bty = "n",
       cex = 0.8)

# --- GRÁFICO 2: T_STAGE_bin ---
fit2 <- survfit(Surv(Time, Y) ~ T_STAGE_bin, data = onco2)

plot(fit2, fun = "cloglog", lty = c(1,2),
     xlab = "Tempo (dias)",
     ylab = expression(log(Lambda(t))),
     main = "T_STAGE",
     bty = "n")

legend("bottomright",
       legend = c("T_STAGE = 0", "T_STAGE = 1"),
       lty = c(1,2),
       bty = "n",
       cex = 0.8)

# --- GRÁFICO 3: N_STAGE_bin ---
fit3 <- survfit(Surv(Time, Y) ~ N_STAGE_bin, data = onco2)

plot(fit3, fun = "cloglog", lty = c(1,2),
     xlab = "Tempo (dias)",
     ylab = expression(log(Lambda(t))),
     main = "N_STAGE",
     bty = "n")

legend("bottomright",
       legend = c("N_STAGE = 0", "N_STAGE = 1"),
       lty = c(1,2),
       bty = "n",
       cex = 0.8)

# --- GRÁFICO 4: COND_bin ---
fit4 <- survfit(Surv(Time, Y) ~ COND_bin, data = onco2)

png("figures/fit4.png", width = 800, height = 600, res = 120)
plot(fit4, fun = "cloglog", lty = c(1,2),
     xlab = "Tempo (dias)",
     ylab = expression(log(Lambda(t))),
     main = "COND",
     bty = "n")

legend("bottomright",
       legend = c("COND = 0", "COND = 1"),
       lty = c(1,2),
       bty = "n",
       cex = 0.8)
dev.off()
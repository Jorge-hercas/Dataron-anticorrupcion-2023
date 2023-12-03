

sanciones <- vroom::vroom("data/sanciones.csv")
shapefile <- sf::read_sf("shapefiles/mexico/dest_2015gw.shp")
data <- vroom::vroom("data/declaraciones.csv")


data$estado[data$estado == "BajaCaliforniaSur"] <- "Baja California Sur"
data$estado[data$estado == "QUINTANAROO"] <- "Quintana Roo" 
data$estado[data$estado == "EDOMEX"] <- "México"
data$estado[data$estado == "GUANAJUATO"] <- "Guanajuato"
data$estado[data$estado == "SAEM"] <- "México"
data$estado[data$estado == "SESEAM"] <- "Michoacán de Ocampo"    
data$estado[data$estado == "SESEA_AGUASCALIENTES"] <- "Aguascalientes"
data$estado[data$estado == "SESEA_JALISCO"] <- "Jalisco"
data$estado[data$estado == "TABASCO"] <- "Tabasco"
data$estado[data$estado == "TLAXCALA"] <- "Tlaxcala"
data$estado[data$estado == "ZACATECAS"] <- "Zacatecas"

x <- 
  sanciones |> 
  group_by(falta) |> 
  summarise(value = n()) |> 
  arrange(desc(value)) |> 
  na.omit() 


data <-
  data |> 
  mutate(
    ingresos_otros_tot = otros_ingresos + ingresos_actividad_comercial + ingresos_actividad_financiera
    + ingresos_enajenacion_bienes + ingresos_servicios_profesionales
  )


identificados <- 
  data |> 
  filter(
    (remuneracion_anual >=  min(boxplot(data$remuneracion_anual[data$remuneracion_anual > 0], plot = F)$out)
     & ingresos_otros_tot >= min(boxplot(data$ingresos_otros_tot[data$ingresos_otros_tot > 0], plot = F)$out)
     & conflicto_interes == T) | remuneracion_anual < 0
  ) |> 
  select(nombre, apellido, seg_apellido, conflicto_interes, remuneracion_anual, ingresos_otros_tot,
         dependencia,tipo_declaracion
  ) |> 
  arrange(desc(remuneracion_anual)) 




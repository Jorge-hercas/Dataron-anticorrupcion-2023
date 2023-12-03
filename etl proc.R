

path <- "/Users/jorgehca/Downloads/s3s"
states <- list.files(path)


tabla <-
  tibble(
    nombre = NA,
    apellido = NA,
    apellido2 = NA,
    dependencia = NA,
    puesto = NA,
    sancionador = NA,
    falta = NA,
    id_falta = NA,
    sancion_monetaria = NA,
    resolucion = NA,
    url_resolucion = NA,
    plazo_inhabilitacion = NA,
    fecha_in = NA,
    fecha_fin = NA,
    observaciones = NA,
    estado = NA
  )


tryCatch({
  
  for (i in 1:length(states)){
    
    path_files <- paste0(path,"/",states[i],"/", list.files(paste0(path, "/",states[i])))
    
    for (j in 1:length(path_files)){
      
      x <- fromJSON(path_files[j])
      
      
      tabla_2 <- tibble(
        nombre = x$servidorPublicoSancionado$nombres,
        apellido = x$servidorPublicoSancionado$primerApellido,
        apellido2 = x$servidorPublicoSancionado$segundoApellido,
        dependencia = x$institucionDependencia$nombre,
        puesto = x$servidorPublicoSancionado$puesto,
        sancionador = x$autoridadSancionadora,
        falta = x$tipoFalta$descripcion,
        id_falta = x$tipoFalta$clave,
        sancion_monetaria = x$multa$monto,
        resolucion = x$resolucion$fechaResolucion,
        url_resolucion = x$resolucion$url,
        plazo_inhabilitacion = x$inhabilitacion$plazo,
        fecha_in = x$inhabilitacion$fechaInicial,
        fecha_fin = x$inhabilitacion$fechaFinal,
        observaciones = x$observaciones,
        estado = states[i]
      )
      
      tabla <- tabla |> 
        bind_rows(tabla_2)
      
    }
    
    
  }
  
  
}, error = function(e){})



tabla |> 
  filter(estado != "")

tabla <- tabla[!duplicated(tabla),]


states |> 
  as_tibble() |> 
  filter(!value %in% unique(tabla$estado))



vroom::vroom_write(tabla, file = "data/sanciones.csv")


data <- vroom::vroom("data/declaraciones.csv", delim = "\t")




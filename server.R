

function(input, output, session){
  
  
  
  
  
  
  
  output$general_plot <- renderEcharts4r({

    x |> 
      head(15) |> 
      mutate(color = head(rep(RColorBrewer::brewer.pal(9, "YlOrRd"),4),15)) |> 
      e_charts(falta) |> 
      e_bar(value, name = "Razón de la sanción") |> 
      e_tooltip(trigger = "axis", confine =T) |> 
      e_theme("auritus") |> 
      e_legend(right = 0) |> 
      e_add("itemStyle",color)
    
  })
  
  
  output$mapa <- renderMapboxer({
    
    shapefile |> 
      left_join(
        data |> 
          group_by(estado) |> 
          summarise(n = n()) |> 
          na.omit(),
        by = c("NOM_ENT" = "estado")
      ) |> 
      tidyr::replace_na(list(n = 0)) |> 
      mutate(color = scales::col_quantile("Reds", n )(n)) |> 
      as_mapbox_source() |> 
      mapboxer(
        pitch = 25,
        style = "mapbox://styles/jorgehdez1998/clkrtw9ex014m01qk59o39e2q",
        token = "pk.eyJ1Ijoiam9yZ2VoZGV6MTk5OCIsImEiOiJja2o2dnZzdmowemRsMzNueW5zNmJ6ZmdoIn0.s3BJeDpXW5GMy2Kln139Eg"
      ) |> 
      add_fill_layer(
        fill_color = c("get", "color"), 
        fill_opacity = 0.4
      ) |> 
      fit_bounds(
        bounds = sf::st_bbox(shapefile)
      ) |> 
      add_text_control(text = "Conteo de declaraciones por region", css_text = "background: transparent;
                       size: 28px")
    
    
  })
  
  
  output$ingresos_mean <- renderCountup({
    
    countup::countup(
      mean(
        data$remuneracion_anual, na.rm = T)/12, 
      options = list(separator = ",", prefix = "$")
    )
    
  })
  
  
  calculo <- reactive({
    
    if (input$ingreso_est >= min(boxplot(data$remuneracion_anual[data$remuneracion_anual > 0], plot = F)$out)/12){
      ingresos_ponderador <- 0.3
    }else{ingresos_ponderador <- 0}
    
    if (input$otros_ingreso_est >= min(boxplot(data$ingresos_otros_tot[data$ingresos_otros_tot > 0], plot = F)$out)/12){
      ingresos_otros_ponderador <- 0.15
    }else{ingresos_otros_ponderador <- 0}
    
    if (between(input$inmuebles_est, 1,2) == T & 
        input$ingreso_est < min(boxplot(data$remuneracion_anual[data$remuneracion_anual > 0], plot = F)$out)/12 ){
      bienes_pond <- 0
    }else if (input$inmuebles_est >= 3 & 
              input$ingreso_est < min(boxplot(data$remuneracion_anual[data$remuneracion_anual > 0], plot = F)$out)/12){
      bienes_pond <- 0.25
    }else{
      bienes_pond <- 0.25
    }
    
    if (input$vehiculos_est == T){
      vehiculos_pond <- 0.1
    }else{
      vehiculos_pond <- 0
    }
    
    if (input$bienesmueb_est == T){
      bienesmuebles_pond <- 0.05
    }else{
      bienesmuebles_pond <- 0
    }
    
    if (input$conflicto_est == T){
      conflicto_pond <- .15
    }else{
      conflicto_pond <- 0
    }
    
    calculo <- bienes_pond+bienesmuebles_pond+conflicto_pond+ingresos_ponderador+vehiculos_pond+ingresos_otros_ponderador
    calculo
    
  })
  
  
  output$nivel_riesgo <- renderEcharts4r({
    
    req(calculo())
    
    tibble(
      label = "x",
      value = rep(10,10),
      val_ar = 1:10,
      color = RColorBrewer::brewer.pal(10,"RdYlGn")
    ) |> 
      mutate(color = factor(color, rev(RColorBrewer::brewer.pal(10,"RdYlGn")) )) |> 
                                                arrange(val_ar) |> 
      group_by(color) |> 
      e_charts(label) |> 
      e_bar(value, stack = "x") |> 
      e_add("itemStyle", color) |> 
      e_flip_coords() |> 
      e_legend(show = FALSE) |> 
      e_mark_line(data = list(xAxis = calculo()*100), 
                  title = "Nivel actual de riesgo", 
                  symbol = "none",
                  lineStyle = list(
                    color = "#ede618",
                    width = 2,
                    type = "dashed"
                  ),
                  label = list(
                    fontStyle = "oblique",
                    fontSize = 15,
                    fontColor = "gray"
                  )
      )
    
    
  }) |> 
    bindEvent(input$calcular)
  
  
  output$riesgo_shape <- renderEcharts4r({
    
    req(calculo())
    
    tibble(
      val = c(calculo(),calculo()-.5),
      color = c("#f5edd7", "#f2b716")
    ) |> 
      e_charts() |> 
      e_liquid(val,
               label = list(fontSize = 20),
               color = color,
               radius = "90%",
               outline = FALSE,
               shape = "path://M29.1,20.3L19.5,4.9C18.7,3.7,17.4,3,16,3s-2.7,0.7-3.5,1.9L2.9,20.3c-1.1,1.8-1.2,3.9-0.2,5.7c1,1.8,2.9,2.9,5,2.9h16.6  c2.1,0,4-1.1,5-2.9C30.3,24.2,30.2,22.1,29.1,20.3z M13.9,10.9c1-1.2,3.1-1.2,4.1,0c0.5,0.6,0.8,1.4,0.6,2.2l-0.7,5  c-0.1,0.5-0.5,0.9-1,0.9h-2c-0.5,0-0.9-0.4-1-0.9l-0.7-5C13.2,12.3,13.4,11.5,13.9,10.9z M16.5,25h-1c-1.4,0-2.5-1.1-2.5-2.5  s1.1-2.5,2.5-2.5h1c1.4,0,2.5,1.1,2.5,2.5S17.9,25,16.5,25z"
      )
    
  }) |> 
    bindEvent(input$calcular)
  
  
  
  observeEvent(input$mail,{
    
    shinyalert(
      title = "¿Quieres enviar una alerta a los colaboradores?", type = "input",
      text = "Introduce la dirección de correo.",
      closeOnEsc = FALSE,
      imageUrl = "https://cdn-icons-png.flaticon.com/512/1066/1066343.png",
      closeOnClickOutside = FALSE,
      showConfirmButton = TRUE,
      confirmButtonCol = "#99CEFF",
      callbackR = function(value) {
        
        #writexl::write_xlsx(data_tabla(), path = "datatabla.xlsx")
        
        gm_mime() |>
          gm_to(value) |>
          gm_from(mail) |>
          gm_subject("¡Alerta sobre estatus actual!") |>
          gm_html_body(paste0(
            "<p> Saludos, colaborador con el correo ",value," </p>
    <p> Nuestro sistema arroja que actualmente cuenta con un score alto (95%) de probabilidad en cuanto a prácticas ilícitas.
    Este correo es únicamente informativo y no implica que se vaya a realizar una investigación en su contra, sin embargo,
    es conveniente que realice una auditoria de sus actividades, ingresos y bienes declarados para asegurarse de tener todo en orden.
    </p>
    <br>")) |> 
          gm_send_message()
        
        shinyalert(paste("Correo enviado con éxito"),
                   imageUrl = "https://cdn-icons-png.flaticon.com/512/1066/1066343.png",
                   closeOnEsc = TRUE,
                   showConfirmButton = TRUE,
                   confirmButtonCol = "#99CEFF"
        )
        
        
      }
    )
  })
  
  
  output$dec_tot <- renderCountup({
    
    countup::countup(
      nrow(data), 
      options = list(separator = ",")
    )
    
  })
  
  output$dec_conf <- renderCountup({
    
    countup::countup(
      sum(data$conflicto_interes[data$conflicto_interes == T], na.rm = T), 
      options = list(separator = ",")
    )
    
  })
  
  output$dec_atip <- renderCountup({
    
    countup::countup(
      length(boxplot(data$remuneracion_anual/12, plot = F)$out), 
      options = list(separator = ",")
    )
    
  })
  
  
  output$tabla_fin <- renderUI({
    
    identificados[!duplicated(identificados),] |> 
      table(
        removeWrapper = T, isHeaderSticky = T,
        isStriped = TRUE,
        color = "success",
        isCompact = TRUE,
        selectionMode = "multiple"
      )
    
  })
  
  
}



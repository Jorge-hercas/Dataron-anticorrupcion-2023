





items <- tagList(
  tab(
    key = 1,
    title = div(
      class = "flex items-center gap-1",
      icon("home"),
      "Información general"
    ),
    card(
      card_body(
        "Un vistazo general a las declaraciones de los trabajadores gubernamentales. 
        Su información y causas principales de sanciones.",
        echarts4rOutput("general_plot", width = "100%")
      )
    ),
    br(),
    div(),
    div(
      #align = "center",
      class = "flex gap-1",
      width = 6,
      #h1("Conteo de declaraciones por region", id = "decla_region"),
    #  tags$style(HTML("#decla_region{color: #8d8f8e;
     #                     font-size: 35px;
      #                     }")),
      mapboxerOutput("mapa", width = 1000, height = 800),
      div(
          align = "center",
          h1("Ingresos promedio por trabajador", id = "ing_trabajador"),
          countupOutput("ingresos_mean"),
          tags$style(HTML("#ing_trabajador{color: #8d8f8e;
                          font-size: 35px;
                           }")),
          br(),br(),
          h1("Declaraciones totales", id = "dec_tot_text"),
          countupOutput("dec_tot"),
          tags$style(HTML("#dec_tot_text{color: #8d8f8e;
                          font-size: 35px;
                           }")),
          br(),br(),
          h1("Trabajadores con conflictos de interés", id = "dec_conf_text"),
          countupOutput("dec_conf"),
          tags$style(HTML("#dec_conf_text{color: #8d8f8e;
                          font-size: 35px;
                           }")),
          br(),br(),
          h1("Trabajadores con ingresos atípicos", id = "dec_atip_text"),
          countupOutput("dec_atip"),
          tags$style(HTML("#dec_atip_text{color: #8d8f8e;
                          font-size: 35px;
                           }"))
        
        )
    )
  ),
  tab(
    key = 3,
    title = 
      div(
        class = "flex items-center gap-1",
        icon("building"),
        "Calculadora: IPC"
      ),
    card(
      card_body(
        "Indice de probabilidad de corrupción",
        br(),
       divider(),
       br(),
       "¿Quieres saber si un colaborador gubernamental es un candidato posible a cometer actos de corrupción? 
       Con la siguiente calculadora basada en un modelo de probabilidad vamos a darte una aproximación a ello.",
       br(),br(),
       div(
         class = "flex gap-1",
         numeric_input(inputId ="ingreso_est", label = "Ingreso mensual estimado", value = 10000,placeholder="0.00"),
         numeric_input(inputId ="otros_ingreso_est", label = "Otros ingresos mensuales", value = 0,placeholder="0.00")
       ),
       br(),
       div(
         class = "flex gap-1",
         slider_input(inputId = "inmuebles_est",
                      label = "Inmuebles declarados",
                      showTooltip = TRUE,
                      radius = "none",
                      step = 1,
                      maxValue = 10,
                      minValue = 0,
                      value = 0,
                      className = "max-w-md",
                      showSteps = TRUE,
                      color = "foreground",
                      startContent = icon("house"),
                      endContent = icon("building"),
                      size = "sm"),
         spacer(y = 19, x = 50),
         checkbox_input(inputId = "vehiculos_est", value = TRUE, "¿Declaró vehículos?"),
         spacer( x = 50),
         checkbox_input(inputId = "bienesmueb_est", value = TRUE, "¿Declaró bienes muebles?"),
         spacer( x = 50),
         checkbox_input(inputId = "conflicto_est", value = TRUE, "¿Hay conflicto de interés?")
       ),
     #  div(
    #     class = "flex gap-1",
     #    select_input(
      #     "states_sel",
       #    label = "Región de origen",
        #   unique(na.omit(data$estado)),
         #  value = "Baja California Sur"
    #     )
     #  ),
       br(),br(),
       div(align = "center", actionButton("calcular", label = "Generar estimación", icon = icon("chart-pie")),
           echarts4rOutput("nivel_riesgo", width = 1200, height = 200),br(),
           echarts4rOutput("riesgo_shape"),
           br(),
           actionButton("mail", label = "Enviar correo de alerta", icon = icon("envelope"))
           )
      )
    )
  ),
  tab(
    key = 4,
    title = 
      div(
        class = "flex items-center gap-1",
        icon("person"),
        "Posibles casos identificados"
      ),
    card(
      card_body(
        "En esta sección se presentan posibles casos de corrupción que se han identificado, 
        basándonos en el algoritmo preestablecido para la calculadora.",
        uiOutput("tabla_fin")
      )
    )
  )
)




nextui_page(
  dark_mode = T,
  h1(typed(c("DATATON ANTICORRUPCION 2023", "CORRUPCION EN MÉXICO"),typeSpeed = 20,backSpeed = 20), id = "titlepanel"),
  tags$style(HTML("#titlepanel{color: #8d8f8e;
                          font-size: 50px;
                           }")),
  div(
    style = "height:50px",
    class = "grid gap-4 grid-cols-3 grid-rows-3 m-5",
    user(
      name = "PNA",
      description = "SESNA",
      avatarProps = JS(paste0(
        "{
        src: 'https://img.freepik.com/vector-premium/dia-anticorrupcion_47834-172.jpg'
      }"
      ))
    )
  ),
  div(
    class = "flex gap-1"
  ),
  spacer(y = 2),
  tabs(inputId = "tabs1",
       items
  ),
  div(
    class = "grid gap-4 grid-cols-3 grid-rows-3 m-5"
  )
)


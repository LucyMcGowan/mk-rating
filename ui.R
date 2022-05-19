tagList(
  dashboardPage(
    dashboardHeader(title = "Disney Ride Picker"),
    dashboardSidebar(
      sidebarMenu(
        id = "tabs",
        menuItem(
          "Age", tabName = "age"
        ),
        menuItem("Ride 1",
                 tabName = "ride_1"),
        menuItem("Ride 2", tabName = "ride_2"),
        menuItem("Output", tabName = "output")
      ),
      disable = TRUE
    ),
    dashboardBody(
      includeCSS("www/custom.css"),
      tabItems(
        tabItem(
          tabName = "age",
          box(width = 2, status = "warning"),
          box(
            width = 8,
            h4("This application is designed to help you pick your next ride given your ratings for the last two rides you went on."),
            radioButtons("age_group", "First, which best describes your age category?", choices = unique(dat$age)),
            actionButton("next_ride1", "Next",
                         style = "background-color: #f1c400;")
          ),
          box(width = 2, status = "warning")
        ),
        tabItem(
          tabName = "ride_1",
          box(width = 2, status = "warning"),
          box(
            width = 8,
            selectInput("ride1", "What is the last ride you went on?", selected = "",
                        choices = c("", mk_rides)),
            conditionalPanel(
              "input.ride1 != ''",
              sliderInput("ride1_rating", "Rate Ride 1", value = 5, min = 1, max = 5),
              actionButton("next_ride2", "Next",
                           style = "background-color: #f1c400;")
            )
          ),
          box(width = 2, status = "warning")
        ),
        tabItem(
          tabName = "ride_2",
          box(width = 2, status = "warning"),
          box(
            width = 8,
            selectInput("ride2", "What is the second to last ride you went on?", choices = c("", mk_rides[!mk_rides == "Meet Ariel at Her Grotto"])),
            conditionalPanel(
              "input.ride2 != ''",
              sliderInput("ride2_rating", "Rate Ride 1", value = 5, min = 1, max = 5),
              actionButton("next_output", "Tell me what to ride next!",
                           style = "background-color: #f1c400;")
            )
          ),
          box(width = 2, status = "warning")
        ),
        tabItem(
          tabName = "output",
          fluidRow(
            box(width = 2, status = "warning"),
            box(
              width = 8, align = "center",
              valueBoxOutput("r1", width = 6),
              valueBoxOutput("r2", width = 6)
            ),
            box(width = 2, status = "warning")),
          fluidRow(
            box(width = 2, status = "warning"),
            box(
              width = 8, status = "success",
              uiOutput("your_ride"),
              actionButton("see_table", "I'd like to see a table of all of my predicted ride ratings",
                           style = "background-color: #f1c400;"),
              br()
            ),
            box(width = 2, status = "warning")),
          conditionalPanel("input.see_table == true",
                           box(width = 2, status = "warning"),
                           box(
                             width = 8,
                             dataTableOutput("table")
                           ),
                           box(width = 2, status = "warning")
          )
        )
      )
    )
  ),
  tags$footer(
    box(width = 12, align = "right",
        actionButton("start_over", "I'd like to start over",
                     style = "background-color: #f1c400;")
    )
  )
)

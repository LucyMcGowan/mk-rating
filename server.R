function(input, output, session) {

  output$r1 <- renderValueBox({
    r <- ifelse(input$ride1_rating < 3, "red", "green")
    r <- ifelse(input$ride1_rating == 3, "yellow", r)
    valueBox(value = input$ride1_rating,
             subtitle = glue("{input$ride1} Rating"),
             icon = if (input$ride1_rating < 3) {
               icon("thumbs-down")
             } else {
               icon("thumbs-up")
             },
             color = r
    )
  })
  output$r2 <- renderValueBox({
    r <- ifelse(input$ride2_rating < 3, "red", "green")
    r <- ifelse(input$ride2_rating == 3, "yellow", r)
    valueBox(value = input$ride2_rating,
             subtitle = glue("{input$ride2} Rating"),
             icon = if (input$ride2_rating < 3) {
               icon("thumbs-down")
             } else {
               icon("thumbs-up")
             },
             color = r
    )
  })

  output$your_ride <- renderUI({
    tagList(h3(glue("We recommend that you go on {out()$ride[1]} next.")),
            h4(glue("People who rated {input$ride1} and {input$ride2} similar to you gave {out()$ride[1]} an average rating of {round(out()$predicted_rating[1],1)}"))
    )
  })
  observeEvent(input$start_over, {
    updateSelectInput(session, "ride1", selected = "")
    updateSelectInput(session, "ride2", selected = "")
  })
  observeEvent(input$ride1, {
    updateSliderInput(session, "ride1_rating", label = glue("How would you rate {input$ride1}?"))
    updateSelectInput(session, "ride2", choices = c("", mk_rides[!mk_rides == input$ride1]))
  })
  observe({
    updateSliderInput(session, "ride2_rating", label = glue("How would you rate {input$ride2}?"))
  })
  observeEvent(input$start_over, {
    updateTabItems(session, "tabs", "age")
  })
  observeEvent(input$next_ride1, {
    updateTabItems(session, "tabs", "ride_1")
  })

  observeEvent(input$next_ride2, {
    updateTabItems(session, "tabs", "ride_2")
  })

  observeEvent(input$next_output, {
    updateTabItems(session, "tabs", "output")
  })

  out <- reactive({
    req(input$ride1 != "")
    req(input$ride2 != "")
    mk_rides <- mk_rides[!(mk_rides %in% c(input$ride1, input$ride2))]
    out <- map_df(mk_rides, run_model, age_group = input$age_group, ride1 = input$ride1, ride2 = input$ride2)
    out <- out[out[, 1] == input$ride1_rating, ]
    out <- out[out[, 2] == input$ride2_rating, ]
    out %>%
      arrange(-predicted_rating) %>%
      mutate(predicted_rating = ifelse(predicted_rating > 5, 5, predicted_rating),
             predicted_rating = ifelse(predicted_rating < 1, 1, predicted_rating))
  })
  output$table <- renderDataTable({
    o <- out()[, 3:4]
    names(o) <- c("Ride", "Predicted Rating")
    datatable(o, options = list(pageLength = 5)) %>%
      formatRound('Predicted Rating', 2) %>%
      formatStyle(
        'Predicted Rating',
        backgroundColor = styleInterval(c(3, 4), c('#ff7f7f', '#ffffe0', '#90ee90'))
      )

  })
}

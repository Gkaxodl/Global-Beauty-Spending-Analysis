library(shiny)
library(dplyr)
library(readr)
library(ggplot2)
library(viridis)
library(ggrepel)

# Load the portfolio dataset from the repository data folder
beauty_data <- read_csv("data/beauty_data_final_50.csv", show_col_types = FALSE)

beauty_data <- beauty_data |>
  mutate(
    continent = case_when(
      country %in% c("South Korea", "Japan", "China", "India", "Indonesia",
                     "Vietnam", "Thailand", "Malaysia", "Philippines", "Pakistan",
                     "Bangladesh", "Singapore") ~ "Asia",
      country %in% c("Germany", "France", "United Kingdom", "Italy", "Spain",
                     "Netherlands", "Sweden", "Poland", "Greece", "Portugal",
                     "Russia", "Switzerland", "Norway", "Denmark", "Finland",
                     "Turkey") ~ "Europe",
      country %in% c("United States", "Canada", "Mexico", "Costa Rica", "Cuba") ~ "North America",
      country %in% c("Brazil", "Argentina", "Colombia", "Chile", "Peru") ~ "Latin America",
      country %in% c("South Africa", "Nigeria", "Kenya", "Egypt", "Ghana", "Morocco") ~ "Africa",
      country %in% c("Australia", "New Zealand") ~ "Oceania",
      country %in% c("Saudi Arabia", "United Arab Emirates", "Israel", "Iran") ~ "Middle East",
      TRUE ~ "Other"
    )
  )

x_choices <- list(
  "GDP per Capita" = "gdp_pc",
  "Gender Inequality Index" = "gii",
  "Female Labor Force Participation" = "flfpr"
)

y_choices <- list(
  "Beauty Spending per Capita" = "beauty_pc",
  "Beauty Spending (% of Household Income)" = "beauty_pct"
)

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      label { font-size: 13px; }
      .selectize-input { font-size: 13px; }
      .selectize-dropdown { font-size: 13px; }
    "))
  ),
  titlePanel("Global Beauty Spending Explorer"),
  fluidRow(
    column(
      3,
      selectInput("xvar", "X Variable:", choices = x_choices),
      selectInput("yvar", "Y Variable:", choices = y_choices),
      checkboxGroupInput(
        "continent",
        "Select Regions:",
        choices = sort(unique(beauty_data$continent)),
        selected = sort(unique(beauty_data$continent))
      )
    ),
    column(
      9,
      tabsetPanel(
        tabPanel("Scatter Plot", plotOutput("scatterPlot"), textOutput("summaryText")),
        tabPanel("Box Plot", plotOutput("boxPlot")),
        tabPanel("Bubble Chart", plotOutput("bubblePlot"))
      )
    )
  )
)

server <- function(input, output) {

  filtered_data <- reactive({
    req(input$continent)
    beauty_data |> filter(continent %in% input$continent)
  })

  output$scatterPlot <- renderPlot({
    plot_data <- filtered_data()
    label_cutoff <- quantile(plot_data[[input$yvar]], 0.90, na.rm = TRUE)

    ggplot(
      plot_data,
      aes(
        x = .data[[input$xvar]],
        y = .data[[input$yvar]],
        color = continent
      )
    ) +
      geom_point(size = 3, alpha = 0.85) +
      geom_smooth(method = "loess", se = FALSE, color = "black", linewidth = 0.5) +
      geom_text_repel(
        aes(label = ifelse(.data[[input$yvar]] >= label_cutoff, country, "")),
        size = 3,
        max.overlaps = 15,
        show.legend = FALSE
      ) +
      scale_color_viridis_d() +
      theme_minimal() +
      labs(
        x = names(x_choices)[x_choices == input$xvar],
        y = names(y_choices)[y_choices == input$yvar],
        color = "Region"
      )
  })

  output$boxPlot <- renderPlot({
    ggplot(
      filtered_data(),
      aes(x = continent, y = .data[[input$yvar]], fill = continent)
    ) +
      geom_boxplot(alpha = 0.85) +
      scale_fill_viridis_d() +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 30, hjust = 1)) +
      labs(
        x = "Region",
        y = names(y_choices)[y_choices == input$yvar],
        fill = "Region"
      )
  })

  output$bubblePlot <- renderPlot({
    ggplot(
      filtered_data(),
      aes(
        x = gdp_pc,
        y = .data[[input$yvar]],
        size = flfpr,
        color = continent
      )
    ) +
      geom_point(alpha = 0.7) +
      scale_color_viridis_d() +
      theme_minimal() +
      labs(
        x = "GDP per Capita",
        y = names(y_choices)[y_choices == input$yvar],
        size = "Female Labor Force Participation",
        color = "Region"
      )
  })

  output$summaryText <- renderText({
    avg <- mean(filtered_data()[[input$yvar]], na.rm = TRUE)
    paste(
      "Average",
      names(y_choices)[y_choices == input$yvar],
      "across selected regions:",
      round(avg, 2)
    )
  })
}

shinyApp(ui = ui, server = server)

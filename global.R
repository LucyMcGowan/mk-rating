## Load packages ----

library(tidyverse)
library(glue)
library(shiny)
library(shinydashboard)
library(DT)

## List Magic Kingdom Rides to include ----

mk_rides <- c(
  "Meet Ariel at Her Grotto",
  "Astro Orbiter",
  "Big Thunder Mountain Railroad",
  "Buzz Lightyear's Space Ranger Spin",
  "Prince Charming Regal Carrousel",
  "Country Bear Jamboree",
  "Dumbo the Flying Elephant",
  "Enchanted Tales with Belle",
  "\"it's a small world\"",
  "Jungle Cruise",
  "Liberty Square Riverboat",
  "Mad Tea Party",
  "Mickey's PhilharMagic",
  "Monsters, Inc. Laugh Floor",
  "Meet Tinker Bell at Town Square Theater",
  "Meet Dashing Disney Pals as Circus Stars at Pete’s Silly Side Show",
  "Peter Pan's Flight",
  "Pirates of the Caribbean",
  "Tom Sawyer Island",
  "Space Mountain",
  "Splash Mountain",
  "Swiss Family Treehouse",
  "Seven Dwarfs Mine Train",
  "See Mickey at Town Square Theater",
  "See Princess Tiana and a Visiting Princess at Princess Fairytale Hall",
  "See Cinderella and a Visiting Princess at Princess Fairytale Hall",
  "Casey Jr. Splash 'N' Soak Station",
  "The Barnstormer",
  "Walt Disney's Enchanted Tiki Room",
  "The Hall of Presidents",
  "The Haunted Mansion",
  "The Magic Carpets of Aladdin",
  "The Many Adventures of Winnie the Pooh",
  "Tomorrowland Speedway",
  "Tomorrowland Transit Authority PeopleMover",
  "Under the Sea ~ Journey of the Little Mermaid",
  "Walt Disney World Railroad - Main Street, U.S.A.",
  "Walt Disney's Carousel of Progress",
  "Walt Disney World Railroad - Frontierland",
  "Walt Disney World Railroad - Fantasyland"
)
mk_rides <- mk_rides[order(mk_rides)]

## Read in and clean data ----

d <- read_csv("ride_ratings.csv")
dat <- d %>%
  select(-created_at) %>%
  filter(name %in% mk_rides) %>%
  group_by(survey_id, name) %>%
  mutate(id = 1:n()) %>%
  ungroup() %>%
  pivot_longer(cols = rating_preschool:rating_seniors,
               names_to = "age") %>%
  mutate(value = ifelse(value == "NULL", NA, as.numeric(value)),
         age = gsub("rating_", "", age),
         age = gsub("_", " ", age)) %>%
  pivot_wider(names_from = name,
              values_from = value)

## Function to run the models ----

run_model <- function(outcome, age_group, ride1, ride2) {
  d <- dat %>%
    filter(age == age_group)
  grid <- expand_grid(a = 1:5,
                      b = 1:5)
  names(grid) <- c(ride1, ride2)
  form <- formula(
    glue("`{outcome}` ~ `{ride1}`*`{ride2}`")
  )
  mod <- lm(form, data = d)
  d1 <- tibble(
    ride = outcome,
    predicted_rating = predict(mod, newdata = grid),
  )
  bind_cols(grid, d1)
}

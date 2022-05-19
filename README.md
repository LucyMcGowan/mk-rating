# Disney Ride Picker
Lucy D'Agostino McGowan

This application uses [Touringplans](https://touringplans.com) survey data to estimate the Magic Kingdom ride you'd rate the highest based on the ratings of the last two rides you rode. 
You can find the application at: http://lucy.shinyapps.io/mk-rating/

## To run the appliation

To run the application, you need to following packages in R:

* **shiny**
* **tidyverse**
* **glue**
* **shinydashboard**
* **DT**

You can install them using the following code in your R console.

```r
install.packages("shiny")
install.packages("tidyverse")
install.packages("glue")
install.packages("shinydashboard")
install.packages("DT")
```

To run the application locally, first download the files in this repository. If using RStudio, open the RStudio project (themepark-rating.Rproj) and run `shiny::runApp()` in the console. If not using RStudio, you can set your working directory to the folder containing the files in this repository and run `shiny::runApp()`.

## The algorithm

This recommender is using a very simple algorithm. We identified 40 rides / attractions at Magic Kingdom. 

* We have 6 age groups. The user inputs their age:

![Figure](https://latex.codecogs.com/svg.image?\bg{white}(age_i\textrm{&space;for&space;}i=1,\dots,6))

* The user inputs the previous two rides they rode (*r1*, *r2*), along with ratings (*rate1, rate2*) from 1-5. 
* We subset the data to only include surveys for *age<sub>i</sub>*
* We fit 38 prediction models using the ratings from the remaining 38 rides:

![Figure](https://latex.codecogs.com/svg.image?\bg{white}(ride_j\in1-5\textrm{&space;for&space;}j=1,\dots,38))

as outcomes and *r1* and *r2* as predictors in the following form:

<center>

![Figure](https://latex.codecogs.com/svg.image?\bg{white}y_j=\alpha_j+\beta_{1j}r_1+\beta_{2j}r_2+\beta_{3j}r_1\times{r_2}+\varepsilon)

</center>

* We then plug in the user's ratings to get 38 predicted ratings for each of the 38 remaining rides:

![Figure](https://latex.codecogs.com/svg.image?\bg{white}(\hat{y}_j\textrm{&space;for&space;}j=1,\dots,38))

<center>

![Figure](https://latex.codecogs.com/svg.image?\bg{white}\hat{y}_j=\hat\alpha_j+\hat\beta_{1j}rate_1+\hat\beta_{2j}rate_2+\hat\beta_{3j}rate_1\times{rate_2})

</center>

* Finally, we arrange the 38 predicted ratings and output the ride with the highest predicted rating. 


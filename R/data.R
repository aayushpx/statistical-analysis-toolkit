#' Vehicles Dataset
#'
#' EPA fuel economy data for vehicle models.
#'
#' @format A data frame with 76 observations and 6 variables:
#' \describe{
#'   \item{manufacturer}{Vehicle manufacturer}
#'   \item{model}{Vehicle model name}
#'   \item{model_year}{Model year (1999 or 2008)}
#'   \item{engine_displacement}{Engine displacement in liters}
#'   \item{cylinders}{Number of cylinders}
#'   \item{highway_mpg}{Highway fuel economy (miles per gallon)}
#'   \item{city_mpg}{City fuel economy (miles per gallon)}
#'   \item{drive_type}{Drive type (f=front, r=rear, 4=four-wheel)}
#'   \item{vehicle_class}{Vehicle class (2seater, compact, midsize, etc.)}
#' }
#'
#' @source EPA Fuel Economy Dataset (from ggplot2::mpg)
#'
#' @examples
#' data(vehicles)
#' eda_numeric(vehicles, "highway_mpg")
#' perform_anova(vehicles, "highway_mpg", "vehicle_class")
"vehicles"

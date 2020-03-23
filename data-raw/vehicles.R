library(dplyr)

if (!file.exists("data-raw/vehicles.csv")) {
  tmp <- tempfile(fileext = ".zip")
  download.file("http://www.fueleconomy.gov/feg/epadata/vehicles.csv.zip", tmp,
    quiet = TRUE)
  unzip(tmp, exdir = "data-raw")
}

raw <- vroom::vroom("data-raw/vehicles.csv")

vehicles <- raw %>%
  as_tibble() %>%
  select(id, make, model, year, class = VClass, trans = trany, drive = drive,
    cyl = cylinders, displ = displ, fuel = fuelType, hwy = highway08,
    cty = city08) %>%
  filter(drive != "") %>%
  arrange(make, model, year)

attr(vehicles, "spec") <- NULL

use_data(vehicles, overwrite = TRUE)

common <- vehicles %>%
  group_by(make, model) %>%
  summarise(n = n(), years = n_distinct(year)) %>%
  filter(years >= 10) %>%
  ungroup()
use_data(common, overwrite = TRUE)

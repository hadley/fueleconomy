library(dplyr)

if (!file.exists("data-raw/vehicles.csv")) {
  tmp <- tempfile(fileext = ".zip")
  download.file("http://www.fueleconomy.gov/feg/epadata/vehicles.csv.zip", tmp,
    quiet = TRUE)
  unzip(tmp, exdir = "data-raw")
}

raw <- read.csv("data-raw/vehicles.csv", stringsAsFactors = FALSE)

vehicles <- raw %>%
  tbl_df() %>%
  select(id, make, model, year, class = VClass, trans = trany, drive = drive,
    cyl = cylinders, displ = displ, fuel = fuelType, hwy = highway08,
    cty = city08) %>%
  filter(drive != "") %>%
  arrange(make, model, year)

save(vehicles, file = "data/vehicles.rdata")

common <- vehicles %>%
  group_by(make, model) %>%
  summarise(n = n(), years = n_distinct(year)) %>%
  filter(years >= 10)
save(common, file = "data/common.rdata")

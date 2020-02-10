##########################################################
####  Create EML metadata for Saprolegnia paper data  ####
##########################################################

library("here")
library("EML")
library("readxl")
library("tidyverse")

# Dataset level info -----------------------------------------------------------

title <- "Parasite growth and survival, reproduction, and population modeling of Epischura baikalensis under warming conditions"

pub_date <- 2020

abstract <- "This collection contains data related to parasite infection of the endemic Lake Baikal zooplankton Epischura baikalensis. Data comes from laboratory experiments and population modeling. Included are data on the growth of Saprolegnia colonies on agar, survival and reproduction rates of Epischura baikalensis under varying temperature conditions and exposure to Saprolegnia, and inputs and outputs from population modeling simulations. Results from analyzing this data can be found in “Hot and sick: impacts of warming and oomycete parasite infection on endemic dominant zooplankter of Lake Baikal” (https://doi.org/10.1101/711655)."

keyword_set <- list(
  list(
    keyword = list(
      "Climate change",
      "zooplankton",
      "parasites",
      "Lake Baikal",
      "Epischurella baikalensis",
      "Oomycota",
      "Saprolegnia",
      "Diel Vertical Migration"
    )
  )
)

intellectual_rights <- "CC-BY"

ted <- as_emld(person("Ted", "Ozersky", "tozersky@d.umn.edu", "cre"))
other_people <- as_emld(
  c(
    as.person("Teofil Nakov"),
    as.person("Stephanie E. Hampton"),
    as.person("Nicholas L. Rodenhouse"),
    as.person("Kirill Shchapov"),
    as.person("Kara H. Woo"),
    as.person("Katie Wright"),
    as.person("Helena V. Pislegina"),
    as.person("Lyubov R. Izmest'eva"),
    as.person("Eugene A. Silow"),
    as.person("Maxim A. Timofeev"),
    as.person("Marianne V. Moore")
  )
)

coverage <- set_coverage(
  beginDate = "2013",
  endDate = "2019",
  sci_names = c("Epischurella baikalensis", "Saprolegnia sp."),
  geographicDescription = "Lake Baikal, Siberia",
  westBoundingCoordinate = 103.34,
  eastBoundingCoordinate = 110.39,
  northBoundingCoordinate = 56.03,
  southBoundingCoordinate = 51.39
)

# File-specific info -----------------------------------------------------------

# Sapro growth on agar ---------------------------------------------------------

## Physical metadata
phys_sapro <- set_physical(here("data", "saprolegnia_growth_agar.xlsx"))

## Attributes
sapro_defs <- data.frame(
  stringsAsFactors = FALSE,
  attributeName = c(
    "sample.name",
    "temperature.C",
    "time.hrs",
    "colony.diameter.mm",
    "colony.area.mm2"
  ),
  attributeDefinition = c(
    "name of sample",
    "incubation temperature",
    "time from start of experiment",
    "colony diameter, as average of two perpendicular measurements",
    "colony area, as average of two perpendicular measurements minus area of initial plug"
  ),
  definition = c("name of sample", NA, NA, NA, NA),
  unit = c(
    NA,
    "celsius",
    "hour",
    "millimeter",
    "squareMillimeters"
  ),
  numberType = c(NA, "real", "real", "real", "real"),
  measurementScale = c("nominal", "interval", "interval", "ratio", "ratio"),
  domain = c(
    "textDomain",
    "numericDomain",
    "numericDomain",
    "numericDomain",
    "numericDomain"
  )
)
sapro_defs <- set_attributes(sapro_defs)

sapro_data <- list(
  entityName = "saprolegia_growth_agar.xlsx",
  entityDescription = "Saprolegnia colony growth on agar",
  physical = phys_sapro,
  attributeList = sapro_defs
)

# Epischurella survival and reproduction ---------------------------------------

# Modeling inputs and outputs --------------------------------------------------

# Long-term data ---------------------------------------------------------------

# Construct metadata -----------------------------------------------------------

dataset <- list(
  title = title,
  creator = ted,
  pubDate = pub_date,
  intellectualRights = intellectual_rights,
  abstract = abstract,
  keywordSet = keyword_set,
  coverage = coverage,
  contact = ted,
  dataTable = sapro_data
)

eml <- list(
  packageId = uuid::UUIDgenerate(),
  system = "uuid",
  dataset = dataset
)

write_eml(eml, "eml.xml")
eml_validate("eml.xml")

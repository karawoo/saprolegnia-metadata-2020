##########################################################
####  Create EML metadata for Saprolegnia paper data  ####
##########################################################

library("here")
library("EML")
library("readxl")
library("tidyverse")
library("assertr")

# Dataset level info -----------------------------------------------------------

title <- "Parasite growth and survival, reproduction, and population modeling of Epischurella baikalensis under warming conditions"

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

phys_epi <- set_physical(here("data", "episch_survival_reproduction.xlsx.xlsx"))

epi_defs_base <- data.frame(
  stringsAsFactors = FALSE,
  attributeName = c("Live","Gravid","Eggs",
                    "Sapro","Eggs sapro","Nauplii","Nauplii Count",
                    "Nauplii sapro","Notes","Sample name"),
  attributeDefinition = c("0-animal (adult or nauplius initially placed in well) dead, 1-animal alive",
                          "0-animal not gravid, 1-animal gravid",
                          "0-egg sack not present, 1-egg sack present, 2-two egg sacs present",
                          "0-animal (adult or nauplius initially placed in well) does not have apparent sapro infection, 1-apparent sapro hyphae",
                          "0-egg sack without apparent sapro hyphae, 1-egg sack with apparent sapro hyphae",
                          "0-no newly hatched nauplii present, 1-newly hatched nauplii present",
                          "number of nauplii (live+dead) visible in well (count done twice, since live nauplii hard to count)",
                          "0-nauplii do not show sapro, 1-nauplii show sapro",
                          "notes","name of sample"),
  definition = c(NA,NA,NA,NA,NA,NA,
                 NA,NA,"notes","name of sample"),
  unit = c(NA, NA, NA, NA, NA, NA, "dimensionless", NA, NA, NA),
  numberType = c(NA, NA, NA, NA, NA, NA, "real", NA, NA, NA),
  measurementScale = c("nominal","nominal",
                       "nominal","nominal","nominal","nominal","ratio",
                       "nominal","nominal","nominal"),
  domain = c("enumeratedDomain", "enumeratedDomain",
             "enumeratedDomain","enumeratedDomain", "enumeratedDomain",
             "enumeratedDomain", "numericDomain","enumeratedDomain",
             "textDomain","textDomain")
)

## Column names in Epischurella data
epi_col_names <- names(read_excel(here("data", "episch_survival_reproduction.xlsx")))

## Create mapping table of column names to "base" names ("Live"/"Gravid"/"Eggs"
## etc. without time points)
epi_mapping <- data.frame(
  attributeName = epi_col_names,
  stringsAsFactors = FALSE
) %>%
  mutate(
    ## Get "base" name by remove time info at the end
    base_attr_name = str_remove(attributeName, "(\\s(1|2))?-T[0-9]+(\\.5)?"),
    base_attr_name = case_when(
      ## Fix typo
      base_attr_name == "Naplii sapro" ~ "Nauplii sapro",
      TRUE ~ base_attr_name
    )
  )

## Join with attribute information
epi_defs <- epi_mapping %>%
  left_join(epi_defs_base, by = c("base_attr_name" = "attributeName")) %>%
  select(-base_attr_name) %>%
  ## Ensure we have the right number of rows
  verify(nrow(.) == length(epi_col_names))

## Definitions of codes used in data
epi_factors_base <- list(
  Live = c("0" = "dead", "1" = "alive"),
  Gravid = c("0" = "not gravid", "1" = "gravid"),
  Eggs = c("0" = "egg sack not present", "1" = "egg sack present"),
  Sapro = c("0" = "animal (adult or nauplius initially placed in well) does not have apparent sapro infection", "1" = "apparent sapro hyphae"),
  `Eggs sapro` = c("0" = "egg sack without apparent sapro hyphae", "1" = "egg sack with apparent sapro hyphae"),
  Nauplii = c("0" = "no newly hatched nauplii present", "1" = "newly hatched nauplii present"),
  `Nauplii sapro` = c("0" = "nauplii do not show sapro", "1" = "nauplii show sapro")
) %>%
  imap_dfr(function(x, y) {
    data.frame(
      attributeName = y,
      code = names(x),
      definition = unname(x),
      stringsAsFactors = FALSE
    )
  })

## Join code definitions with all column names
epi_factors <- epi_mapping %>%
  left_join(epi_factors_base, by = c("base_attr_name" = "attributeName")) %>%
  select(-base_attr_name)

## Combine all attribute info
epi_defs <- set_attributes(epi_defs, epi_factors)

epi_data <- list(
  entityName = "episch_survival_reproduction.xlsx",
  entityDescription = "Epischura survival and reproduction",
  physical = phys_epi,
  attributeList = epi_defs
)

# Modeling inputs and outputs --------------------------------------------------

## Temperature scenarios

phys_temp_input <- set_physical(
  here("data", "model_data", "model_temp_scenarios.xlsx")
)

## Get column names
temp_input_names <- names(
  read_excel(here("data", "model_data", "model_temp_scenarios.xlsx"), sheet = 1)
)

## Create attribute table for temp input scenarios
temp_input_defs <- data.frame(
  attributeName = temp_input_names,
  stringsAsFactors = FALSE
) %>%
  mutate(
    attributeDefinition = case_when(
      attributeName == "DOY" ~ "day of year",
      str_detect(attributeName, "DVM") ~ "daily average temperature experienced by a zooplankter spending half its day in surface water and half its day in hypolimnetic",
      TRUE ~ "pelagic temperature based on long-term data (1951-2002)"
    ),
    unit = case_when(
      attributeName == "DOY" ~ "dimensionless",
      TRUE ~ "celsius"
    ),
    numberType = "real",
    measurementScale = "interval",
    domain = "numericDomain"
  )

temp_input_defs <- set_attributes(temp_input_defs)

temp_input_data <- list(
  entityName = "model_temp_scenarios.xlsx",
  entityDescription = "Temperature scenarios used to run the Epischurella population model",
  physical = phys_temp_input,
  attributeList = temp_input_defs
)


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
  dataTable = list(sapro_data, epi_data, temp_input_data)
)

eml <- list(
  packageId = uuid::UUIDgenerate(),
  system = "uuid",
  dataset = dataset
)

write_eml(eml, "saprolegnia_metadata.xml")
eml_validate("saprolegnia_metadata.xml")

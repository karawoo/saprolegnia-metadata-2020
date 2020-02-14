#######################
####  Upload data  ####
#######################

## The following script requires an authentication token. To get one, log in to
## search.dataone.org and go to "My profile" -> "Settings" -> "Authentication
## token".

library("dataone")
library("datapack")
library("here")
library("tidyverse")
library("mime")
library("uuid")

## Create new data package
dat <- new("DataPackage")

## Create series ID
series_id <- sprintf("urn:uuid:%s", UUIDgenerate())
dat@sysmeta@seriesId <- series_id

## Get DOI (later)
## cn <- CNode("PROD")
## mn <- getMNode(cn, "urn:node:KNB")
## doi <- generateIdentifier(mn, "DOI")

## Add metadata
eml_file <- here("saprolegnia_metadata.xml")
metadata_obj <- new(
  "DataObject",
  ## id = doi,
  format = "eml://ecoinformatics.org/eml-2.2.0",
  filename = eml_file
)
dat <- addMember(dat, metadata_obj)

## Add files (just 3 for now)
files <- tibble(
  filename = c(
    here("data", "episch_survival_reproduction.xlsx"),
    here("data", "saprolegnia_growth_agar.xlsx"),
    here("data", "model_data", "model_temp_scenarios.xlsx")
  )
) %>%
  mutate(format = guess_type(filename)) %>%
  select(filename, format)

## Create data objects
data_objects <- pmap(files, function(filename, format) {
  new("DataObject", format = format, filename = filename)
})

## Add to data package
for (i in seq_along(data_objects)) {
  dat <- addMember(dat, data_objects[[i]], metadata_obj)
}

## Access -- Ted and me for now
access <- data.frame(
  subject = c(
    "https://orcid.org/0000-0002-5125-4188",
    "https://orcid.org/0000-0002-1842-7745"
  ),
  permission = "changePermission"
)

## Upload to KNB
client <- D1Client("PROD", "urn:node:KNB")
pkg_id <- uploadDataPackage(
  client,
  dat,
  public = FALSE,
  accessRules = access,
  quiet = FALSE
)

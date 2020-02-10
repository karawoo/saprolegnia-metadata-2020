# README

This repo contains code to generate EML metadata for the data accompanying "Hot
and sick: impacts of warming and oomycete parasite infection on endemic dominant
zooplankter of Lake Baikal" (https://doi.org/10.1101/711655).

The data is not stored under version control as it will be posted to the
Knowledge Network for Biocomplexity once this project is complete. Therefore,
the scripts as written will not run. If you have the data, you can run the code
if you recreate the following folder structure:

```
.
├── README.md
├── data
│   ├── episch_survival_reproduction.xlsx
│   ├── model_data
│   │   ├── ModelOutFiles.txt
│   │   ├── NoSap_ModelOut
│   │   │   ├── MidBayDVM.xls
│   │   │   ├── MidBayNoDVM.xls
│   │   │   ├── PelAveDVM.xls
│   │   │   ├── PelAveNoDVM.xls
│   │   │   ├── PelColdDVM.xls
│   │   │   ├── PelColdNoDVM.xls
│   │   │   ├── PelCoolDVM.xls
│   │   │   ├── PelCoolNoDVM.xls
│   │   │   ├── PelHotDVM.xls
│   │   │   ├── PelHotNoDVM.xls
│   │   │   ├── PelWarmDVM.xls
│   │   │   ├── PelWarmNoDVM.xls
│   │   │   ├── ProvalDVM.xls
│   │   │   └── ProvalNoDVM.xls
│   │   ├── SapAgarBeta_ModelOut
│   │   │   ├── MidBayDVM.xls
│   │   │   ├── MidBayNoDVM.xls
│   │   │   ├── PelAveDVM.xls
│   │   │   ├── PelAveNoDVM.xls
│   │   │   ├── PelColdDVM.xls
│   │   │   ├── PelColdNoDVM.xls
│   │   │   ├── PelCoolDVM.xls
│   │   │   ├── PelCoolNoDVM.xls
│   │   │   ├── PelHotDVM.xls
│   │   │   ├── PelHotNoDVM.xls
│   │   │   ├── PelWarmDVM.xls
│   │   │   ├── PelWarmNoDVM.xls
│   │   │   ├── ProvalDVM.xls
│   │   │   └── ProvalNoDVM.xls
│   │   ├── SapConstantBeta_ModelOut
│   │   │   ├── MidBayDVM.xls
│   │   │   ├── MidBayNoDVM.xls
│   │   │   ├── PelAveDVM.xls
│   │   │   ├── PelAveNoDVM.xls
│   │   │   ├── PelColdDVM.xls
│   │   │   ├── PelColdNoDVM.xls
│   │   │   ├── PelCoolDVM.xls
│   │   │   ├── PelCoolNoDVM.xls
│   │   │   ├── PelHotDVM.xls
│   │   │   ├── PelHotNoDVM.xls
│   │   │   ├── PelWarmDVM.xls
│   │   │   ├── PelWarmNoDVM.xls
│   │   │   ├── ProvalDVM.xls
│   │   │   └── ProvalNoDVM.xls
│   │   ├── SapMortBeta_ModelOut
│   │   │   ├── MidBayDVM.xls
│   │   │   ├── MidBayNoDVM.xls
│   │   │   ├── PelAveDVM.xls
│   │   │   ├── PelAveNoDVM.xls
│   │   │   ├── PelColdDVM.xls
│   │   │   ├── PelColdNoDVM.xls
│   │   │   ├── PelCoolDVM.xls
│   │   │   ├── PelCoolNoDVM.xls
│   │   │   ├── PelHotDVM.xls
│   │   │   ├── PelHotNoDVM.xls
│   │   │   ├── PelWarmDVM.xls
│   │   │   ├── PelWarmNoDVM.xls
│   │   │   ├── ProvalDVM.xls
│   │   │   └── ProvalNoDVM.xls
│   │   └── model_temp_scenarios.xlsx
│   └── saprolegnia_growth_agar.xlsx
├── renv
│   ├── activate.R
│   └── settings.dcf
├── renv.lock
├── sapro_metadata.R
└── saprolegnia-metadata-2020.Rproj
```

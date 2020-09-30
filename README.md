# covid-data-registry

This repository contains a data registry, data schemas, and schema validators for COVID-19 case counts data sources.

## Registry File

The registry is constructed using a yaml file, `registry.yml` in the root of the repository. The structure of the registry file has a root key `sources`, under which a listing of repositories grouped by data type is provided.

In this COVID-19 registry, for example, we currently only have sources of type `case-counts`. We provide a `description` and a listing of `repos`, one for each source.

```yaml
sources:
  -
    type: case-counts
    description: Daily cumulative case and death counts at different levels of geographic resolution
    repos:
      - https://github.com/WorldHealthOrganization/xform-covid-casecount-jhu
      - https://github.com/WorldHealthOrganization/xform-covid-casecount-ecdc
      - https://github.com/WorldHealthOrganization/xform-covid-casecount-who
      - https://github.com/WorldHealthOrganization/xform-covid-casecount-wom
```

## Registry Document

Each of the data source repositories contains its own yaml file with additional metadata about the source.

A GitHub Action in this registry repository runs daily (defined [here](https://github.com/WorldHealthOrganization/covid-data-registry/blob/master/.github/workflows/mkdocs_registry.yml)) and produces a markdown document listing all of the sources and associated metadata, which is placed in the `docs` directory, [here](https://github.com/WorldHealthOrganization/covid-data-registry/blob/master/docs/registry.md).

## Schemas

Schemas for the data types of sources in the registry are also stored in this registry repository in the `schemas` directory. The general assumption is that data sources will store final output data as csv files in the data source repositories, and the schema definitions in this registry are built to validate csv files.

The csv schemas are defined and validated using the [csv-schema-py](https://github.com/pcstout/csv-schema-py) package. The README in that repository provides information about how to define a schema.

An underlying assumption about the use of this data registry framework is that data is collected at different levels of national or subnational administrative levels, with levels defined as follows:

- global: data pertaining to the entire world
- continents: data pertaining to each continent
- who_regions: data pertaining to each WHO Region
- admin0: data pertaining to national-level boundaries (countries/territories)
- admin1: data pertaining to subnational-level boundaries (states/provinces within countries/territories)
- admin2: data pertaining to data pertaining to a second level of sub-national boundaries (counties within states, etc.)

A different data schema can be provided for each administrative level.

As an example, for case counts, we define a schema for admin0 data as follows:

```
{
  "name": "Admin0 Case Counts",
  "description": "",
  "filename": {
    "regex": ".+(\\.csv)$"
  },
  "columns": [
    {
      "type": "enum",
      "name": "admin0_code",
      "required": true,
      "null_or_empty": false,
      "values": [
        "AF",
        "AX",
        ... (continued list of acceptable country codes)
      ]
    },
    {
      "type": "string",
      "name": "date",
      "required": true,
      "null_or_empty": false,
      "regex": "^([0-9]{4})(-)(1[0-2]|0[1-9])\\2(3[01]|0[1-9]|[12][0-9])$",
      "min": 10,
      "max": 10
    },
    {
      "type": "integer",
      "name": "cases",
      "required": true,
      "null_or_empty": true,
      "regex": null,
      "min": 0,
      "max": null
    },
    {
      "type": "integer",
      "name": "deaths",
      "required": true,
      "null_or_empty": true,
      "regex": null,
      "min": 0,
      "max": null
    }
  ]
}
```

The actual file is available [here](https://github.com/WorldHealthOrganization/covid-data-registry/blob/master/schemas/case-counts/admin0/v1/admin0.json).

This schema requires the following 4 columns to exist in the data:

- admin0_code: the country code, which cannot be empty, and must be one of the listed values
- date: a valid date string of the format yyyy-mm-dd
- cases: a non-negative number of cumulative cases (cumulative is not validatable)
- deaths: a non-negative number of cumulative deaths (cumulative is not validatable)

Validating sources against well-defined schemas helps ensure that applications which will ingest the data can always expect data in a uniform format.

## Creating a New Registry

To create a new registry for another project, this repository can be cloned and modified for the new purpose. Simply clone the repository, update the `registry.yml` file, and the schemas in the `schema` directory.

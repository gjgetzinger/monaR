An introduction to using the MoNA API with monaR
# Introduction

Mass Bank of North America (MoNA) is a mass spectrometry resources
desinged for the storage and querying of tandem mass spectral data from
small organic molecules. This valuable resource is maintained by the
Fiehn Lab at UC Davis. To get more information about MoNA, please visit
<https://mona.fiehnlab.ucdavis.edu>.

MoNA provides a REST API for programatic queries. This package provides
wrapper functions for using the MoNA API from R.

# Queries

Two types of queries are supported. First, molecular identifiers can be
used to query record meta data for potential matching compound. Second,
spectral similarity searching can be used to return records from similar
spectra stored in MoNA.

## Query by molecular or structure identifier

Querying by identifier takes at mininum two inputs: `query` and `from`.
The `query` argument is a molecular identifier while `from` indicates
how the type of identifier used.

### Query by text string

Take for instance we want to search for the chemical Microcystin-LR by
its abbreviation, MCLR.

``` r
mona_query(query = 'MCLR', from = 'text')
#> MoNA query by structure/molecule identifier:
#> query : MCLR 
#> from : text 
#> Results:
#> Observations: 42
#> Variables: 13
#> $ compound    <list> [<data.frame[1 x 8]>, <data.frame[1 x 8]>, <data.frame[1 x 8]>, <data…
#> $ id          <chr> "EQ299207", "EQ299206", "EQ299256", "EQ299202", "EQ299252", "EQ299208"…
#> $ dateCreated <dbl> 1.584040e+12, 1.584040e+12, 1.584040e+12, 1.584040e+12, 1.584040e+12, …
#> $ lastUpdated <dbl> 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, …
#> $ lastCurated <dbl> 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, …
#> $ metaData    <list> [<data.frame[30 x 6]>, <data.frame[30 x 6]>, <data.frame[30 x 6]>, <d…
#> $ annotations <list> [<data.frame[51 x 5]>, <data.frame[58 x 5]>, <data.frame[18 x 5]>, <d…
#> $ score       <df[,2]> <data.frame[31 x 2]>
#> $ spectrum    <chr> "69.0335:0.979463 70.0651:58.792322 71.0492:1.422030 72.0807:1.039469 …
#> $ splash      <df[,5]> <data.frame[31 x 5]>
#> $ submitter   <df[,5]> <data.frame[31 x 5]>
#> $ tags        <list> [<data.frame[2 x 2]>, <data.frame[2 x 2]>, <data.frame[2 x 2]>, <data…
#> $ library     <df[,4]> <data.frame[31 x 4]>
```

### Query by chemical name

Alternatively, we can search by name.

``` r
mona_query(query = 'Microcystin-LR', from = 'name')
#> MoNA query by structure/molecule identifier:
#> query : Microcystin-LR 
#> from : name 
#> Results:
#> Observations: 141
#> Variables: 13
#> $ compound    <list> [<data.frame[1 x 8]>, <data.frame[1 x 8]>, <data.frame[1 x 8]>, <data…
#> $ id          <chr> "EA299210", "EA299203", "EA299204", "EA299211", "EA299205", "EA299212"…
#> $ dateCreated <dbl> 1.487111e+12, 1.487111e+12, 1.487111e+12, 1.487111e+12, 1.487111e+12, …
#> $ lastUpdated <dbl> 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, …
#> $ lastCurated <dbl> 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, …
#> $ metaData    <list> [<data.frame[30 x 6]>, <data.frame[30 x 6]>, <data.frame[30 x 6]>, <d…
#> $ annotations <list> [<data.frame[53 x 5]>, <data.frame[35 x 5]>, <data.frame[59 x 5]>, <d…
#> $ score       <df[,2]> <data.frame[31 x 2]>
#> $ spectrum    <chr> "70.065:16.558562 84.0443:6.200376 86.0963:16.435100 93.0697:3.403519 …
#> $ splash      <df[,5]> <data.frame[31 x 5]>
#> $ submitter   <df[,5]> <data.frame[31 x 5]>
#> $ tags        <list> [<data.frame[2 x 2]>, <data.frame[2 x 2]>, <data.frame[2 x 2]>, <data…
#> $ library     <df[,4]> <data.frame[31 x 4]>
```

### Query by InChI Key

Since names and abbreviations are not standardized, it is useful to be
able to query by a unique identifier related to the target chemicals
structure. The ideal identifier for this purpose is the International
Chemical Identifier (InChI) in hashed form, which is also known as an
InChI Key. The InChI Key encodes all the structural information (type,
position and arrangement of elements in a molecule) in a 27-digit
string.

``` r
mona_query(query = 'ZYZCGGRZINLQBL-GWRQVWKTSA-N', from = 'InChIKey')
#> MoNA query by structure/molecule identifier:
#> query : ZYZCGGRZINLQBL-GWRQVWKTSA-N 
#> from : InChIKey 
#> Results:
#> Observations: 29
#> Variables: 13
#> $ compound    <list> [<data.frame[1 x 8]>, <data.frame[1 x 8]>, <data.frame[1 x 8]>, <data…
#> $ id          <chr> "EA299210", "EA299203", "EA299204", "EA299211", "EA299205", "EA299212"…
#> $ dateCreated <dbl> 1.487111e+12, 1.487111e+12, 1.487111e+12, 1.487111e+12, 1.487111e+12, …
#> $ lastUpdated <dbl> 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, …
#> $ lastCurated <dbl> 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, …
#> $ metaData    <list> [<data.frame[30 x 6]>, <data.frame[30 x 6]>, <data.frame[30 x 6]>, <d…
#> $ annotations <list> [<data.frame[53 x 5]>, <data.frame[35 x 5]>, <data.frame[59 x 5]>, <d…
#> $ score       <df[,2]> <data.frame[29 x 2]>
#> $ spectrum    <chr> "70.065:16.558562 84.0443:6.200376 86.0963:16.435100 93.0697:3.403519 …
#> $ splash      <df[,5]> <data.frame[29 x 5]>
#> $ submitter   <df[,5]> <data.frame[29 x 5]>
#> $ tags        <list> [<data.frame[2 x 2]>, <data.frame[2 x 2]>, <data.frame[2 x 2]>, <data…
#> $ library     <df[,4]> <data.frame[29 x 4]>
```

In instances where the target molecule has several stereo isomers, all
isomer matches can be retrieved by queyring by the connectivity layer of
the InChI, which is encoded in the first 14 characters of the InChI Key.
Such a situation might be useful when exact stereochemistry differs
between databases.

``` r
mona_query(query = 'ZYZCGGRZINLQBL', from = 'InChIKey')
#> MoNA query by structure/molecule identifier:
#> query : ZYZCGGRZINLQBL 
#> from : partial_inchikey 
#> Results:
#> Observations: 29
#> Variables: 13
#> $ compound    <list> [<data.frame[1 x 8]>, <data.frame[1 x 8]>, <data.frame[1 x 8]>, <data…
#> $ id          <chr> "EA299210", "EA299203", "EA299204", "EA299211", "EA299205", "EA299212"…
#> $ dateCreated <dbl> 1.487111e+12, 1.487111e+12, 1.487111e+12, 1.487111e+12, 1.487111e+12, …
#> $ lastUpdated <dbl> 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, …
#> $ lastCurated <dbl> 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, …
#> $ metaData    <list> [<data.frame[30 x 6]>, <data.frame[30 x 6]>, <data.frame[30 x 6]>, <d…
#> $ annotations <list> [<data.frame[53 x 5]>, <data.frame[35 x 5]>, <data.frame[59 x 5]>, <d…
#> $ score       <df[,2]> <data.frame[29 x 2]>
#> $ spectrum    <chr> "70.065:16.558562 84.0443:6.200376 86.0963:16.435100 93.0697:3.403519 …
#> $ splash      <df[,5]> <data.frame[29 x 5]>
#> $ submitter   <df[,5]> <data.frame[29 x 5]>
#> $ tags        <list> [<data.frame[2 x 2]>, <data.frame[2 x 2]>, <data.frame[2 x 2]>, <data…
#> $ library     <df[,4]> <data.frame[29 x 4]>
```

### Query by molecular formula

To retrieve all the extant structural isomers molecule, we can search by
molecular formula.

``` r
mona_query(query = 'C49H74N10O12', from = 'molform')
#> MoNA query by structure/molecule identifier:
#> query : C49H74N10O12 
#> from : molform 
#> Results:
#> Observations: 29
#> Variables: 13
#> $ compound    <list> [<data.frame[1 x 8]>, <data.frame[1 x 8]>, <data.frame[1 x 8]>, <data…
#> $ id          <chr> "EA299210", "EA299203", "EA299204", "EA299211", "EA299205", "EA299212"…
#> $ dateCreated <dbl> 1.487111e+12, 1.487111e+12, 1.487111e+12, 1.487111e+12, 1.487111e+12, …
#> $ lastUpdated <dbl> 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, …
#> $ lastCurated <dbl> 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, …
#> $ metaData    <list> [<data.frame[30 x 6]>, <data.frame[30 x 6]>, <data.frame[30 x 6]>, <d…
#> $ annotations <list> [<data.frame[53 x 5]>, <data.frame[35 x 5]>, <data.frame[59 x 5]>, <d…
#> $ score       <df[,2]> <data.frame[29 x 2]>
#> $ spectrum    <chr> "70.065:16.558562 84.0443:6.200376 86.0963:16.435100 93.0697:3.403519 …
#> $ splash      <df[,5]> <data.frame[29 x 5]>
#> $ submitter   <df[,5]> <data.frame[29 x 5]>
#> $ tags        <list> [<data.frame[2 x 2]>, <data.frame[2 x 2]>, <data.frame[2 x 2]>, <data…
#> $ library     <df[,4]> <data.frame[29 x 4]>
```

### Query by exact mass

Alternatively the exact mass can be used.

``` r
mona_query(query = 994.5488, from = 'mass', mass_tol_Da = 0.1)
#> MoNA query by structure/molecule identifier:
#> query : 994.5488 
#> from : mass 
#> mass_tol_Da : 0.1 
#> Results:
#> Observations: 99
#> Variables: 13
#> $ compound    <list> [<data.frame[1 x 7]>, <data.frame[1 x 7]>, <data.frame[1 x 7]>, <data…
#> $ id          <chr> "LipidBlast054403", "LipidBlast448269", "LipidBlast448086", "EA299210"…
#> $ dateCreated <dbl> 1.487107e+12, 1.557216e+12, 1.557216e+12, 1.487111e+12, 1.487111e+12, …
#> $ lastUpdated <dbl> 1.572246e+12, 1.572262e+12, 1.572262e+12, 1.584674e+12, 1.584674e+12, …
#> $ lastCurated <dbl> 1.561558e+12, 1.561612e+12, 1.561612e+12, 1.584674e+12, 1.584674e+12, …
#> $ metaData    <list> [<data.frame[12 x 6]>, <data.frame[12 x 6]>, <data.frame[12 x 6]>, <d…
#> $ annotations <list> [<data.frame[0 x 0]>, <data.frame[0 x 0]>, <data.frame[0 x 0]>, <data…
#> $ score       <df[,2]> <data.frame[31 x 2]>
#> $ spectrum    <chr> "309.2424:10.010010 331.2268:10.010010 333.2424:10.010010 589.4257:100…
#> $ splash      <df[,5]> <data.frame[31 x 5]>
#> $ submitter   <df[,5]> <data.frame[31 x 5]>
#> $ tags        <list> [<data.frame[2 x 2]>, <data.frame[2 x 2]>, <data.frame[2 x 2]>, <data…
#> $ library     <df[,4]> <data.frame[31 x 4]>
```

### Additional search parameters

Queries can be further constrained to specific types of spectra by
passing arguments to `ionization`, `ms_level`, and
`source_introduction`. When searching by exact mass, `mass_tol_Da`
designates the allowed mass error in Daltons.

To search only for MS<sup>2</sup>
spectra

``` r
mona_query(query = 'ZYZCGGRZINLQBL', from = 'InChIKey', ms_level = 'MS2')
#> MoNA query by structure/molecule identifier:
#> query : ZYZCGGRZINLQBL 
#> from : partial_inchikey 
#> ms_level : MS2 
#> Results:
#> Observations: 29
#> Variables: 13
#> $ compound    <list> [<data.frame[1 x 8]>, <data.frame[1 x 8]>, <data.frame[1 x 8]>, <data…
#> $ id          <chr> "EA299210", "EA299203", "EA299204", "EA299211", "EA299205", "EA299212"…
#> $ dateCreated <dbl> 1.487111e+12, 1.487111e+12, 1.487111e+12, 1.487111e+12, 1.487111e+12, …
#> $ lastUpdated <dbl> 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, …
#> $ lastCurated <dbl> 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, …
#> $ metaData    <list> [<data.frame[30 x 6]>, <data.frame[30 x 6]>, <data.frame[30 x 6]>, <d…
#> $ annotations <list> [<data.frame[53 x 5]>, <data.frame[35 x 5]>, <data.frame[59 x 5]>, <d…
#> $ score       <df[,2]> <data.frame[29 x 2]>
#> $ spectrum    <chr> "70.065:16.558562 84.0443:6.200376 86.0963:16.435100 93.0697:3.403519 …
#> $ splash      <df[,5]> <data.frame[29 x 5]>
#> $ submitter   <df[,5]> <data.frame[29 x 5]>
#> $ tags        <list> [<data.frame[2 x 2]>, <data.frame[2 x 2]>, <data.frame[2 x 2]>, <data…
#> $ library     <df[,4]> <data.frame[29 x 4]>
```

To search for MS<sup>2</sup> spectra only in positive ion mode collected
on an LC-MS instrument

``` r
mona_query(
  query = 'ZYZCGGRZINLQBL',
  from = 'InChIKey',
  ms_level = 'MS2',
  ionization = 'positive',
  source_introduction = 'LC-MS'
  )
#> MoNA query by structure/molecule identifier:
#> query : ZYZCGGRZINLQBL 
#> from : partial_inchikey 
#> ionization : positive 
#> ms_level : MS2 
#> source_introduction : LC-MS 
#> Results:
#> Observations: 23
#> Variables: 13
#> $ compound    <list> [<data.frame[1 x 8]>, <data.frame[1 x 8]>, <data.frame[1 x 8]>, <data…
#> $ id          <chr> "EA299210", "EA299203", "EA299204", "EA299211", "EA299205", "EA299212"…
#> $ dateCreated <dbl> 1.487111e+12, 1.487111e+12, 1.487111e+12, 1.487111e+12, 1.487111e+12, …
#> $ lastUpdated <dbl> 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, …
#> $ lastCurated <dbl> 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, 1.584674e+12, …
#> $ metaData    <list> [<data.frame[30 x 6]>, <data.frame[30 x 6]>, <data.frame[30 x 6]>, <d…
#> $ annotations <list> [<data.frame[53 x 5]>, <data.frame[35 x 5]>, <data.frame[59 x 5]>, <d…
#> $ score       <df[,2]> <data.frame[23 x 2]>
#> $ spectrum    <chr> "70.065:16.558562 84.0443:6.200376 86.0963:16.435100 93.0697:3.403519 …
#> $ splash      <df[,5]> <data.frame[23 x 5]>
#> $ submitter   <df[,5]> <data.frame[23 x 5]>
#> $ tags        <list> [<data.frame[2 x 2]>, <data.frame[2 x 2]>, <data.frame[2 x 2]>, <data…
#> $ library     <df[,4]> <data.frame[23 x 4]>
```

## Query by mass spectrum

Spectral library searching, using tandem mass spectrometry data, is
useful for annotating the structure of unknown chemicals detected by
mass spectrometry. MoNA queries by mass spectra return similar spectra,
along with their associated chemical information.

Spectra can be provided as a `data.frame` or `matrix`. For example:

``` r
atrazine_ms2
#> # A tibble: 15 x 2
#>       mz intensity
#>    <dbl>     <dbl>
#>  1  68.0     3.54 
#>  2  71.1     0.484
#>  3  79.0     3.32 
#>  4  96.1     6.23 
#>  5 104.      6.37 
#>  6 110.      0.127
#>  7 132.      5.10 
#>  8 138.      1.58 
#>  9 138.      0.881
#> 10 146.      3.58 
#> 11 146.      0.722
#> 12 174.    100    
#> 13 180.      0.418
#> 14 188.      0.638
#> 15 216.     86.4
```

``` r
mona_querySpec(spectrum = atrazine_ms2)
#> MoNA query by mass spectrum:
#> spectrum 
#> Observations: 15
#> Variables: 2
#> $ mz        <dbl> 68.0244, 71.0604, 79.0058, 96.0557, 104.0011, 110.0461, 132.0324, 138.07…
#> $ intensity <dbl> 3.544857, 0.484472, 3.321822, 6.234326, 6.368015, 0.127197, 5.097925, 1.…
#> Results:
#> Observations: 19
#> Variables: 2
#> $ hit   <df[,13]> <data.frame[19 x 13]>
#> $ score <dbl> 0.9999993, 0.9481762, 0.8601510, 0.8161209, 0.7705179, 0.7534919, 0.7504205,…
```

Additional limiters can be provided by designating a minimum spectral
similarity threshold (`minSimilarity`) and the mass-to-charge of the
precursor ion (`precursorMZ`). When `precursorMZ` is provided, the
allowed mass error should be designated in Daltons
(`precursorToleranceDa`) or parts-per-million (ppm,
`precursorTolerancePPM`).

``` r
mona_querySpec(
  spectrum = atrazine_ms2,
  minSimilarity = 800,
  precursorMZ = 216,
  precursorToleranceDa = 1
)
#> MoNA query by mass spectrum:
#> spectrum 
#> Observations: 15
#> Variables: 2
#> $ mz        <dbl> 68.0244, 71.0604, 79.0058, 96.0557, 104.0011, 110.0461, 132.0324, 138.07…
#> $ intensity <dbl> 3.544857, 0.484472, 3.321822, 6.234326, 6.368015, 0.127197, 5.097925, 1.…
#> minSimilarity : 800 
#> precursorMZ : 216 
#> precursorToleranceDa : 1 
#> Results:
#> Observations: 9
#> Variables: 2
#> $ hit   <df[,13]> <data.frame[9 x 13]>
#> $ score <dbl> 0.9999993, 0.9481762, 0.8601510, 0.7705179, 0.7534919, 0.7504205, 0.7492475,…
```

# Working with results

Queries to MoNA return all results a single tibble. Various helper
functions are provided for accessing the various parts of the query
results. Query results consist of meta data that describes the
experimetnal conditions that the library spectra were acquired under,
chemical information in the form of structural and molecular
representations and identifiers, and spectral data.

## Getting meta data

Various aspects of the meta data can be extracted from identifier and
spectra queries.

### Identifier queries

``` r
id_query_rst <- mona_query('atrazine', 'name')
id_query_rst
#> MoNA query by structure/molecule identifier:
#> query : atrazine 
#> from : name 
#> Results:
#> Observations: 181
#> Variables: 13
#> $ compound    <list> [<data.frame[1 x 7]>, <data.frame[1 x 7]>, <data.frame[1 x 8]>, <data…
#> $ id          <chr> "VF-NPL-QEHF000343", "VF-NPL-LTQ000149", "MSJ01072", "EA028801", "SM84…
#> $ dateCreated <dbl> 1.536935e+12, 1.536941e+12, 1.487112e+12, 1.487111e+12, 1.487115e+12, …
#> $ lastUpdated <dbl> 1.561569e+12, 1.578459e+12, 1.584678e+12, 1.584678e+12, 1.584672e+12, …
#> $ lastCurated <dbl> 1.561569e+12, 1.578459e+12, 1.584678e+12, 1.584678e+12, 1.584672e+12, …
#> $ metaData    <list> [<data.frame[13 x 6]>, <data.frame[16 x 6]>, <data.frame[21 x 6]>, <d…
#> $ score       <df[,2]> <data.frame[31 x 2]>
#> $ spectrum    <chr> "51.275423:0.031215 51.688508:0.024809 52.610785:0.048546 53.581152:0.…
#> $ splash      <df[,5]> <data.frame[31 x 5]>
#> $ submitter   <df[,5]> <data.frame[31 x 5]>
#> $ tags        <list> [<data.frame[3 x 2]>, <data.frame[3 x 2]>, <data.frame[2 x 2]>, <data…
#> $ library     <df[,4]> <data.frame[31 x 4]>
#> $ annotations <list> [NULL, NULL, NULL, <data.frame[12 x 5]>, <data.frame[17 x 5]>, NULL, …
```

``` r
mona_getMeta(id_query_rst, var = 'category', value = 'mass spectrometry')
#> Observations: 173
#> Variables: 11
#> Groups: id [173]
#> $ id                   <chr> "AU202201", "AU202302", "AU202303", "AU202304", "AU202351", "…
#> $ `collision energy`   <chr> "10 eV", "20 eV", "30 eV", "40 eV", "10 eV", "10 eV", "20 eV"…
#> $ `fragmentation mode` <chr> "CID", "CID", "CID", "CID", "CID", "CID", "CID", "CID", "CID"…
#> $ ionization           <chr> "ESI", "ESI", "ESI", "ESI", "ESI", "ESI", "ESI", "ESI", "ESI"…
#> $ `ionization energy`  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ `ionization mode`    <chr> "positive", "positive", "positive", "positive", "negative", "…
#> $ `mass accuracy_ppm`  <dbl> 0.008163109, 0.211471127, 0.211471127, 0.211471127, 0.0953541…
#> $ `mass error_Da`      <dbl> 1.1920e-06, -3.5972e-05, -3.5972e-05, -3.5972e-05, 1.6028e-05…
#> $ `ms level`           <chr> "MS2", "MS2", "MS2", "MS2", "MS2", "MS2", "MS2", "MS2", "MS2"…
#> $ `precursor type`     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ resolution           <dbl> 35000, 35000, 35000, 35000, 35000, 35000, 35000, 35000, 35000…
```

``` r
mona_getMeta(id_query_rst, var = 'category', value = 'focused ion')
#> Observations: 160
#> Variables: 4
#> Groups: id [160]
#> $ id               <chr> "JP010417", "MSJ01072", "AU202201", "AU202302", "AU202303", "AU20…
#> $ `ion type`       <chr> "[M]+*", "[M]+*", NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ `precursor m/z`  <dbl> NA, 215.0900, 146.0228, 170.1036, 170.1036, 170.1036, 168.0891, 1…
#> $ `precursor type` <chr> NA, NA, "[M+H]+", "[M+H]+", "[M+H]+", "[M+H]+", "[M-H]-", "[M+H]+…
```

``` r
mona_getMeta(id_query_rst, var = 'category', value = 'chromatography')
#> Observations: 148
#> Variables: 9
#> Groups: id [148]
#> $ id                      <chr> "AU202201", "AU202302", "AU202303", "AU202304", "AU202351"…
#> $ column                  <chr> "Acclaim RSLC C18 2.2um, 2.1x100mm, Thermo", "Acclaim RSLC…
#> $ `column temperature`    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ `flow gradient`         <chr> "99/1 at 0-1 min, 61/39 at 3 min, 0.1/99.9 at 14-16 min, 9…
#> $ `flow rate`             <chr> "200 uL/min at 0-3 min, 400 uL/min at 14 min, 480 uL/min a…
#> $ `injection temperature` <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ `retention time`        <chr> "2.878 min", "2.8 min", "2.8 min", "2.9 min", "3.483 min",…
#> $ `SOLVENT A`             <chr> "90:10 water:methanol with 0.01% formic acid and 5mM ammon…
#> $ `SOLVENT B`             <chr> "methanol with 0.01% formic acid and 5mM ammonium formate"…
```

``` r
mona_getMeta(id_query_rst, var = 'name', value = 'ionization')
#> Observations: 148
#> Variables: 2
#> Groups: id [148]
#> $ id         <chr> "AU202201", "AU202302", "AU202303", "AU202304", "AU202351", "AU253701",…
#> $ ionization <chr> "ESI", "ESI", "ESI", "ESI", "ESI", "ESI", "ESI", "ESI", "ESI", "ESI", "…
```

``` r
mona_getMeta(id_query_rst, var = 'name', value = 'ms level')
#> Observations: 179
#> Variables: 2
#> Groups: id [179]
#> $ id         <chr> "AU202201", "AU202302", "AU202303", "AU202304", "AU202351", "AU253701",…
#> $ `ms level` <chr> "MS2", "MS2", "MS2", "MS2", "MS2", "MS2", "MS2", "MS2", "MS2", "MS2", "…
```

``` r
mona_getMeta(id_query_rst, var = 'name', value = 'mass error')
#> Observations: 172
#> Variables: 2
#> Groups: id [172]
#> $ id              <chr> "AU202201", "AU202302", "AU202303", "AU202304", "AU202351", "AU253…
#> $ `mass error_Da` <dbl> 1.1920e-06, -3.5972e-05, -3.5972e-05, -3.5972e-05, 1.6028e-05, -4.…
```

### Spectrum queries

``` r
spec_query_rst <-
  mona_querySpec(
    spectrum = atrazine_ms2,
    minSimilarity = 800,
    precursorMZ = 216,
    precursorToleranceDa = 1
  )
```

``` r
mona_getMeta(spec_query_rst, var = 'category', value = 'mass spectrometry')
#> Observations: 9
#> Variables: 9
#> Groups: id [9]
#> $ id                   <chr> "AU310902", "EA028804", "EA028810", "SM841401", "UA002901", "…
#> $ `collision energy`   <chr> "20 eV", "45 % (nominal)", "45 % (nominal)", "35  (nominal)",…
#> $ `fragmentation mode` <chr> "CID", "HCD", "HCD", "HCD", "CID", "HCD", "CID", NA, NA
#> $ ionization           <chr> "ESI", "ESI", "ESI", "ESI", "ESI", "ESI", "ESI", NA, NA
#> $ `ionization mode`    <chr> "positive", "positive", "positive", "positive", "positive", "…
#> $ `mass accuracy_ppm`  <dbl> 0.2273381, 0.2273381, 0.2273381, 0.2273381, 0.2273381, 0.2273…
#> $ `mass error_Da`      <dbl> -4.91280e-05, -4.91280e-05, -4.91280e-05, -4.91280e-05, -4.91…
#> $ `ms level`           <chr> "MS2", "MS2", "MS2", "MS2", "MS2", "MS2", "MS2", NA, NA
#> $ resolution           <dbl> 35000, 7500, 15000, 35000, 30000, 15000, 15000, NA, NA
```

``` r
mona_getMeta(spec_query_rst, var = 'category', value = 'chromatography')
#> Observations: 7
#> Variables: 7
#> Groups: id [7]
#> $ id               <chr> "AU310902", "EA028804", "EA028810", "SM841401", "UA002901", "UF40…
#> $ column           <chr> "Acclaim RSLC C18 2.2um, 2.1x100mm, Thermo", "XBridge C18 3.5um, …
#> $ `flow gradient`  <chr> "99/1 at 0-1 min, 61/39 at 3 min, 0.1/99.9 at 14-16 min, 99/1 at …
#> $ `flow rate`      <chr> "200 uL/min at 0-3 min, 400 uL/min at 14 min, 480 uL/min at 16-19…
#> $ `retention time` <chr> "8.0 min", "8.3 min", "8.3 min", "9.936 min", "N/A min", "23.294 …
#> $ `SOLVENT A`      <chr> "90:10 water:methanol with 0.01% formic acid and 5mM ammonium for…
#> $ `SOLVENT B`      <chr> "methanol with 0.01% formic acid and 5mM ammonium formate", "meth…
```

``` r
mona_getMeta(spec_query_rst, var = 'name', value = 'mass error')
#> Observations: 9
#> Variables: 2
#> Groups: id [9]
#> $ id              <chr> "AU310902", "EA028804", "EA028810", "SM841401", "UA002901", "UF403…
#> $ `mass error_Da` <dbl> -4.91280e-05, -4.91280e-05, -4.91280e-05, -4.91280e-05, -4.91280e-…
```

## Getting chemical data

``` r
mona_getChem(id_query_rst, var = 'inchi')
#> Observations: 181
#> Variables: 2
#> $ id    <chr> "VF-NPL-QEHF000343", "VF-NPL-LTQ000149", "MSJ01072", "EA028801", "SM841401",…
#> $ inchi <chr> "InChI=1S/C8H14ClN5/c1-4-10-7-12-6(9)13-8(14-7)11-5(2)3/h5H,4H2,1-3H3,(H2,10…
```

``` r
mona_getChem(spec_query_rst, var = 'inchiKey')
#> Observations: 9
#> Variables: 2
#> $ id       <chr> "EA028810", "EA028804", "AU310902", "SM841401", "VF-NPL-QEHF000346", "UF4…
#> $ inchiKey <chr> "MXWJVTOOROXGIU-UHFFFAOYSA-N", "MXWJVTOOROXGIU-UHFFFAOYSA-N", "MXWJVTOORO…
```

``` r
mona_getChem(id_query_rst, var = 'external id')
#> Observations: 161
#> Variables: 8
#> Groups: id [161]
#> $ id            <chr> "MSJ01072", "EA028801", "SM841401", "UA002901", "EA028802", "HMDB004…
#> $ `pubchem cid` <chr> "2256", "2256", "2256", "2256", "2256", NA, "2256", "2256", "2256", …
#> $ cas           <chr> NA, "1912-24-9", "1912-24-9", "1912-24-9", "1912-24-9", NA, "1912-24…
#> $ chebi         <chr> NA, "15930", "15930", NA, "15930", NA, "15930", "15930", "15930", NA…
#> $ kegg          <chr> NA, "C06551", "C06551", "C06551", "C06551", NA, "C06551", "C06551", …
#> $ chemspider    <chr> NA, "2169", "2169", "2169", "2169", NA, "2169", "2169", "2169", NA, …
#> $ `cas number`  <chr> NA, NA, NA, NA, NA, "1912-24-9", NA, NA, NA, "1912-24-9", NA, NA, NA…
#> $ `pubchem sid` <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
```

``` r
mona_getChem(spec_query_rst, var = 'external id')
#> Observations: 7
#> Variables: 6
#> Groups: id [7]
#> $ id            <chr> "EA028810", "EA028804", "AU310902", "SM841401", "UF403301", "UA00290…
#> $ cas           <chr> "1912-24-9", "1912-24-9", "1912-24-9", "1912-24-9", "1912-24-9", "19…
#> $ chebi         <chr> "15930", "15930", "15930", "15930", "15930", NA, "15930"
#> $ kegg          <chr> "C06551", "C06551", "C06551", "C06551", "C06551", "C06551", "C06551"
#> $ `pubchem cid` <chr> "2256", "2256", "2256", "2256", "2256", "2256", "2256"
#> $ chemspider    <chr> "2169", "2169", "2169", "2169", "2169", "2169", "2169"
```

## Getting spectral data

Spectral data is pulled from query results into a list named by spectrum
ID.

``` r
mona_getSpec(slice(id_query_rst,1))
#> List of 1
#>  $ VF-NPL-QEHF000343:Classes 'tbl_df', 'tbl', 'mass_spectrum' and 'data.frame':  538 obs. of  2 variables:
#>   ..$ mz       : num [1:538] 51.3 51.7 52.6 53.6 54.2 ...
#>   ..$ intensity: num [1:538] 0.0312 0.0248 0.0485 0.0425 0.0478 ...
#>  - attr(*, "class")= chr [1:2] "mona_meta" "list"
```

``` r
mona_getSpec(slice(spec_query_rst, 1))
#> List of 1
#>  $ EA028810:Classes 'tbl_df', 'tbl', 'mass_spectrum' and 'data.frame':   16 obs. of  2 variables:
#>   ..$ mz       : num [1:16] 62 68 71.1 79 96.1 ...
#>   ..$ intensity: num [1:16] 0.157 3.545 0.484 3.322 6.234 ...
#>  - attr(*, "class")= chr [1:2] "mona_meta" "list"
```

``` r
mona_getSpec(filter(spec_query_rst, spec_query_rst$hit$id == 'SM841401'))
#> List of 1
#>  $ SM841401:Classes 'tbl_df', 'tbl', 'mass_spectrum' and 'data.frame':   17 obs. of  2 variables:
#>   ..$ mz       : num [1:17] 68 71.1 79 85.1 90 ...
#>   ..$ intensity: num [1:17] 2.841 1.645 8 0.137 0.253 ...
#>  - attr(*, "class")= chr [1:2] "mona_meta" "list"
```

``` r
mona_getSpec(filter(spec_query_rst,spec_query_rst$score > 0.8))
#> List of 3
#>  $ EA028810:Classes 'tbl_df', 'tbl', 'mass_spectrum' and 'data.frame':   16 obs. of  2 variables:
#>   ..$ mz       : num [1:16] 62 68 71.1 79 96.1 ...
#>   ..$ intensity: num [1:16] 0.157 3.545 0.484 3.322 6.234 ...
#>  $ EA028804:Classes 'tbl_df', 'tbl', 'mass_spectrum' and 'data.frame':   12 obs. of  2 variables:
#>   ..$ mz       : num [1:12] 68 71.1 79 96.1 104 ...
#>   ..$ intensity: num [1:12] 2.88 0.507 3.078 5.937 6.846 ...
#>  $ AU310902:Classes 'tbl_df', 'tbl', 'mass_spectrum' and 'data.frame':   17 obs. of  2 variables:
#>   ..$ mz       : num [1:17] 132 133 134 138 138 ...
#>   ..$ intensity: num [1:17] 5.683 0.265 1.7 2.075 1.595 ...
#>  - attr(*, "class")= chr [1:2] "mona_meta" "list"
```

When peak annotations are provided, they can be merged with the spectra
using the `ann` argument.

``` r
mona_getSpec(slice(id_query_rst,150), ann = TRUE)
#> List of 1
#>  $ AU253902:Classes 'tbl_df', 'tbl', 'mass_spectrum' and 'data.frame':   10 obs. of  6 variables:
#>   ..$ mz       : num [1:10] 132 133 134 138 139 ...
#>   ..$ intensity: num [1:10] 27.29 1.21 7.11 8.41 0.64 ...
#>   ..$ category : chr [1:10] "annotation" "annotation" "annotation" "annotation" ...
#>   ..$ computed : logi [1:10] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>   ..$ hidden   : logi [1:10] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>   ..$ name     : chr [1:10] "C4H7ClN3+" "C3[13]CH7ClN3+" "C4H7[37]ClN3+" "C5H8N5+" ...
#>  - attr(*, "class")= chr [1:2] "mona_meta" "list"
```

``` r
mona_getSpec(slice(spec_query_rst, 1), ann = TRUE)
#> List of 1
#>  $ EA028810:Classes 'tbl_df', 'tbl', 'mass_spectrum' and 'data.frame':   16 obs. of  6 variables:
#>   ..$ mz       : num [1:16] 62 68 71.1 79 96.1 ...
#>   ..$ intensity: num [1:16] 0.157 3.545 0.484 3.322 6.234 ...
#>   ..$ category : chr [1:16] "annotation" "annotation" "annotation" "annotation" ...
#>   ..$ computed : logi [1:16] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>   ..$ hidden   : logi [1:16] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>   ..$ name     : chr [1:16] "CHClN+" "C2H2N3+" "C3H7N2+" "CH4ClN2+" ...
#>  - attr(*, "class")= chr [1:2] "mona_meta" "list"
```

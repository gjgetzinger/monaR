An introduction to using the MoNA API with monaR
===========
``` r
devtools::install_github('gjgetzinger/monaR')
library(monaR)
library(dplyr)
```

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
```

### Query by chemical name

Alternatively, we can search by name.

``` r
mona_query(query = 'Microcystin-LR', from = 'name')
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
mona_query(query = 'ZYZCGGRZINLQBL-JCGNTXOTSA-N', from = 'InChIKey')
```

In instances where the target molecule has several stereo isomers, all
isomer matches can be retrieved by queyring by the connectivity part of
the InChI Key alone, which is encoded in the first 14 character.

``` r
mona_query(query = 'ZYZCGGRZINLQBL', from = 'InChIKey')
```

### Query by molecular formula

To retrieve all the extant structural isomers molecule, we can search by
molecular formula.

``` r
mona_query(query = 'C49H74N10O12', from = 'molform')
```

### Query by exact mass

Alternatively the exact mass can be used.

``` r
mona_query(query = 994.5488, from = 'mass')
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
#> # A tibble: 19 x 2
#>    hit$compound $id   $dateCreated $lastUpdated $lastCurated $metaData
#>  * <list>       <chr>        <dbl>        <dbl>        <dbl> <list>   
#>  1 <df[,8] [1 … EA02…      1.49e12      1.58e12      1.58e12 <df[,6] …
#>  2 <df[,8] [1 … EA02…      1.49e12      1.58e12      1.58e12 <df[,6] …
#>  3 <df[,8] [1 … AU31…      1.49e12      1.58e12      1.58e12 <df[,6] …
#>  4 <df[,8] [1 … JP00…      1.49e12      1.58e12      1.58e12 <df[,5] …
#>  5 <df[,8] [1 … SM84…      1.49e12      1.58e12      1.58e12 <df[,6] …
#>  6 <df[,7] [1 … VF-N…      1.54e12      1.56e12      1.56e12 <df[,6] …
#>  7 <df[,8] [1 … UF40…      1.49e12      1.58e12      1.58e12 <df[,6] …
#>  8 <df[,8] [1 … UA00…      1.49e12      1.58e12      1.58e12 <df[,6] …
#>  9 <df[,8] [1 … UF40…      1.49e12      1.58e12      1.58e12 <df[,6] …
#> 10 <df[,7] [1 … VF-N…      1.54e12      1.56e12      1.56e12 <df[,6] …
#> 11 <df[,8] [1 … EA06…      1.49e12      1.58e12      1.58e12 <df[,6] …
#> 12 <df[,8] [1 … EA06…      1.49e12      1.58e12      1.58e12 <df[,6] …
#> 13 <df[,8] [1 … MoNA…      1.55e12      1.56e12      1.56e12 <df[,4] …
#> 14 <df[,6] [1 … CCMS…      1.52e12      1.58e12      1.58e12 <df[,6] …
#> 15 <df[,8] [1 … MoNA…      1.55e12      1.56e12      1.56e12 <df[,4] …
#> 16 <df[,7] [1 … VF-N…      1.54e12      1.58e12      1.58e12 <df[,6] …
#> 17 <df[,8] [1 … HMDB…      1.52e12      1.58e12      1.58e12 <df[,5] …
#> 18 <df[,8] [1 … JP00…      1.49e12      1.58e12      1.58e12 <df[,5] …
#> 19 <df[,8] [1 … MoNA…      1.55e12      1.56e12      1.56e12 <df[,4] …
#> # … with 21 more variables: $annotations <list>, $score$impacts <list>,
#> #   $$score <dbl>, $spectrum <chr>, $splash$block1 <chr>, $$block2 <chr>,
#> #   $$block3 <chr>, $$block4 <chr>, $$splash <chr>, $submitter$id <chr>,
#> #   $$emailAddress <chr>, $$firstName <chr>, $$lastName <chr>,
#> #   $$institution <chr>, $tags <list>, $library$library <chr>,
#> #   $$description <chr>, $$link <chr>, $$tag$ruleBased <lgl>, $$$text <chr>,
#> #   score <dbl>
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
#> # A tibble: 9 x 2
#>   hit$compound $id   $dateCreated $lastUpdated $lastCurated $metaData
#> * <list>       <chr>        <dbl>        <dbl>        <dbl> <list>   
#> 1 <df[,8] [1 … EA02…      1.49e12      1.58e12      1.58e12 <df[,6] …
#> 2 <df[,8] [1 … EA02…      1.49e12      1.58e12      1.58e12 <df[,6] …
#> 3 <df[,8] [1 … AU31…      1.49e12      1.58e12      1.58e12 <df[,6] …
#> 4 <df[,8] [1 … SM84…      1.49e12      1.58e12      1.58e12 <df[,6] …
#> 5 <df[,7] [1 … VF-N…      1.54e12      1.56e12      1.56e12 <df[,6] …
#> 6 <df[,8] [1 … UF40…      1.49e12      1.58e12      1.58e12 <df[,6] …
#> 7 <df[,8] [1 … UA00…      1.49e12      1.58e12      1.58e12 <df[,6] …
#> 8 <df[,8] [1 … UF40…      1.49e12      1.58e12      1.58e12 <df[,6] …
#> 9 <df[,7] [1 … VF-N…      1.54e12      1.56e12      1.56e12 <df[,6] …
#> # … with 21 more variables: $annotations <list>, $score$impacts <list>,
#> #   $$score <dbl>, $spectrum <chr>, $splash$block1 <chr>, $$block2 <chr>,
#> #   $$block3 <chr>, $$block4 <chr>, $$splash <chr>, $submitter$id <chr>,
#> #   $$emailAddress <chr>, $$firstName <chr>, $$lastName <chr>,
#> #   $$institution <chr>, $tags <list>, $library$library <chr>,
#> #   $$description <chr>, $$link <chr>, $$tag$ruleBased <lgl>, $$$text <chr>,
#> #   score <dbl>
```

# Working with results

Queries to MoNA return all results a single tibble. Various helper
functions are provided for accessing the various parts of the query
results. Query results consist of meta data that describes the
experimetnal conditions that the library spectra were acquired under,
chemical information in the form of structural and molecular
representations and identifiers, and spectral data. \#\# Getting meta
data Various aspects of the meta data can be extracted from identifier
and spectra queries. \#\#\# Identifier
queries

``` r
id_query_rst <- mona_query('atrazine', 'name')
```

``` r
mona_getMeta(id_query_rst, var = 'category', value = 'mass spectrometry')
#> # A tibble: 173 x 11
#> # Groups:   id [173]
#>    id    `collision ener… `fragmentation … ionization `ionization ene…
#>    <chr> <chr>            <chr>            <chr>      <chr>           
#>  1 AU20… 10 eV            CID              ESI        <NA>            
#>  2 AU20… 20 eV            CID              ESI        <NA>            
#>  3 AU20… 30 eV            CID              ESI        <NA>            
#>  4 AU20… 40 eV            CID              ESI        <NA>            
#>  5 AU20… 10 eV            CID              ESI        <NA>            
#>  6 AU25… 10 eV            CID              ESI        <NA>            
#>  7 AU25… 20 eV            CID              ESI        <NA>            
#>  8 AU25… 30 eV            CID              ESI        <NA>            
#>  9 AU25… 40 eV            CID              ESI        <NA>            
#> 10 AU25… 50 eV            CID              ESI        <NA>            
#> # … with 163 more rows, and 6 more variables: `ionization mode` <chr>, `mass
#> #   accuracy_ppm` <dbl>, `mass error_Da` <dbl>, `ms level` <chr>, `precursor
#> #   type` <chr>, resolution <dbl>
```

``` r
mona_getMeta(id_query_rst, var = 'category', value = 'focused ion')
#> # A tibble: 160 x 4
#> # Groups:   id [160]
#>    id       `ion type` `precursor m/z` `precursor type`
#>    <chr>    <chr>                <dbl> <chr>           
#>  1 JP010417 [M]+*                  NA  <NA>            
#>  2 MSJ01072 [M]+*                 215. <NA>            
#>  3 AU202201 <NA>                  146. [M+H]+          
#>  4 AU202302 <NA>                  170. [M+H]+          
#>  5 AU202303 <NA>                  170. [M+H]+          
#>  6 AU202304 <NA>                  170. [M+H]+          
#>  7 AU202351 <NA>                  168. [M-H]-          
#>  8 AU253701 <NA>                  188. [M+H]+          
#>  9 AU253702 <NA>                  188. [M+H]+          
#> 10 AU253703 <NA>                  188. [M+H]+          
#> # … with 150 more rows
```

``` r
mona_getMeta(id_query_rst, var = 'category', value = 'chromatography')
#> # A tibble: 148 x 9
#> # Groups:   id [148]
#>    id    column `column tempera… `flow gradient` `flow rate` `injection temp…
#>    <chr> <chr>  <chr>            <chr>           <chr>       <chr>           
#>  1 AU20… Accla… <NA>             99/1 at 0-1 mi… 200 uL/min… <NA>            
#>  2 AU20… Accla… <NA>             99/1 at 0-1 mi… 200 uL/min… <NA>            
#>  3 AU20… Accla… <NA>             99/1 at 0-1 mi… 200 uL/min… <NA>            
#>  4 AU20… Accla… <NA>             99/1 at 0-1 mi… 200 uL/min… <NA>            
#>  5 AU20… Accla… <NA>             99/1 at 0-1 mi… 200 uL/min… <NA>            
#>  6 AU25… Accla… <NA>             99/1 at 0-1 mi… 200 uL/min… <NA>            
#>  7 AU25… Accla… <NA>             99/1 at 0-1 mi… 200 uL/min… <NA>            
#>  8 AU25… Accla… <NA>             99/1 at 0-1 mi… 200 uL/min… <NA>            
#>  9 AU25… Accla… <NA>             99/1 at 0-1 mi… 200 uL/min… <NA>            
#> 10 AU25… Accla… <NA>             99/1 at 0-1 mi… 200 uL/min… <NA>            
#> # … with 138 more rows, and 3 more variables: `retention time` <chr>, `SOLVENT
#> #   A` <chr>, `SOLVENT B` <chr>
```

``` r
mona_getMeta(id_query_rst, var = 'name', value = 'ionization')
#> # A tibble: 148 x 2
#> # Groups:   id [148]
#>    id       ionization
#>    <chr>    <chr>     
#>  1 AU202201 ESI       
#>  2 AU202302 ESI       
#>  3 AU202303 ESI       
#>  4 AU202304 ESI       
#>  5 AU202351 ESI       
#>  6 AU253701 ESI       
#>  7 AU253702 ESI       
#>  8 AU253703 ESI       
#>  9 AU253704 ESI       
#> 10 AU253705 ESI       
#> # … with 138 more rows
```

``` r
mona_getMeta(id_query_rst, var = 'name', value = 'ms level')
#> # A tibble: 179 x 2
#> # Groups:   id [179]
#>    id       `ms level`
#>    <chr>    <chr>     
#>  1 AU202201 MS2       
#>  2 AU202302 MS2       
#>  3 AU202303 MS2       
#>  4 AU202304 MS2       
#>  5 AU202351 MS2       
#>  6 AU253701 MS2       
#>  7 AU253702 MS2       
#>  8 AU253703 MS2       
#>  9 AU253704 MS2       
#> 10 AU253705 MS2       
#> # … with 169 more rows
```

``` r
mona_getMeta(id_query_rst, var = 'name', value = 'mass error')
#> # A tibble: 172 x 2
#> # Groups:   id [172]
#>    id       `mass error_Da`
#>    <chr>              <dbl>
#>  1 AU202201      0.00000119
#>  2 AU202302     -0.0000360 
#>  3 AU202303     -0.0000360 
#>  4 AU202304     -0.0000360 
#>  5 AU202351      0.0000160 
#>  6 AU253701     -0.0000490 
#>  7 AU253702     -0.0000490 
#>  8 AU253703     -0.0000490 
#>  9 AU253704     -0.0000490 
#> 10 AU253705     -0.0000490 
#> # … with 162 more rows
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
#> # A tibble: 9 x 9
#> # Groups:   id [9]
#>   id    `collision ener… `fragmentation … ionization `ionization mod…
#>   <chr> <chr>            <chr>            <chr>      <chr>           
#> 1 AU31… 20 eV            CID              ESI        positive        
#> 2 EA02… 45 % (nominal)   HCD              ESI        positive        
#> 3 EA02… 45 % (nominal)   HCD              ESI        positive        
#> 4 SM84… 35  (nominal)    HCD              ESI        positive        
#> 5 UA00… 35 % (nominal)   CID              ESI        positive        
#> 6 UF40… 55 (nominal)     HCD              ESI        positive        
#> 7 UF40… 35 (nominal)     CID              ESI        positive        
#> 8 VF-N… <NA>             <NA>             <NA>       <NA>            
#> 9 VF-N… <NA>             <NA>             <NA>       <NA>            
#> # … with 4 more variables: `mass accuracy_ppm` <dbl>, `mass error_Da` <dbl>,
#> #   `ms level` <chr>, resolution <dbl>
```

``` r
mona_getMeta(spec_query_rst, var = 'category', value = 'chromatography')
#> # A tibble: 7 x 7
#> # Groups:   id [7]
#>   id    column `flow gradient` `flow rate` `retention time` `SOLVENT A`
#>   <chr> <chr>  <chr>           <chr>       <chr>            <chr>      
#> 1 AU31… Accla… 99/1 at 0-1 mi… 200 uL/min… 8.0 min          90:10 wate…
#> 2 EA02… XBrid… 90/10 at 0 min… 200 ul/min  8.3 min          water with…
#> 3 EA02… XBrid… 90/10 at 0 min… 200 ul/min  8.3 min          water with…
#> 4 SM84… Kinet… 95/5 at 0 min,… 300 uL/min  9.936 min        water with…
#> 5 UA00… N/A    Direct infusio… 5 uL/min    N/A min          methanol   
#> 6 UF40… Kinet… 90/10 at 0 min… 200 uL/min  23.294 min       water with…
#> 7 UF40… Kinet… 90/10 at 0 min… 200 uL/min  23.294 min       water with…
#> # … with 1 more variable: `SOLVENT B` <chr>
```

``` r
mona_getMeta(spec_query_rst, var = 'name', value = 'mass error')
#> # A tibble: 9 x 2
#> # Groups:   id [9]
#>   id                `mass error_Da`
#>   <chr>                       <dbl>
#> 1 AU310902               -0.0000491
#> 2 EA028804               -0.0000491
#> 3 EA028810               -0.0000491
#> 4 SM841401               -0.0000491
#> 5 UA002901               -0.0000491
#> 6 UF403301               -0.0000491
#> 7 UF403303               -0.0000491
#> 8 VF-NPL-QEHF000346      -0.0000512
#> 9 VF-NPL-QEHF000347      -0.0000512
```

## Getting chemical data

``` r
mona_getChem(id_query_rst, var = 'inchi')
#> # A tibble: 181 x 2
#>    id              inchi                                                        
#>    <chr>           <chr>                                                        
#>  1 VF-NPL-QEHF000… InChI=1S/C8H14ClN5/c1-4-10-7-12-6(9)13-8(14-7)11-5(2)3/h5H,4…
#>  2 VF-NPL-LTQ0001… InChI=1S/C8H14ClN5/c1-4-10-7-12-6(9)13-8(14-7)11-5(2)3/h5H,4…
#>  3 MSJ01072        InChI=1S/C8H14ClN5/c1-4-10-7-12-6(9)13-8(14-7)11-5(2)3/h5H,4…
#>  4 EA028801        InChI=1S/C8H14ClN5/c1-4-10-7-12-6(9)13-8(14-7)11-5(2)3/h5H,4…
#>  5 SM841401        InChI=1S/C8H14ClN5/c1-4-10-7-12-6(9)13-8(14-7)11-5(2)3/h5H,4…
#>  6 JP010417        InChI=1S/C8H14ClN5/c1-4-10-7-12-6(9)13-8(14-7)11-5(2)3/h5H,4…
#>  7 UA002901        InChI=1S/C8H14ClN5/c1-4-10-7-12-6(9)13-8(14-7)11-5(2)3/h5H,4…
#>  8 VF-NPL-QEHF000… InChI=1S/C8H14ClN5/c1-4-10-7-12-6(9)13-8(14-7)11-5(2)3/h5H,4…
#>  9 EA028802        InChI=1S/C8H14ClN5/c1-4-10-7-12-6(9)13-8(14-7)11-5(2)3/h5H,4…
#> 10 VF-NPL-QEHF000… InChI=1S/C8H14ClN5/c1-4-10-7-12-6(9)13-8(14-7)11-5(2)3/h5H,4…
#> # … with 171 more rows
```

``` r
mona_getChem(spec_query_rst, var = 'inchiKey')
#> # A tibble: 9 x 2
#>   id                inchiKey                   
#>   <chr>             <chr>                      
#> 1 EA028810          MXWJVTOOROXGIU-UHFFFAOYSA-N
#> 2 EA028804          MXWJVTOOROXGIU-UHFFFAOYSA-N
#> 3 AU310902          MXWJVTOOROXGIU-UHFFFAOYSA-N
#> 4 SM841401          MXWJVTOOROXGIU-UHFFFAOYSA-N
#> 5 VF-NPL-QEHF000346 <NA>                       
#> 6 UF403301          MXWJVTOOROXGIU-UHFFFAOYSA-N
#> 7 UA002901          MXWJVTOOROXGIU-UHFFFAOYSA-N
#> 8 UF403303          MXWJVTOOROXGIU-UHFFFAOYSA-N
#> 9 VF-NPL-QEHF000347 <NA>
```

``` r
mona_getChem(id_query_rst, var = 'external id')
#> # A tibble: 161 x 8
#> # Groups:   id [161]
#>    id      `pubchem cid` cas   chebi kegg  chemspider `cas number` `pubchem sid`
#>    <chr>   <chr>         <chr> <chr> <chr> <chr>      <chr>        <chr>        
#>  1 MSJ010… 2256          <NA>  <NA>  <NA>  <NA>       <NA>         <NA>         
#>  2 EA0288… 2256          1912… 15930 C065… 2169       <NA>         <NA>         
#>  3 SM8414… 2256          1912… 15930 C065… 2169       <NA>         <NA>         
#>  4 UA0029… 2256          1912… <NA>  C065… 2169       <NA>         <NA>         
#>  5 EA0288… 2256          1912… 15930 C065… 2169       <NA>         <NA>         
#>  6 HMDB00… <NA>          <NA>  <NA>  <NA>  <NA>       1912-24-9    <NA>         
#>  7 UF4033… 2256          1912… 15930 C065… 2169       <NA>         <NA>         
#>  8 EA0288… 2256          1912… 15930 C065… 2169       <NA>         <NA>         
#>  9 EA0288… 2256          1912… 15930 C065… 2169       <NA>         <NA>         
#> 10 HMDB00… <NA>          <NA>  <NA>  <NA>  <NA>       1912-24-9    <NA>         
#> # … with 151 more rows
```

``` r
mona_getChem(spec_query_rst, var = 'external id')
#> # A tibble: 7 x 6
#> # Groups:   id [7]
#>   id       cas       chebi kegg   `pubchem cid` chemspider
#>   <chr>    <chr>     <chr> <chr>  <chr>         <chr>     
#> 1 EA028810 1912-24-9 15930 C06551 2256          2169      
#> 2 EA028804 1912-24-9 15930 C06551 2256          2169      
#> 3 AU310902 1912-24-9 15930 C06551 2256          2169      
#> 4 SM841401 1912-24-9 15930 C06551 2256          2169      
#> 5 UF403301 1912-24-9 15930 C06551 2256          2169      
#> 6 UA002901 1912-24-9 <NA>  C06551 2256          2169      
#> 7 UF403303 1912-24-9 15930 C06551 2256          2169
```

## Getting spectral data

Spectral data is pulled from query results into a list named by spectrum
ID.

``` r
mona_getSpec(slice(id_query_rst,1))
#> $`VF-NPL-QEHF000343`
#> # A tibble: 538 x 2
#>       mz intensity
#>    <dbl>     <dbl>
#>  1  51.3    0.0312
#>  2  51.7    0.0248
#>  3  52.6    0.0485
#>  4  53.6    0.0425
#>  5  54.2    0.0478
#>  6  54.3    0.0446
#>  7  54.5    0.0276
#>  8  55.0    0.0264
#>  9  55.2    0.0281
#> 10  56.0    0.0407
#> # … with 528 more rows
```

``` r
mona_getSpec(slice(spec_query_rst, 1))
#> $EA028810
#> # A tibble: 16 x 2
#>       mz intensity
#>    <dbl>     <dbl>
#>  1  62.0     0.157
#>  2  68.0     3.54 
#>  3  71.1     0.484
#>  4  79.0     3.32 
#>  5  96.1     6.23 
#>  6 104.      6.37 
#>  7 110.      0.127
#>  8 132.      5.10 
#>  9 138.      1.58 
#> 10 138.      0.881
#> 11 146.      3.58 
#> 12 146.      0.722
#> 13 174.    100    
#> 14 180.      0.418
#> 15 188.      0.638
#> 16 216.     86.4
```

``` r
mona_getSpec(filter(spec_query_rst, spec_query_rst$hit$id == 'SM841401'))
#> $SM841401
#> # A tibble: 17 x 2
#>       mz intensity
#>    <dbl>     <dbl>
#>  1  68.0     2.84 
#>  2  71.1     1.65 
#>  3  79.0     8.00 
#>  4  85.1     0.137
#>  5  90.0     0.253
#>  6  96.1    11.1  
#>  7 104.      7.58 
#>  8 110.      0.687
#>  9 132.      7.97 
#> 10 138.      2.07 
#> 11 138.      1.35 
#> 12 146.      5.86 
#> 13 146.      1.07 
#> 14 174.     61.7  
#> 15 180.      0.218
#> 16 188.      0.361
#> 17 216.    100
```

``` r
mona_getSpec(filter(spec_query_rst,spec_query_rst$score > 0.8))
#> $EA028810
#> # A tibble: 16 x 2
#>       mz intensity
#>    <dbl>     <dbl>
#>  1  62.0     0.157
#>  2  68.0     3.54 
#>  3  71.1     0.484
#>  4  79.0     3.32 
#>  5  96.1     6.23 
#>  6 104.      6.37 
#>  7 110.      0.127
#>  8 132.      5.10 
#>  9 138.      1.58 
#> 10 138.      0.881
#> 11 146.      3.58 
#> 12 146.      0.722
#> 13 174.    100    
#> 14 180.      0.418
#> 15 188.      0.638
#> 16 216.     86.4  
#> 
#> $EA028804
#> # A tibble: 12 x 2
#>       mz intensity
#>    <dbl>     <dbl>
#>  1  68.0     2.88 
#>  2  71.1     0.507
#>  3  79.0     3.08 
#>  4  96.1     5.94 
#>  5 104.      6.85 
#>  6 132.      5.48 
#>  7 138.      1.06 
#>  8 138.      0.852
#>  9 146.      3.99 
#> 10 146.      0.798
#> 11 174.    100    
#> 12 216.     89.1  
#> 
#> $AU310902
#> # A tibble: 17 x 2
#>       mz intensity
#>    <dbl>     <dbl>
#>  1  132.     5.68 
#>  2  133.     0.265
#>  3  134.     1.70 
#>  4  138.     2.08 
#>  5  138.     1.60 
#>  6  146.     4.54 
#>  7  147.     0.201
#>  8  148.     1.23 
#>  9  174.   100    
#> 10  175.     4.54 
#> 11  176.    24.9  
#> 12  177.     0.625
#> 13  180.     0.658
#> 14  216.    62.8  
#> 15  217.     5.13 
#> 16  218.    15.9  
#> 17  219.     0.765
```

When peak annotations are provided, they can be merged with the spectra
using the `ann` argument.

``` r
mona_getSpec(slice(id_query_rst,150), ann = TRUE)
#> $AU253902
#> # A tibble: 10 x 6
#>       mz intensity category   computed hidden name          
#>    <dbl>     <dbl> <chr>      <lgl>    <lgl>  <chr>         
#>  1  132.    27.3   annotation FALSE    FALSE  C4H7ClN3+     
#>  2  133.     1.21  annotation FALSE    FALSE  C3[13]CH7ClN3+
#>  3  134.     7.11  annotation FALSE    FALSE  C4H7[37]ClN3+ 
#>  4  138.     8.41  annotation FALSE    FALSE  C5H8N5+       
#>  5  139.     0.640 annotation FALSE    FALSE  C4[13]CH8N5+  
#>  6  146.    15.1   annotation FALSE    FALSE  C3H5ClN5+     
#>  7  148.     4.79  annotation FALSE    FALSE  C3H5[37]ClN5+ 
#>  8  174.   100     annotation FALSE    FALSE  C5H9ClN5+     
#>  9  175.     5.30  annotation FALSE    FALSE  C4[13]CH9ClN5+
#> 10  176.    28.2   annotation FALSE    FALSE  C5H9[37]ClN5+
```

``` r
mona_getSpec(slice(spec_query_rst, 1), ann = TRUE)
#> $EA028810
#> # A tibble: 16 x 6
#>       mz intensity category   computed hidden name      
#>    <dbl>     <dbl> <chr>      <lgl>    <lgl>  <chr>     
#>  1  62.0     0.157 annotation FALSE    FALSE  CHClN+    
#>  2  68.0     3.54  annotation FALSE    FALSE  C2H2N3+   
#>  3  71.1     0.484 annotation FALSE    FALSE  C3H7N2+   
#>  4  79.0     3.32  annotation FALSE    FALSE  CH4ClN2+  
#>  5  96.1     6.23  annotation FALSE    FALSE  C4H6N3+   
#>  6 104.      6.37  annotation FALSE    FALSE  C2H3ClN3+ 
#>  7 110.      0.127 annotation FALSE    FALSE  C3H4N5+   
#>  8 132.      5.10  annotation FALSE    FALSE  C4H7ClN3+ 
#>  9 138.      1.58  annotation FALSE    FALSE  C5H8N5+   
#> 10 138.      0.881 annotation FALSE    FALSE  C7H12N3+  
#> 11 146.      3.58  annotation FALSE    FALSE  C3H5ClN5+ 
#> 12 146.      0.722 annotation FALSE    FALSE  C5H9ClN3+ 
#> 13 174.    100     annotation FALSE    FALSE  C5H9ClN5+ 
#> 14 180.      0.418 annotation FALSE    FALSE  C8H14N5+  
#> 15 188.      0.638 annotation FALSE    FALSE  C6H11ClN5+
#> 16 216.     86.4   annotation FALSE    FALSE  C8H15ClN5+
```

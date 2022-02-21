# singularity-rebuilt-nfcore
A bash script to rebuilt the singularity images for nf-core pipelines.

**Introduction** \
A bash script to rebuild the singularity containers for the nf-core/mag pipeline with same name as required. \
This is useful in a scenario when a user have `singularity v2 instead v3` installed on their local machine and \
cannot upgrade. At the moment its only tested for `nf-core/mag` pipeline. The background information required \
for developing this script was obtained from https://nf-co.re/tools/#downloading-pipelines-for-offline-use \
For further information on the different nf-core pipelines refer to citation section below.

**To rebuiltd the singularity images** \
`bash rebuilt.sh $tool_name` ($tool_name=mag) \
`bash rebuilt.sh mag` 

**Expected output**
```
$PWD
|
|---configs/
|        |---configtest.nf
|        |---nexftlow.config
|        |---nfcore_custom.config
|        .
|        .    
|---singularity-images/
|        |---tool1.img
|        |---tool2.img
|        |---tool3.img
|        .
|        .
|---workflow/
|        |---assets/
|        |---bin/
|        |--main.nf
|        .
|        .

```
**Note** \
Edit the ./workflows/nextflow.config \
Add the following statement at the bottom in the nextflow.config

```singularity.cacheDir = "${projectDir}/../singularity-images/"```

**For citation** \
Please refer to their nfc-core home page
* https://nf-co.re/
* https://nf-co.re/tools/#downloading-pipelines-for-offline-use
* https://nf-co.re/mag/2.1.1

# Disease annotations

The HPO team is transitioning to [GA4GH Phenopacket](https://phenopacket-schema.readthedocs.io/en/latest/){:target="\_blank"} format for annotating cases and diseases. We have created the
[phenopacket store](https://github.com/monarch-initiative/phenopacket-store){:target="\_blank"} as a repository for individual-level information. We are working on the [pyphetools](https://monarch-initiative.github.io/pyphetools/){:target="\_blank"} package to streamline annotation of phenopackets.

Our software for this application is in development. We will discuss current options during the workshop.


## RareLink
[RareLink](https://rarelink.readthedocs.io/en/latest/index.html){:target="\_blank"} is a new tool that enables efficient and accurate entry of HPO and other data related to rare disease medicine.

[RareLink](https://rarelink.readthedocs.io/en/latest/index.html){:target="\_blank"} is a tool for managing and processing rare disease data within the REDCap. RareLink aims to maximise the utility of REDCap by providing a comprehensive framework designed specifically for rare disease (RD) research and care. RareLink streamlines import of tabular data (e.g., Excel, relational database).

RareLink additionally provides a preconfigured data collection sheets based on the RD-CDM and user guides for manual data capture to ensure precision and correctness of data captured. Further, RareLink defines guidelines for developing more specialised REDCap sheets around the RD-CDM so that the data captured can also be processed by our framework to generate FHIR resources and Phenopackets.

RareLink is designed to be deployed and installed in a local REDCap instance. Using the guidelines provided, or using our preconfigured RareLink-REDCap and setting up the RareLink API, you can ensure that the data captured is compliant with the our framework to generate FHIR resources and Phenopackets.

We will typically provide a short introduction to RareLink at HPO workshops.
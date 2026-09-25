
# Overview

S-SDLC (Secure - Software Development Life Cycle) consists of incorporating security in all phases of the software development life cycle,
from the previous analysis and design to the final implementation and maintenance.
In this way, the security of the resulting product is increased and the development cycle is more efficient.
The S-SDLC model should be applied regardless of the development methodology followed.

Software Development Lifecycle (SDLC) is a set of processes that define the steps involved in the development of software at each phase.
It covers the detailed plan for building, deploying and maintaining the software. Software Development Life Cycle defines the complete
cycle of development through various stages (phases) i.e. from inception to retirement of the product. Each one of the phases can have
multiple and important tasks.

Developments following agile methodology consider collaborative and multidisciplinary teams (DevSecOps) continuously interacting among
the different phases for exploring, designing and testing the IT solution delivered.

The phases of the SDLC cycle defined in the Secure Development Standard are the following:

<div class="steps" markdown>

- **Planning**

- **Definition**

- **Construction**

- **Testing**

- **Deployment**

- **Operations/Maintenance (Production)**

</div>

In the image below you can see the milestones to be taken into account in each of the phases:

![ssdlc-model](../../../components/configuration/security/images/ssdlc-model.png)

Gluon has integrated the S-SDLC services from Detect Global Services (SAST, SCA and DAST services) for ensure the SSDLC policy compliance:

The tools implemented from Detect Global Services are:

- **SAST** Opentext Fortify Source Code Analyzer for scan source code.

- **SCA** Sonatype LifeCycle for scan third party software libraries.

- **DAST** OpenText Fortify Webinspect for scan dynamically applications in execution.

The three tools are integrated with Fortify Software Security Center platform where the users can check the security status of each software component. Fortify SSC platform access from [here](https://ssc.santander.fortifyhosted.com)

## S-SDLC information

You can access to full SSDLC details at [Secure SDLC Portal](https://santandernet.sharepoint.com/sites/SecureSDLC){:target="_blank"}

</div>

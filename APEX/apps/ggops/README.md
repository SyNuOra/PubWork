# GG Ops APEX Application

This application is a sample APEX app, that demonstrates working with the Oracle GoldenGate (OGG) Micro Services Architecture (MSA) REST service APIs. 

The app allows the user to connect to OGG MSA deployments, retrieve existing configurations and allow the user to copy processes, Extract or Replicate, between the deployment, prompting for relevant credentials and the user can update the property files.

**This has not been tested with Big Data Deployments**

If you do incorporate portions or projects based on what you have seen here, it would be nice to get a nod back to this contribution and me as the author.

SQLcl projects was used to export the project using an Admin user connection and includes sys grants that should be granted to the user. 

The src or distribution folder are provide, so the application source can be reviewed. The APEX app has been exported with supporting objects to simplify the review of the application.
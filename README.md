
##AWS Architecture
See the "proposed infrastructure stack.png" for the AWS architecture design.
A serverless approach would be used for this simple CRUD API. The lambda would also
benefit of AWS multi-region availability by simply specifying the regions on the infrastructure tool settings.

*Note that the Python application would have to be slightly modified to include the lambda handler
as a replacement for the flask endpoints.

##Requirements for local Testing and future Development
1) Docker **and** Docker Compose: This is to spin up MongoDB as the datastore for the application.
2) Python 3

##Local setup and testing
A Makefile is included to simplify local development and testing.
run `make help` for the list of commands. 

For an initial setup: `make environment && source .venv/bin/activate && python setup.py develop` (Required)

Run the tests: `make test`

Spin up the datastore (MongoDB) locally: `docker-compose up -d`

Run the integration tests: `make integration-test` (requires local datastore, see the previous step)

Run the application: `python app/main.py` (Make sure to run `docker-compose up -d` first) 

Access the Swagger Documentation: http://localhost:8888/api/

For troubleshooting: Ensure that the first initial setup command has ran successfully.

##Future Considerations

1) Performance: The application should perform well under heavy traffic, 
i.e to cater for spikes in traffic in the morning and in the evening, the lambda function AWS auto-scaling rules should cater for
launching additional instances depending on traffic.

2) Security: The standalone app doesn't have security enabled on the endpoints but once in AW the lambda function will benefit of all AWS security options.

4) Scalability: The lambda function would have auto-scaling on, for the datastore although MongoDB isn't in RDS, services such as MongoDB Atlas (https://www.mongodb.com/cloud/atlas/aws-mongodb) 
can make it fully AWS managed; scalability, maintenance free etc.

5) I18N: Not considered at this stage as order details don't contain user data but standard vehicles' information. 
However, if this changes, templates could be used to cater for internationalization settings. 


##Assumptions and Additional/Missing Functionality

The specs mention "Orders are short-lived and do not need to be kept for longer than 3 days". The logic to cater for this
is not currently in place. There are many ways to eliminate of old orders, one option would be to use MongoDB built-in functionality as:

`ObjectId("5f7b7d246a68932bc48b1139").getTimestamp()` which returns `ISODate("2020-10-05T20:08:04Z")` that represents the date of insertion.
The ObjectId is used as the order uuid identifier. A scheduled task could run from within the lambda to purge orders that are older than 3 days based
on the timestamp returned by a search query. Another option to include a timestamp with the order payload insertion.

Alternatively, when making design decisions, the use of a caching mechanism was another option such as the use of an in memory, key-value pair database: Redis.
In this scenario, a logic to auto clear insertions older than 3 days would have to be put in place.
AWS Lambda
==========

[AWS Lambda][] ([developer guide]) runs "serverless" functions  in an
AWS environment using Node.js, Java, C#, Python 2/3, Go or native
Linux binaries. See [Supported Versions][env-ver] for more language
and library details.


Overview
--------

Functions are set up with a deployment package (max 50 MB ZIP and 250
MB uncompressed) containing code and data files and a function
configuration indicating what function to call (the "handler") and
other parameters when a request to run the function is received.


The function is run in an "Execution Context" (a Docker container or
similar on [Amazon Linux][env-ver]) with the configured amount of
memory/CPU and 500 MB of storage space in `/tmp/`. The containers and
their processes are cached to be reused in subsequent calls which will
be run in the same interpreter, allowing you to re-use disk files and
interpreter environment set up in previous calls. However, state you
want to keep must be stored outside Lambda (e.g., in S3). See
[Execution Model] and [Programming Model] for more details.

Lambda functions may be run "in" VPCs; this is useful only if you need
to access resources in that particular VPC. The VPC will have to have
NAT configured if the Lambda function also needs Internet access. (See
[Best Practices] for more information on Lambda VPCs.)


Handler API
-----------

The handler function takes two parameters: the event data and a
context. The context gives access to the AWS API and also provides
event handlers (e.g., to return a value to the caller) when using
async programming. Logging will go to CloudWatch.

Documentation Quicklinks:
* [General Programming Model][programming model]
* [Python Programming Model]
  * [Lambda Function Handler][py-handler]
  * [Context Object][py-context]
  * [Logging][py-logging]
  * [Exceptions][py-errors]
* [Pre-set Environment Variables][env-ver]
* [Configured Environment Variables][set-env] (max 4 KB)
* [Best Practices]


Deployment
----------

Deployment is done via the console or the following AWS API / [boto3] calls:
* [CreateFunction][] ([`create_function`])
* [UpdateFunctionConfiguration][] ([`update_function_configuration`])
* [UpdateFunctionCode][] (boto3 [`update_function_code`])

Also see:
* [Deploying Lambda-based Applications][deploying]
* [Creating a Deployment Package][py-deploy] (ZIP file)

    aws lambda create-function
      --runtime nodejs|nodejs8.10|java8|python2.7|python3.6|go1.x|...
      --function-name MyLambdaFunc          # case-sensitive
      --handler packagename.func            # Python
      --role RoleARN
      [--description 'some desc']
      [--timeout 3]                         # seconds
      [--memory-size 128]                   # MB, also determines CPU
      [--tags 'k1=value,k2=another value']  # or JSON { "key": "value" }
      [--zip-file fileb://lambda.zip]

Alternatively, you can use a JSON document to specify the parameters:

    aws lambda create-function --generate-cli-skeleton > create-params
    vim create-params
    aws lambda --cli-input-json "$(cat create-params)"

(This `--generate-cli-skeleton` can be passed to many other `aws lambda`
commands as well.)


Invocation
----------

Lambda functions can be [invoked][invoking] via the [Invoke] or
[InvokeAsync] (boto3 [`invoke`], [`invoke_async`]) API calls or via
[events] published by various Amazon services.

Calling via CLI, `OUTFILE` will contain what the function returned and
stdout will contain the status code, executed version and optional log
output.

    aws lambda invoke --function-name F
        --payload '{ "json": "document" }
        [--invocation-type DryRun|RequestResponse|Event]
        [--log-type Tail]           # adds last 4k of log output
        OUTFILE                     # cannot use - for stdout

Decode base64 log output with:

    print(base64.decodebytes(b'...').decode('utf-8'))

#### Invocation Problems

If you get an unhandled error when trying to invoke the function and the
log says

    module initialization error: [Errno 13] Permission denied: '/var/task/lambda_function.py'

you need to set more open permissions when building your your zip file, e.g.:

    zinfo = zipfile.ZipInfo(file_name)
    zinfo.external_attr = 0o777 << 16  # give full access to included file
    ziph.writestr(zinfo, my_data)

(Reference [so-46076543].)


Other Features
--------------

* Each version of function has its own unique, immutable Amazon
  Resource Name (ARN). Aliases are additional names that point to a
  particular version but can be changed to point to a different
  version. See [Versioning and Aliases][ver-alias] for more details.

* Various AWS tools can be combined for a full deployment pipeline
  (including gradual deployment) for functions and the other resources
  they use. See [Automating Deployment] for more details.

* [Monitoring and Troubleshooting][mon]



[AWS Lambda]: https://aws.amazon.com/lambda/
[Best Practices]: https://docs.aws.amazon.com/lambda/latest/dg/best-practices.html
[CreateFunction]: https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html
[InvokeAsync]: https://docs.aws.amazon.com/lambda/latest/dg/API_InvokeAsync.html
[Invoke]: https://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html
[Python Programming Model]: https://docs.aws.amazon.com/lambda/latest/dg/python-programming-model.html
[UpdateFunctionCode]: https://docs.aws.amazon.com/lambda/latest/dg/API_UpdateFunctionCode.html
[UpdateFunctionConfiguration]: https://docs.aws.amazon.com/lambda/latest/dg/API_UpdateFunctionConfiguration.html
[`create_function`]: https://boto3.readthedocs.io/en/latest/reference/services/lambda.html#Lambda.Client.create_function
[`invoke_async`]: https://boto3.readthedocs.io/en/latest/reference/services/lambda.html#Lambda.Client.invoke
[`invoke`]: https://boto3.readthedocs.io/en/latest/reference/services/lambda.html#Lambda.Client.invoke
[`update_function_code`]: https://boto3.readthedocs.io/en/latest/reference/services/lambda.html#Lambda.Client.update_function_code
[`update_function_configuration`]: https://boto3.readthedocs.io/en/latest/reference/services/lambda.html#Lambda.Client.update_function_configuration
[automating deployment]: https://docs.aws.amazon.com/lambda/latest/dg/automating-deployment.html
[boto3]: https://boto3.readthedocs.io/en/latest/reference/services/lambda.html
[deploying]: https://docs.aws.amazon.com/lambda/latest/dg/deploying-lambda-apps.html
[developer guide]: https://docs.aws.amazon.com/lambda/latest/dg/welcome.html
[env-ver]: https://docs.aws.amazon.com/lambda/latest/dg/current-supported-versions.html
[events]: https://docs.aws.amazon.com/lambda/latest/dg/invoking-lambda-function.html
[execution model]: https://docs.aws.amazon.com/lambda/latest/dg/running-lambda-code.html
[invoking]: https://docs.aws.amazon.com/lambda/latest/dg/invoking-lambda-functions.html
[mon]: https://docs.aws.amazon.com/lambda/latest/dg/troubleshooting.html
[programming model]: https://docs.aws.amazon.com/lambda/latest/dg/programming-model-v2.html
[py-context]: https://docs.aws.amazon.com/lambda/latest/dg/python-context-object.html
[py-deploy]: https://docs.aws.amazon.com/lambda/latest/dg/lambda-python-how-to-create-deployment-package.html
[py-errors]: https://docs.aws.amazon.com/lambda/latest/dg/python-exceptions.html
[py-handler]: https://docs.aws.amazon.com/lambda/latest/dg/python-programming-model-handler-types.html
[py-logging]: https://docs.aws.amazon.com/lambda/latest/dg/python-logging.html
[set-env]: https://docs.aws.amazon.com/lambda/latest/dg/env_variables.html
[so-46076543]: https://stackoverflow.com/q/46076543/107294
[ver-aliase]: https://docs.aws.amazon.com/lambda/latest/dg/versioning-aliases.html

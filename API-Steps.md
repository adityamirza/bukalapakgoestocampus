# API Steps Guideline

Read this guideline to develop API automation steps

For using API Steps, you must provide these environment variables in your `.env` file:

* `API_CLIENT_ID`: Doorkeeper client ID
* `API_CLIENT_SECRET`: Doorkeeper client secret
* `ACCOUNTS_URL`: Doorkeeper account URL, e.g. http://accounts.stagingxxx.vm
* `USERNAME`: Bukalapak application account username
* `PASSWORD`: Bukalapak application account password
* `APIV4_SMOKE_TEST_URL`, `APIV4_STAGING_URL`, or `APIV4_URL`: APIv4 endpoint base URL, e.g. http://api.stagingxxx.vm:8089
* `API_SMOKE_TEST_URL`, `API_STAGING_URL`, or `API_URL`: APIv2 endpoint base URL, e.g. http://api.stagingxxx.vm/v2

Optional environment variables:

* `SCOPE`: Doorkeeper scope, defaults to `public user`

### Step 1: which API will you use? v2 or v4?

If it is APIv2 you have to start by using one of these steps:

```cucumber
Given client not logged in for APIv2
Given client logged in for APIv2
Given client logged in for APIv2 with "USERNAME" and "PASSWORD"
```

If it is APIv4 you have to know if you need to use logged in access token or not, if you are not sure: use the logged in steps

```cucumber
Given client fetched APIv4 access token without login
Given client logged in for APIv4
Given client logged in for APIv4 with "USERNAME" and "PASSWORD"
```

**Note**: `USERNAME` and `PASSWORD` is username and password variables you declare in `.env` file, one of the other example is `BUYER_USERNAME` and `BUYER_PASSWORD`

---

There is a special case for APIv4 internal endpoints, because they use basic authentication and hit endpoint with port (or different custom URL), use these steps as example to start your internal APIv4 scenarios:

```cucumber
Given internal APIv4 URL "your_custom_url"
And client logged in for APIv4 internal endpoint
```

Those steps depend on `SERVICE_USERNAME` and `SERVICE_PASSWORD` environment variables, so make sure you define them in your `.env` file. You may change `your_custom_url` to your full service URL, e.g. `http://tixxy.stagingxxx.vm` or `http://api.stagingxxx.vm:6969`

---

If you need a custom header when requesting, you can add multiple key with this step:

```cucumber
Given client logged in for APIv4
And client wanted to add header:
  | User-Agent | blios BLMobile/0208001 |
  | appVersion | 0208001                |
```

**Note**: it will overwrite the default header provided by previous log in/or not step

If you need to delete a header, you can use this step:

```cucumber
Given client wanted to delete header "Accept"
```

### Step 2: Hit the API endpoint

Basically, to hit any API endpoint you can use these steps:

```cucumber
When client sends a GET request to "/get_endpoint"
When client sends a PATCH request to "/patch_endpoint"
When client sends a POST request to "/post_endpoint"
When client sends a PUT request to "/put_endpoint"
When client sends a DELETE request to "/delete_endpoint"
```

If you need to parse a custom body when hitting the endpoint, you can add body in cucumber `DataTable` like this:

```cucumber
When client sends a POST request to "/post_endpoint" with body:
  | id    | 13                             |
  | name  | the-one-who-shall-not-be-named |
```

or as raw `JSON` file like this:

```cucumber
When client sends a POST request to "/post_endpoint" with body:
  """
  {"id": 13, "name": "the-one-who-shall-not-be-named"}
  """
```

If you want to print the detail of your request, you can add `verbose` before the method declaration, e.g.:

```cucumber
When client sends a verbose GET request to "/get_endpoint"
When client sends a verbose PATCH request to "/patch_endpoint"
When client sends a verbose POST request to "/post_endpoint"
When client sends a verbose PUT request to "/put_endpoint"
When client sends a verbose DELETE request to "/delete_endpoint"
```

---

At any case you need to log out, just use this step:

```cucumber
When client logs out
```

---

At any case you need to retrieve some value from previous response use these steps:

```cucumber
When client collects "$..name"
When client collects "$..full_name" as "name"
```

The first step will assign JSON path `$..name` to `@name` variable and the second step will assign JSON path `$..full_name` to `@name`. This will save you some time instead of creating a new step definition to retrieve data from previous response.

To use it when hitting an endpoint, close your variable name with curly brackets (`{}`)

```cucumber
When client sends a GET request to "/get_endpoint/{id}"
```

To use it inside request body, close your variable name with double curly brackets (`{{}}`)

```cucumber
When client sends a GET request to "/get_endpoint" with body:
  | name | {{name}} |
When client sends a GET request to "/get_endpoint" with body:
  """
  {
    "name": "{{name}}"
  }
  """
```

### Step 3: What will you do with the response?

These are some things you can do with the response (based on the provided steps):
* Check the response status
```cucumber
Then response status should be "200"
```
* Print the headers
```cucumber
Then show me the headers
```
* Print the response
```cucumber
Then show me the response
```
* Check if the response has key using [jsonpath](http://goessner.net/articles/JsonPath/)
```cucumber
Then response should have "$..name"
Then response should not have "$..name"
```
* Check a value matching some string, using [jsonpath](http://goessner.net/articles/JsonPath/)
```cucumber
Then response should have "$..name" matching "Lord Voldemort"
Then response should not have "$..name" matching "Lord Voldemort"
```
* Check a value containing some string/regex [jsonpath](http://goessner.net/articles/JsonPath/)
```cucumber
Then response should have "$..name" containing "^.*Voldemort"
Then response should not have "$..name" containing "^.*Voldemort"
```
* Check a value type (boolean, string, integer, datetime, or float), using [jsonpath](http://goessner.net/articles/JsonPath/)
```cucumber
Then response "$..name" should be string
Then response "$..age" should be integer
Then response "$..live_status" should be boolean
Then response "$..born_date" should be datetime
Then response "$..height" should be float
```
* Compare the response as a whole
```cucumber
Then response should be:
"""
{"name": "Lord Voldemort"}
"""
```
* Compare a whole part of a response using [jsonpath](http://goessner.net/articles/JsonPath/)
```cucumber
Then response in "$..name" should be:
"""
["Lord Voldemort", "Voldemort", "the-one-who-shall-not-be-named"]
"""
```
* Count the size of a value using [jsonpath](http://goessner.net/articles/JsonPath/)
```cucumber
Then response should have 7 "$..books"
```

* Check a key inside the response containing some value inside an environment variables, using [jsonpath]
```cucumber
Then response should have "$..name" matching "ENV:NAME"
Then response should not have "$..name" matching "ENV:NAME"
```

### Notes

If you need to add a new API step you can add to one of these files:
* `/features/step_definitions/api/api.rb` for general API steps
* `/features/step_definitions/api/api_steps.rb` for specific API steps
* `/features/step_definitions/api/api_<squad_name>_steps.rb` for specific squad API steps

Don't forget to ask for review, especially for steps inside `api.rb` and make sure to update this file as well.

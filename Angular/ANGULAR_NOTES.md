# Install Ramda for Angular with npm
```
npm i -D @types/ramda ramda
```

# How to update each dependency in package.json to the latest version?
```
$ npx npm-check-updates -u
$ npm install 
```
# Angular HTTP - Core HTTP API Setup & Usage

## Inject and use the Http client library
It's a service we inject into the component's constructor. First, we must import the HttpModule in the root module or through a shared module.
```
constructor(private http: HttpClient) { }
```

To pass query params to the GET url, we use the **HttpParams** object.
```
  doGET() {
    
    const url = `${this.apiRoot}/get`;
    const params = new HttpParams()
      .set('foo', 'moo')
      .set('limit', '25');

    this.http.get(url, {params})
      .subscribe(response => console.log(response));
  }
```

To make the HTTP call as a Promise, we must use the **toPromise** operator and, instead of **subscribe()**, we call **then()** and **catch()** methods:
```
    const url = `${this.apiRoot}/post`;
    const params = new HttpParams()
      .set('foo', 'moo')
      .set('limit', '25');

    this.http.get(url, {params})
    .toPromise()
    .then(
      response => console.log(response))
      .catch(msg => console.error(`Error: ${msg.error} ${msg.statusText}`));
```

## Sendind the various types of http requests
## GET
```
const url = `${this.apiRoot}/get`;
    const params = new HttpParams()
      .set('foo', 'moo')
      .set('limit', '25');

    this.http.get(url, {params})
      .subscribe(response => console.log(response));
```

## POST
```
const url = `${this.apiRoot}/post`;
    const params = new HttpParams()
      .set('foo', 'moo')
      .set('limit', '25');

    this.http.post(url, {moo:'foo', goo:'loo'}, {params})
      .subscribe(response => console.log(response));
```

## PUT
```
const url = `${this.apiRoot}/put`;
    const params = new HttpParams()
      .set('foo', 'moo')
      .set('limit', '25');

    this.http.put(url, {moo:'foo', goo:'loo'}, {params})
      .subscribe(response => console.log(response));
```

## DELETE
```
const url = `${this.apiRoot}/delete`;
    const params = new HttpParams()
      .set('foo', 'moo')
      .set('limit', '25');

    this.http.delete(url, {params})
      .subscribe(response => console.log(response));
```
## Sending custom headers
We add HTTP Headers using the **HttpHeaders** helper class. It is passed as one of the arguments to the GET, POST, PUT, DELETE, PATCH & OPTIONS request.
To use HttpHeaders in your app, you must import it into your component or service. Then create an instance of the class:
```
const headers= new HttpHeaders()
  .set('content-type', 'application/json')
  .set('Access-Control-Allow-Origin', '*');
```

And then call the httpClient.get method passing the headers as the argument:
```
const url = `${this.apiRoot}/get`;
    const params = new HttpParams()
      .set('foo', 'moo')
      .set('limit', '25');
      const headers = new HttpHeaders()
        .set('content-type', 'application/json')
        .set('Access-Control-Allow-Origin', '*');

    this.http.get(url, {headers: headers})
      .subscribe(response => console.log(response));
```

### Summary
* We setup HTTP by adding **HttpModule** to our **NngModule.imports**
* Each HTTP verb has an associated function on the Http service.
* Requests return **Observables**.
* Handle HTTP errors via standard Observable or Promise error handlers.
* Send custom headers via an instance of **HttpHeaders**.

# HTTP with Promises

## CORS
To prevent attacks on websites, browsers restrict cross-origin HTTP requests from scripts. XMLHttpRequest and Fetch API follow the same-origin policy and can only process requests from the origin where the application was loaded.

## CORS in Angular
Here are the few steps needed to fix the CORS issues in Angular to ensure a smooth data transfer between client and server:

### Create a Proxy Config file
In your application, reate a proxy.config.json file in the src folder. Open the file and append the following code to allow all the /api/ requests to be redirected to the target hostname:
```
{
    "/api/*": {
        "target": "http://localhost:3000",
        "secure": false,
        "logLevel": "debug"
    }
}
```

### Append proxy config key
In your angular.json file, add the following key-value pairs in the “serve -> options” field that points it to your proxy.config.json file:
```
"architect": {
  "serve": {
    "builder": ""
    "options": {
      "proxyConfig": "src/proxy.conf.json"
    },
  }
}
```

### Run
Finally, you may run the dev server using:
```
ng serve
```
### Summary
* Create an *intermediate service* which has the reponsability of communicating with an API.
* We can implement a Http solution using Promises (synchronous code).
* **CORS** is an HTTP header- based mechanism that allows the server to indicate any other domain, scheme, 
  or port origins and enables them to be loaded.

# JSONP with Observables
**JSONP** is a method of performing API requests which go around the issue of CORS.

This is a security measure implemented in all browsers that stops you from using an API in a potentially unsolicited way and most APIs, including the iTunes API, are protected by it.

JSONP is a solution to this problem, it treats the API as if it was a JavaScript file. It dynamically adds
the HTTP request as if it were a script tag in our our HTML.
For instance:
```
https://itunes.apple.com/search?term=love&media=music&limit=20
```
it will be added as:
```
<script src="https://itunes.apple.com/search?term=love&media=music&limit=20"></script>
```
The browser then just downloads the JavaScript file and since browsers don’t check for CORS when downloading JavaScript files it a works around the issue of CORS.

That’s JSONP in a nutshell.
1. We treat the API as a JavaScript file.
2. The API wraps the JSON response in a function who’s name we define.
3. When the browser downloads the fake API script it runs it, it calls the function passing it the JSON data.

**We can only use JSONP when**:
1. The API itself **supports JSONP**. It needs to return the JSON response wrapped in a function and it usually lets us pass in the function name we want it to use as one of the query params.
2. **We can only use it for GET requests**, it doesn’t work for PUT/POST/DELETE and so on.

## How to make JSONP requests in Angular

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

## Handling errors



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

## Sending custom headers

## Handling errors



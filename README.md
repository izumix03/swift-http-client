# swift-http-client


```swift
let (data, response) = try await HttpClient("https://github.com")
  .get("/izumix03/swift-http-client")
  .execute()
```

```swift
let page = try await HttpClient("https://github.com")
  .get("/izumix03/swift-http-client")
  .decodeJsonResponse(Page.self)
```
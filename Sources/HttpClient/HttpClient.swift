import Foundation

public enum HttpClientError: Error {
  case connectionError(Data)
  case apiError(code: Int)
  case unauthorizedError
}

public protocol HttpClientConfigure {
  func get(_ path: String) -> HttpClientSetter
  func post(_ path: String) -> HttpClientSetter
  func put(_ path: String) -> HttpClientSetter
  func delete(_ path: String) -> HttpClientSetter
}

public protocol HttpClientSetter {
  func headers(_ headers: [String: String]) -> HttpClientBodySetter
  func dictToJson(_ body: [String: Any]) throws -> HttpClientHandler
  func decodeJsonResponse<T: Decodable>(_ cls: T.Type) async throws -> T
  func execute() async throws -> (data: Data, response: URLResponse)
}

public protocol HttpClientBodySetter {
  func dictToJson(_ body: [String: Any]) throws -> HttpClientHandler
  func decodeJsonResponse<T: Decodable>(_ cls: T.Type) async throws -> T
  func execute() async throws -> (data: Data, response: URLResponse)
}

public protocol HttpClientHandler {
  func decodeJsonResponse<T: Decodable>(_ cls: T.Type) async throws -> T
  func execute() async throws -> (data: Data, response: URLResponse)
}

open class HttpClient:
  HttpClientConfigure,
  HttpClientSetter,
  HttpClientHandler,
  HttpClientBodySetter
{
  public init(_ _url: String) {
    url = URL(string: _url)!
  }

  public func get(_ path: String) -> HttpClientSetter {
    url = url.appendingPathComponent(path)
    method = .GET
    return self
  }

  public func post(_ path: String) -> HttpClientSetter {
    url = url.appendingPathComponent(path)
    method = .POST
    return self
  }

  public func put(_ path: String) -> HttpClientSetter {
    url = url.appendingPathComponent(path)
    method = .PUT
    return self
  }

  public func delete(_ path: String) -> HttpClientSetter {
    url = url.appendingPathComponent(path)
    method = .DELETE
    return self
  }

  public func headers(_ headers: [String: String]) -> HttpClientBodySetter {
    self.headers = headers
    return self
  }

  public func structToJson<T: Codable>(_ body: T) throws -> HttpClientHandler {
    let jsonValue = try JSONEncoder().encode(body)
    self.body = jsonValue
    isJson = true
    return self
  }

  public func dictToJson(_ body: [String: Any]) throws -> HttpClientHandler {
    self.body = try JSONSerialization.data(withJSONObject: body)
    isJson = true
    return self
  }

  public func decodeJsonResponse<T: Decodable>(_ cls: T.Type) async throws -> T {
    let (data, _) = try await execute()

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return try decoder.decode(T.self, from: data)
  }

  @discardableResult
  public func execute() async throws -> (data: Data, response: URLResponse) {
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    if isJson {
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    request.allHTTPHeaderFields = headers

    let (data, response) = try await handleExecute(request)
    try validate(data, response)
    return (data, response)
  }

  ///MARK:- private
  private static let session: URLSession = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 30
    configuration.timeoutIntervalForResource = 30
    return URLSession(configuration: configuration)
  }()

  private var url: URL
  private var method: Method = .GET
  private var body: Data?
  private var isJson: Bool = false
  private var headers: [String: String] = [:]

  private func validate(_ data: Data, _ response: URLResponse) throws {
    guard let code = (response as? HTTPURLResponse)?.statusCode else {
      throw HttpClientError.connectionError(data)
    }

    if code == 401 {
      throw HttpClientError.unauthorizedError
    }

    guard (200..<300).contains(code) else {
      throw HttpClientError.apiError(code: code)
    }
  }

  private func handleExecute(_ request: URLRequest) async throws -> (
    Data, URLResponse
  ) {
    switch method {
    case .GET, .DELETE:
      return try await HttpClient.session.data(for: request)
    case .POST, .PUT:
      return try await HttpClient.session.upload(for: request, from: body ?? Data())
    }
  }
}

//MARK:- internal

enum Method: String {
  case GET
  case POST
  case PUT
  case DELETE
}

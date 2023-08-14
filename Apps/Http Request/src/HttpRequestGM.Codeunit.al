/// <summary>
/// Represents Http Request.
/// </summary>
codeunit 88000 "Http Request GM"
{
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;


    /// <summary>
    /// Configures the HTTP request URI to the provided <paramref name="RequestUri"/>.
    /// </summary>
    /// <param name="RequestUri">The URI for the request to be set.</param>
    procedure SetUri(RequestUri: Text)
    begin
        HttpRequestMessage.SetRequestUri(RequestUri);
    end;

    /// <summary>
    /// Configures the HTTP request method to the provided <paramref name="HttpMethod"/>.
    /// </summary>
    /// <param name="HttpMethod">The HTTP method to set.</param>
    procedure SetHttpMethod(HttpMethodGM: Enum "Http Method GM")
    begin
        HttpRequestMessage.Method(GetRequestMethodAsText(HttpMethodGM));
    end;

    /// <summary>
    /// Appends the provided <paramref name="RequestHeaders"/> to the HTTP request.
    /// </summary>
    /// <param name="RequestHeaders">HTTP request headers to include.</param>
    procedure SetHeaders(RequestHeaders: Dictionary of [Text, Text])
    var
        HttpHeaders: HttpHeaders;
        Headers: List of [Text];
        Header: Text;
    begin
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Clear();
        Headers := RequestHeaders.Keys();
        foreach Header in Headers do
            AddHeader(HttpHeaders, Header, RequestHeaders.Get(Header));
    end;

    /// <summary>
    /// Configures the request body with the provided <paramref name="RequestBody"/>.
    /// </summary>
    /// <param name="RequestBody">The content to set as the request body.</param>
    procedure SetBody(RequestBody: Text)
    var
        HttpContent: HttpContent;
    begin
        HttpContent.WriteFrom(RequestBody);
        HttpRequestMessage.Content(HttpContent);
    end;

    local procedure GetRequestMethodAsText(HttpMethodGM: Enum "Http Method GM"): Text
    var
        Index: Integer;
    begin
        Index := HttpMethodGM.Ordinals().IndexOf(HttpMethodGM.AsInteger());
        exit(HttpMethodGM.Names().Get(Index));
    end;

    local procedure AddHeader(var HttpHeaders: HttpHeaders; HeaderName: Text; HeaderValue: Text)
    begin
        if HttpHeaders.Contains(HeaderName) then
            HttpHeaders.Remove(HeaderName);

        HttpHeaders.Add(HeaderName, HeaderValue);
    end;
}
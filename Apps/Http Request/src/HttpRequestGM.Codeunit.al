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
    procedure SetRequestUri(RequestUri: Text)
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

    local procedure GetRequestMethodAsText(HttpMethodGM: Enum "Http Method GM"): Text
    var
        Index: Integer;
    begin
        Index := HttpMethodGM.Ordinals().IndexOf(HttpMethodGM.AsInteger());
        exit(HttpMethodGM.Names().Get(Index));
    end;
}
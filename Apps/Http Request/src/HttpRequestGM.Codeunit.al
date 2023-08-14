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
    [NonDebuggable]
    procedure SetRequestUri(RequestUri: Text)
    begin
        HttpRequestMessage.SetRequestUri(RequestUri);
    end;
    
}
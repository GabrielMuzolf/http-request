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

    /// <summary>
    /// Appends the provided <paramref name="ContentHeaders"/> to the HTTP content.
    /// </summary>
    /// <param name="ContentHeaders">HTTP content headers to include.</param>
    procedure SetContentHeaders(ContentHeaders: Dictionary of [Text, Text])
    var
        HttpHeaders: HttpHeaders;
        HttpContent: HttpContent;
        Headers: List of [Text];
        Header: Text;
    begin
        HttpContent := HttpRequestMessage.Content();
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Clear();
        Headers := ContentHeaders.Keys();
        foreach Header in Headers do
            AddHeader(HttpHeaders, Header, ContentHeaders.Get(Header));

        HttpRequestMessage.Content(HttpContent);
    end;

    /// <summary>
    /// Sends the configured HTTP request.
    /// </summary>
    procedure Send(): Boolean
    begin
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then;
        ErrorIfRequestBlockedByEnvironment();
    end;

    /// <summary>
    /// Determines if the response indicates a successful status.
    /// </summary>
    /// <returns>True if the response indicates success; otherwise, false.</returns>
    procedure IsSuccessStatusCode(): Boolean
    begin
        exit(HttpResponseMessage.IsSuccessStatusCode());
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

    local procedure ErrorIfRequestBlockedByEnvironment()
    var
        ModuleInfo: ModuleInfo;
        RequestBlockedByEnviromentErr: Label 'Execution of requests for the application ''%1'' is blocked. Please unlock requests in the extension management.', Comment = '%1 = Application Name';
    begin
        if not HttpResponseMessage.IsBlockedByEnvironment() then
            exit;

        NavApp.GetCurrentModuleInfo(ModuleInfo);
        Error(RequestBlockedByEnviromentErr, ModuleInfo.Name());
    end;
}
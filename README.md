# http-request
A comprehensive toolkit for streamlined HTTP requests. Simplify API integration with organized functions for sending and receiving HTTP requests effectively.
```
    procedure SpotifyTokenRequestDemo()
    var
        Base64Convert: Codeunit "Base64 Convert";
        HttpRequestGM: Codeunit "Http Request GM";
        ContentHeaders: Dictionary of [Text, Text];
        RequestHeaders: Dictionary of [Text, Text];
        Response: JsonObject;
    begin
        HttpRequestGM.SetUri('https://accounts.spotify.com/api/token');
        HttpRequestGM.SetHttpMethod("Http Method GM"::POST);
        HttpRequestGM.SetBody('grant_type=client_credentials');

        ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
        HttpRequestGM.SetContentHeaders(ContentHeaders);

        RequestHeaders.Add('Authorization', 'Basic ' + Base64Convert.ToBase64('your_client_id:your_client_secret'));
        HttpRequestGM.SetHeaders(RequestHeaders);

        if not HttpRequestGM.Send() then
            Error(HttpRequestGM.GetFailedTxt());

        Response.ReadFrom(HttpRequestGM.GetResponseBody());
    end;
```

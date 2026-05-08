codeunit 50101 "WA Msg Sender"
{
    procedure SendInvoiceNotification(var SalesInvHeader: Record "Sales Invoice Header")
    var
        Customer: Record Customer;
        Setup: Record "WA Msg Setup";
        Phone: Text;
        MessageBody: Text;
        WaUrl: Text;
        CurrDisplay: Text;
    begin
        Setup := Setup.GetSetup();

        if not Setup.Enabled then
            exit;

        if not Customer.Get(SalesInvHeader."Sell-to Customer No.") then
            exit;

        Phone := CleanPhoneNumber(Customer."Phone No.");
        if Phone = '' then begin
            Message('WhatsApp: Customer %1 has no Phone No. on their card.', SalesInvHeader."Sell-to Customer Name");
            exit;
        end;
        SalesInvHeader.CalcFields("Amount Including VAT");
        if SalesInvHeader."Currency Code" = '' then
            CurrDisplay := 'LCY'
        else
            CurrDisplay := SalesInvHeader."Currency Code";

        MessageBody := Setup."Message Template";
        MessageBody := MessageBody.Replace('{name}', SalesInvHeader."Sell-to Customer Name");
        MessageBody := MessageBody.Replace('{invoice}', SalesInvHeader."No.");
        MessageBody := MessageBody.Replace('{amount}', Format(SalesInvHeader."Amount Including VAT", 0, '<Precision,2:2><Standard Format,0>'));
        MessageBody := MessageBody.Replace('{currency}', CurrDisplay);
        MessageBody := MessageBody.Replace('{duedate}', Format(SalesInvHeader."Due Date", 0, '<Day,2>/<Month,2>/<Year4>'));

        // Build the wa.me URL — no API needed, opens WhatsApp Web in browser
        WaUrl := 'https://wa.me/' + Phone + '?text=' + UrlEncode(MessageBody);

        Hyperlink(WaUrl);
    end;

    local procedure CleanPhoneNumber(RawPhone: Text): Text
    var
        Cleaned: Text;
        i: Integer;
        Ch: Char;
    begin
        // Remove spaces, dashes, brackets, + signs — keep digits only
        for i := 1 to StrLen(RawPhone) do begin
            Ch := RawPhone[i];
            if (Ch >= '0') and (Ch <= '9') then
                Cleaned += Format(Ch);
        end;
        exit(Cleaned);
    end;

    local procedure UrlEncode(InputText: Text): Text
    var
        Result: Text;
        i: Integer;
        Ch: Char;
    begin
        for i := 1 to StrLen(InputText) do begin
            Ch := InputText[i];
            case Ch of
                ' ':
                    Result += '%20';
                '!':
                    Result += '%21';
                '#':
                    Result += '%23';
                '$':
                    Result += '%24';
                '&':
                    Result += '%26';
                '''':
                    Result += '%27';
                '(':
                    Result += '%28';
                ')':
                    Result += '%29';
                '*':
                    Result += '%2A';
                '+':
                    Result += '%2B';
                ',':
                    Result += '%2C';
                '/':
                    Result += '%2F';
                ':':
                    Result += '%3A';
                ';':
                    Result += '%3B';
                '=':
                    Result += '%3D';
                '?':
                    Result += '%3F';
                '@':
                    Result += '%40';
                '[':
                    Result += '%5B';
                ']':
                    Result += '%5D';
                '%':
                    Result += '%25';
                else
                    Result += Format(Ch);
            end;
        end;
        exit(Result);
    end;
}

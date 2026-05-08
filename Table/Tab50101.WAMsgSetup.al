table 50101 "WA Msg Setup"
{
    Caption = 'WhatsApp Message Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; Enabled; Boolean)
        {
            Caption = 'Enabled';
            ToolTip = 'Enable WhatsApp message prompt when posting a sales invoice.';
        }
        field(3; "Message Template"; Text[500])
        {
            Caption = 'Message Template';
            ToolTip = 'Placeholders: {name} {invoice} {amount} {currency} {duedate}';
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }

    procedure GetSetup(): Record "WA Msg Setup"
    var
        Setup: Record "WA Msg Setup";
    begin
        if not Setup.Get('') then begin
            Setup.Init();
            Setup."Primary Key" := '';
            Setup.Enabled := true;
            Setup."Message Template" := 'Dear {name}, your Invoice {invoice} for {currency} {amount} has been posted. Due date: {duedate}. Thank you!';
            Setup.Insert();
        end;
        exit(Setup);
    end;
}

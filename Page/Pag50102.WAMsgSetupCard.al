page 50102 "WA Msg Setup Card"
{
    Caption = 'WhatsApp Message Setup';
    PageType = Card;
    SourceTable = "WA Msg Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Settings)
            {
                Caption = 'Settings';

                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'When enabled, WhatsApp Web opens automatically after posting a sales invoice.';
                }
                field("Message Template"; Rec."Message Template")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Placeholders: {name} {invoice} {amount} {currency} {duedate}';
                }
            }
            group(HowItWorks)
            {
                Caption = 'How It Works';
                field(Info1; 'No API key needed. Uses the free wa.me WhatsApp link.')
                {
                    ApplicationArea = All;
                    Caption = ' ';
                    Editable = false;
                }
                field(Info2; 'When you post an invoice, WhatsApp Web opens in your browser.')
                {
                    ApplicationArea = All;
                    Caption = ' ';
                    Editable = false;
                }
                field(Info3; 'The message is pre-filled. You only need to click Send.')
                {
                    ApplicationArea = All;
                    Caption = ' ';
                    Editable = false;
                }
                field(Info4; 'Make sure the customer has a Phone No. on their Customer card.')
                {
                    ApplicationArea = All;
                    Caption = ' ';
                    Editable = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        Setup: Record "WA Msg Setup";
    begin
        if not Rec.Get('') then begin
            Setup.GetSetup();
            Rec.Get('');
        end;
    end;
}

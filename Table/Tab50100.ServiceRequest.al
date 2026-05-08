table 50100 "Service Request"
{
    Caption = 'Service Request';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Vehicle Registration"; Code[20])
        {
            Caption = 'Vehicle Registration';
        }
        field(3; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(4; "Service Type"; Option)
        {
            Caption = 'Service Type';
            OptionMembers = "Oil Change","Tire Rotation","Engine Repair","Body Work",Other;
            OptionCaption = 'Oil Change,Tire Rotation,Engine Repair,Body Work,Other';
        }
        field(5; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Open,"In Progress",Completed,Cancelled;
            OptionCaption = 'Open,In Progress,Completed,Cancelled';
        }
        field(6; "Request Date"; Date)
        {
            Caption = 'Request Date';
        }
        field(7; "Completion Date"; Date)
        {
            Caption = 'Completion Date';
        }
        field(8; Technician; Text[50])
        {
            Caption = 'Technician';
        }
        field(9; Notes; Text[250])
        {
            Caption = 'Notes';
        }
        field(10; "Estimated Cost"; Decimal)
        {
            Caption = 'Estimated Cost';
            MinValue = 0;
        }
        field(11; "Actual Cost"; Decimal)
        {
            Caption = 'Actual Cost';
            MinValue = 0;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(ByStatus; Status, "Request Date") { }
    }

    trigger OnInsert()
    begin
        if "Request Date" = 0D then
            "Request Date" := Today();
    end;
}

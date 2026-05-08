page 50101 "Service Request Card"
{
    Caption = 'Service Request';
    PageType = Card;
    SourceTable = "Service Request";
    UsageCategory = None;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique request number.';
                }
                field("Vehicle Registration"; Rec."Vehicle Registration")
                {
                    ApplicationArea = All;
                    ToolTip = 'The vehicle licence plate or registration code.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the customer who owns the vehicle.';
                }
                field("Service Type"; Rec."Service Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Type of service being performed.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Current status of the service request.';
                }
            }
            group(Scheduling)
            {
                Caption = 'Scheduling';

                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date the request was created.';
                }
                field("Completion Date"; Rec."Completion Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date the service was completed.';
                    Editable = Rec.Status = Rec.Status::Completed;
                }
                field(Technician; Rec.Technician)
                {
                    ApplicationArea = All;
                    ToolTip = 'Technician assigned to this request.';
                }
            }
            group(Costs)
            {
                Caption = 'Costs';

                field("Estimated Cost"; Rec."Estimated Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Estimated cost of the service.';
                }
                field("Actual Cost"; Rec."Actual Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Actual cost charged to the customer.';
                }
            }
            group(AdditionalInfo)
            {
                Caption = 'Notes';

                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Additional notes about this service request.';
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Links; Links) { ApplicationArea = All; }
            systempart(Notes; Notes) { ApplicationArea = All; }
        }
    }

    actions
    {
        area(Processing)
        {
            action(StartService)
            {
                Caption = 'Start Service';
                Image = Start;
                ApplicationArea = All;
                ToolTip = 'Change status to In Progress.';
                Enabled = Rec.Status = Rec.Status::Open;
                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::"In Progress";
                    Rec.Modify(true);
                    CurrPage.Update();
                    Message('Service started for vehicle %1.', Rec."Vehicle Registration");
                end;
            }
            action(CompleteService)
            {
                Caption = 'Complete Service';
                Image = Approve;
                ApplicationArea = All;
                ToolTip = 'Mark this request as completed.';
                Enabled = Rec.Status = Rec.Status::"In Progress";
                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Completed;
                    Rec."Completion Date" := Today();
                    Rec.Modify(true);
                    CurrPage.Update();
                    Message('Service for vehicle %1 marked as Completed.', Rec."Vehicle Registration");
                end;
            }
            action(CancelRequest)
            {
                Caption = 'Cancel Request';
                Image = Cancel;
                ApplicationArea = All;
                ToolTip = 'Cancel this service request.';
                Enabled = Rec.Status <> Rec.Status::Completed;
                trigger OnAction()
                begin
                    if Confirm('Cancel request %1?', false, Rec."No.") then begin
                        Rec.Status := Rec.Status::Cancelled;
                        Rec.Modify(true);
                        CurrPage.Update();
                    end;
                end;
            }
        }
    }
}

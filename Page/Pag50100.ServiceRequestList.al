page 50100 "Service Request List"
{
    Caption = 'Service Requests';
    PageType = List;
    SourceTable = "Service Request";
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = "Service Request Card";

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
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
                    StyleExpr = StatusStyle;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date the request was created.';
                }
                field(Technician; Rec.Technician)
                {
                    ApplicationArea = All;
                    ToolTip = 'Technician assigned to this request.';
                }
                field("Estimated Cost"; Rec."Estimated Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Estimated cost of the service.';
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
            action(NewRequest)
            {
                Caption = 'New Request';
                Image = New;
                ApplicationArea = All;
                RunObject = page "Service Request Card";
                RunPageMode = Create;
                ToolTip = 'Create a new service request.';
            }
            action(MarkCompleted)
            {
                Caption = 'Mark as Completed';
                Image = Approve;
                ApplicationArea = All;
                ToolTip = 'Mark the selected request as completed.';
                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Completed;
                    Rec."Completion Date" := Today();
                    Rec.Modify(true);
                    Message('Request %1 marked as Completed.', Rec."No.");
                end;
            }
        }
    }

    var
        StatusStyle: Text;

    trigger OnAfterGetRecord()
    begin
        case Rec.Status of
            Rec.Status::Open:
                StatusStyle := 'Favorable';
            Rec.Status::"In Progress":
                StatusStyle := 'Ambiguous';
            Rec.Status::Completed:
                StatusStyle := 'Strong';
            Rec.Status::Cancelled:
                StatusStyle := 'Unfavorable';
        end;
    end;
}

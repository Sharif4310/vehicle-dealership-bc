page 50130 "Find FindSet Test Page"
{
    PageType = Card;
    Caption = 'FIND / FINDSET Lesson Runner';
    UsageCategory = Tasks;
    ApplicationArea = All;

    actions
    {
        area(Processing)
        {
            group(Lessons)
            {
                Caption = 'Run Lessons';

                action(Lesson1)
                {
                    Caption = 'L1 — FIND(=) Exact Key';
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        Lesson: Codeunit "Find FindSet Lesson";
                    begin
                        Lesson.Lesson1_FindExact();
                    end;
                }
                action(Lesson2)
                {
                    Caption = 'L2 — FIND(-/+) First & Last';
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        Lesson: Codeunit "Find FindSet Lesson";
                    begin
                        Lesson.Lesson2_FindFirstAndLast();
                    end;
                }
                action(Lesson3)
                {
                    Caption = 'L3 — FIND(<>) Existence Check';
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        Lesson: Codeunit "Find FindSet Lesson";
                    begin
                        Lesson.Lesson3_FindAny();
                    end;
                }
                action(Lesson4)
                {
                    Caption = 'L4 — FINDSET Read Loop';
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        Lesson: Codeunit "Find FindSet Lesson";
                    begin
                        Lesson.Lesson4_FindSet_ReadOnly();
                    end;
                }
                action(Lesson5)
                {
                    Caption = 'L5 — FINDSET(true) Modify Loop';
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        Lesson: Codeunit "Find FindSet Lesson";
                    begin
                        Lesson.Lesson5_FindSet_WithModify();
                    end;
                }
                action(Lesson6)
                {
                    Caption = 'L6 — Header + Lines Filter';
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        Lesson: Codeunit "Find FindSet Lesson";
                    begin
                        Lesson.Lesson6_HeaderAndLines();
                    end;
                }
                action(Lesson7)
                {
                    Caption = 'L7 — SETFILTER Expressions';
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        Lesson: Codeunit "Find FindSet Lesson";
                    begin
                        Lesson.Lesson7_SetFilter_Expressions();
                    end;
                }
                action(Lesson8)
                {
                    Caption = 'L8 — Purchase Documents';
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        Lesson: Codeunit "Find FindSet Lesson";
                    begin
                        Lesson.Lesson8_PurchaseDocuments();
                    end;
                }
                action(Lesson9)
                {
                    Caption = 'L9 — Vehicle Custom Table';
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        Lesson: Codeunit "Find FindSet Lesson";
                    begin
                        Lesson.Lesson9_VehicleFilter();
                    end;
                }
                action(Lesson10)
                {
                    Caption = 'L10 — Summary: FIND vs FINDSET';
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        Lesson: Codeunit "Find FindSet Lesson";
                    begin
                        Lesson.Lesson10_FindVsFindSet_Summary();
                    end;
                }
            }
        }
    }
}

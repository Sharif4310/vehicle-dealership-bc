codeunit 50102 "WA Invoice Subscriber"
{
    // OnAfterFinalizePosting fires after ALL posting is done (header + lines + ledger entries)
    // This guarantees the amount fields are fully populated before we read them
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterFinalizePosting', '', false, false)]
    local procedure OnAfterFinalizeSalesPosting(
        var SalesHeader: Record "Sales Header";
        var SalesShipmentHeader: Record "Sales Shipment Header";
        var SalesInvoiceHeader: Record "Sales Invoice Header";
        var SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        var ReturnReceiptHeader: Record "Return Receipt Header";
        var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        CommitIsSuppressed: Boolean)
    var
        PostedInvoice: Record "Sales Invoice Header";
        Sender: Codeunit "WA Msg Sender";
    begin
        // Only proceed if this posting produced an invoice
        if SalesInvoiceHeader."No." = '' then
            exit;

        // Re-read the record fresh from DB so all fields are populated
        if not PostedInvoice.Get(SalesInvoiceHeader."No.") then
            exit;

        PostedInvoice.CalcFields("Amount Including VAT");

        Sender.SendInvoiceNotification(PostedInvoice);
    end;
}

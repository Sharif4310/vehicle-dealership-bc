// ============================================================
//  SELF-CODING LESSON: FIND, FINDSET & Document Filters in AL
//  Run each procedure from a test page action to see results.
// ============================================================
codeunit 50130 "Find FindSet Lesson"
{
    // ──────────────────────────────────────────────────────────
    //  THEORY CHEAT SHEET
    // ──────────────────────────────────────────────────────────
    //
    //  FIND('-')   → position on the FIRST record matching filters
    //  FIND('+')   → position on the LAST  record matching filters
    //  FIND('=')   → find record that EXACTLY matches the primary key
    //  FIND('<>')  → find ANY record (first or last, just checks existence)
    //  FINDSET     → like FIND('-') but optimised for looping with NEXT
    //  FINDSET(true) → FINDSET but locks rows so you can MODIFY inside loop
    //
    //  All FIND/FINDSET return TRUE if a record was found, FALSE if not.
    //  Always call them inside an IF or assign the result.
    //
    //  FILTER FUNCTIONS (applied BEFORE the find):
    //    rec.SETRANGE(Field, Value)              → exact match filter
    //    rec.SETRANGE(Field, FromValue, ToValue) → range filter
    //    rec.SETFILTER(Field, 'expression')      → expression filter
    //    rec.RESET                               → clear ALL filters
    // ──────────────────────────────────────────────────────────

    // ══════════════════════════════════════════════════════════
    //  LESSON 1 — FIND('=') : find ONE specific record by key
    // ══════════════════════════════════════════════════════════
    procedure Lesson1_FindExact()
    var
        Customer: Record Customer;
        Msg: Text;
    begin
        // Step 1: assign the primary key value
        Customer."No." := '10000'; // change to a real customer no. in your BC

        // Step 2: FIND('=') looks for the exact primary-key match
        if Customer.Find('=') then
            Msg := 'Found customer: ' + Customer.Name
        else
            Msg := 'Customer 10000 does not exist';

        Message(Msg);

        // ----- EXERCISE -----
        // 1. Change '10000' to a customer number that exists in your BC.
        // 2. Change it to a number that does NOT exist and observe the message.
        // 3. Try with the Item table instead of Customer.
    end;

    // ══════════════════════════════════════════════════════════
    //  LESSON 2 — FIND('-') and FIND('+') : first and last record
    // ══════════════════════════════════════════════════════════
    procedure Lesson2_FindFirstAndLast()
    var
        Customer: Record Customer;
    begin
        // FIND('-') → first customer (sorted by primary key)
        if Customer.Find('-') then
            Message('First Customer: %1  Name: %2', Customer."No.", Customer.Name);

        // FIND('+') → last customer
        if Customer.Find('+') then
            Message('Last Customer: %1  Name: %2', Customer."No.", Customer.Name);

        // ----- EXERCISE -----
        // 1. Add SETRANGE(Blocked, Blocked::" ") before FIND('-') to find
        //    the first NON-blocked customer.
        // 2. Try on the Item table: find first and last item.
    end;

    // ══════════════════════════════════════════════════════════
    //  LESSON 3 — FIND('<>') : check if ANY record exists
    // ══════════════════════════════════════════════════════════
    procedure Lesson3_FindAny()
    var
        SalesHeader: Record "Sales Header";
    begin
        // Filter to open sales orders only
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(Status, SalesHeader.Status::Open);

        // FIND('<>') just checks existence — fastest when you don't need data
        if SalesHeader.Find('-') then
            Message('There ARE open sales orders in the system.')
        else
            Message('No open sales orders found.');

        // ----- EXERCISE -----
        // 1. Change Document Type to Invoice and run again.
        // 2. Add a SETRANGE on "Sell-to Customer No." to check for a specific customer.
        // 3. Replace FIND('<>') with FIND('-') — what extra information can you now read?
    end;

    // ══════════════════════════════════════════════════════════
    //  LESSON 4 — FINDSET : loop through multiple records
    // ══════════════════════════════════════════════════════════
    procedure Lesson4_FindSet_ReadOnly()
    var
        SalesLine: Record "Sales Line";
        TotalQty: Decimal;
        LineCount: Integer;
    begin
        // Document filter: lines belonging to one specific order
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", 'S-ORD-0001'); // change to a real order no.
        SalesLine.SetRange(Type, SalesLine.Type::Item);

        // FINDSET positions on first record AND prepares an efficient server cursor
        if SalesLine.FindSet() then begin
            repeat
                TotalQty += SalesLine.Quantity;
                LineCount += 1;
            until SalesLine.Next() = 0;  // NEXT returns 0 when no more records

            Message('Order lines: %1\nTotal Qty: %2', LineCount, TotalQty);
        end else
            Message('No item lines found for this order.');

        // ----- EXERCISE -----
        // 1. Remove the "Document No." filter to sum ALL open order lines.
        // 2. Add another SETRANGE on "No." to count lines for one specific item.
        // 3. Print each line's item number and quantity inside the loop with Message.
        //    (Use a Text variable and build it up; call Message once after the loop.)
    end;

    // ══════════════════════════════════════════════════════════
    //  LESSON 5 — FINDSET(true) : loop with MODIFY
    // ══════════════════════════════════════════════════════════
    procedure Lesson5_FindSet_WithModify()
    var
        SalesLine: Record "Sales Line";
        LinesUpdated: Integer;
    begin
        // WARNING: this actually writes to the database.
        // Only run against a SANDBOX / test environment.

        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", 'S-ORD-0001'); // change to a real order
        SalesLine.SetRange(Type, SalesLine.Type::Item);

        // FINDSET(true) = FINDSET with a row-lock so MODIFY is allowed
        if SalesLine.FindSet(true) then begin
            repeat
                // Example: stamp a description note on every line
                SalesLine."Description 2" := 'Reviewed on ' + Format(Today());
                SalesLine.Modify(); // save the change for THIS row
                LinesUpdated += 1;
            until SalesLine.Next() = 0;

            Message('%1 lines updated.', LinesUpdated);
        end;

        // ----- EXERCISE -----
        // 1. Change "Description 2" to something meaningful for your data.
        // 2. Add an IF inside the loop so only lines with Quantity > 5 get modified.
        // 3. Wrap everything in a COMMIT after the loop (careful: this is final).
    end;

    // ══════════════════════════════════════════════════════════
    //  LESSON 6 — Document filters: Header + Lines together
    // ══════════════════════════════════════════════════════════
    procedure Lesson6_HeaderAndLines()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        TotalAmount: Decimal;
        OrderInfo: Text;
    begin
        // ---- Step A: find orders for a specific customer ----
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(Status, SalesHeader.Status::Open);
        SalesHeader.SetRange("Sell-to Customer No.", 'C00010'); // change to real customer

        if SalesHeader.FindSet() then begin
            repeat
                // ---- Step B: for each header, find its item lines ----
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                SalesLine.SetRange("Document No.", SalesHeader."No."); // key link
                SalesLine.SetRange(Type, SalesLine.Type::Item);

                TotalAmount := 0;
                if SalesLine.FindSet() then
                    repeat
                        TotalAmount += SalesLine."Line Amount";
                    until SalesLine.Next() = 0;

                OrderInfo += SalesHeader."No." + '  →  ' + Format(TotalAmount) + '\';
            until SalesHeader.Next() = 0;

            Message('Open orders for customer:\n%1', OrderInfo);
        end else
            Message('No open orders found for this customer.');

        // ----- EXERCISE -----
        // 1. Change customer number to one that has open orders in your BC.
        // 2. Add a SETRANGE on SalesLine."No." to filter for a specific item number.
        // 3. Change Status filter to Released to see released orders.
        // 4. Replace Message with a list of order numbers only (no amounts).
    end;

    // ══════════════════════════════════════════════════════════
    //  LESSON 7 — SETFILTER with expressions (>, <, |, ..)
    // ══════════════════════════════════════════════════════════
    procedure Lesson7_SetFilter_Expressions()
    var
        Item: Record Item;
        ItemCount: Integer;
    begin
        Item.Reset(); // always reset before applying new filters

        // Filter items with unit price between 100 and 500
        Item.SetFilter("Unit Price", '%1..%2', 100, 500);

        // AND also filter out blocked items
        Item.SetRange(Blocked, false);

        if Item.FindSet() then begin
            repeat
                ItemCount += 1;
            until Item.Next() = 0;
            Message('Items priced 100–500 (not blocked): %1', ItemCount);
        end;

        // ---- more SETFILTER examples ----
        Item.Reset();
        Item.SetFilter("Unit Price", '>%1', 1000);          // price > 1000
        Item.SetFilter("Item Category Code", 'VEHICLE|PART'); // two categories
        Message('Expensive vehicles/parts: %1', Item.Count());

        // ----- EXERCISE -----
        // 1. Filter items with "Inventory" > 0 (use SETFILTER).
        // 2. Use '..' notation: SetFilter("No.", 'V001..V099') to get a range of nos.
        // 3. Combine with FindSet and print each item's No. and Description.
    end;

    // ══════════════════════════════════════════════════════════
    //  LESSON 8 — Purchase documents (same pattern, different table)
    // ══════════════════════════════════════════════════════════
    procedure Lesson8_PurchaseDocuments()
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        TotalCost: Decimal;
    begin
        // Find all open purchase orders (not yet received)
        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.SetRange(Status, PurchHeader.Status::Open);

        if PurchHeader.FindSet() then
            repeat
                PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                PurchLine.SetRange("Document No.", PurchHeader."No.");

                if PurchLine.FindSet() then
                    repeat
                        TotalCost += PurchLine."Line Amount";
                    until PurchLine.Next() = 0;
            until PurchHeader.Next() = 0;

        Message('Total open purchase order value: %1', TotalCost);

        // ----- EXERCISE -----
        // 1. Add SETRANGE("Buy-from Vendor No.", 'V00001') to filter by vendor.
        // 2. Count how many distinct purchase orders exist (increment a counter per header).
        // 3. Find only RELEASED purchase orders and compare the total.
    end;

    // ══════════════════════════════════════════════════════════
    //  LESSON 9 — Vehicle table (your own custom table)
    //  Adapt field names to match your actual vehicle table.
    // ══════════════════════════════════════════════════════════
    procedure Lesson9_VehicleFilter()
    // var
    //     Vehicle: Record "Vehicle";         // uncomment when your table exists
    //     Count: Integer;
    begin
        // Uncomment and adapt when your Vehicle table is ready:
        //
        // Vehicle.SetRange(Status, Vehicle.Status::Available);
        // Vehicle.SetFilter("Sale Price", '>%1', 20000);
        //
        // if Vehicle.FindSet() then begin
        //     repeat
        //         Count += 1;
        //         // process each available vehicle over $20,000
        //     until Vehicle.Next() = 0;
        //     Message('Available vehicles over 20,000: %1', Count);
        // end;

        Message('Lesson 9: Uncomment the Vehicle code above once your table is in place.');
    end;

    // ══════════════════════════════════════════════════════════
    //  LESSON 10 — FIND vs FINDSET — when to use which
    // ══════════════════════════════════════════════════════════
    procedure Lesson10_FindVsFindSet_Summary()
    begin
        Message(
            'FIND vs FINDSET — Quick Rules:\n\n' +
            'FIND(''='')  → you know the KEY and need ONE record\n' +
            'FIND(''-'')  → you need the FIRST record (no loop needed)\n' +
            'FIND(''+'')  → you need the LAST  record (no loop needed)\n' +
            'FIND(''<>'') → you only need to know IF any record EXISTS\n' +
            'FINDSET     → you need to LOOP through multiple records (read)\n' +
            'FINDSET(true) → loop through records AND call MODIFY inside\n\n' +
            'Rule: use FINDSET for loops, FIND for single-record lookups.\n' +
            'Rule: always RESET or SETRANGE before reusing a record variable.'
        );
    end;
}

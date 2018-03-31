# Bagels
>Ticket management platform for delivery drivers.

# Problem

Daniel is a driver for Yuval's Bagels, a delivery service providing Calgarians with fresh, gourmet bagels (gluten-free). Daniel fills-out a paper ticket for each order, recording events as they happen (start, pickup, delivery, stop); upon ticket completion, he records the number of hours worked. Daniel sends his tickets to Yuval's Bagels corporate office in Australia, via mail, and is paid within 14 days of receipt.

Daniel needs to get paid faster; therefore, he wants the ability to create his tickets/events digitally, and send them via SMS to Yuval's Bagels corporate office.

# Feature

A ticket is a digital document that has many events, which represent the execution of an order. Events can by of type start, pickup, delivery, or stop, and an event can record an arbitrary measurement. The simplified event sequence is as follows:
Start
Pickup, with measurement of bagels picked-up
Delivery, with measurement of bagels delivered
Stop, with measurement of hours worked
Tickets have two statuses: active and completed. Once a stop event is created, its ticket should change from active to completed, and record a completion timestamp. The corporate office should be notified by SMS.

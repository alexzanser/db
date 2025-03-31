WITH BookingStats AS (
    SELECT 
        b.ID_customer,
        c.name,
        COUNT(b.ID_booking) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS unique_hotels,
        SUM(r.price * (b.check_out_date - b.check_in_date)) AS total_spent
    FROM Booking b
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    JOIN Customer c ON b.ID_customer = c.ID_customer
    GROUP BY b.ID_customer, c.name
)
SELECT 
    ID_customer,
    name,
    total_bookings,
    total_spent,
    unique_hotels
FROM BookingStats
WHERE total_bookings > 2 
    AND unique_hotels > 1 
    AND total_spent > 500
ORDER BY total_spent ASC;


WITH BookingStats AS (
    SELECT 
        b.ID_customer,
        COUNT(b.ID_booking) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS unique_hotels,
        STRING_AGG(DISTINCT h.name, ', ') AS hotel_list,
        AVG(b.check_out_date - b.check_in_date) AS avg_stay_duration
    FROM Booking b
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY b.ID_customer
)
SELECT 
    c.ID_customer,
    c.name,
    c.email,
    c.phone,
    bs.total_bookings,
    bs.hotel_list,
    ROUND(bs.avg_stay_duration, 2) AS avg_stay_duration
FROM BookingStats bs
JOIN Customer c ON bs.ID_customer = c.ID_customer
WHERE bs.total_bookings > 2 AND bs.unique_hotels > 1
ORDER BY bs.total_bookings DESC;


CREATE DATABASE online_aggregator;
USE online_aggregator;

-- 1. Create Hotel Inventory Table
-- Re-structuring the table to support Day-of-Week (DOW) variations
CREATE TABLE hotel_inventory (
    hotel_id VARCHAR(50) PRIMARY KEY,
    hotel_name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    room_type VARCHAR(50),
    base_price_weekday DECIMAL(10,2) NOT NULL, -- Core Monday-Thursday pricing
    weekend_premium_pct DECIMAL(4,2) DEFAULT 0.15, -- 0.15 represents a 15% surge
    available_rooms INT CHECK (available_rooms >= 0),
    data_source_provider VARCHAR(100), -- Explicit trace marker
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Retrieve table structure
SELECT * FROM hotel_inventory;



-- Populate
INSERT INTO Hotel_Inventory 
(hotel_id, hotel_name, city, room_type, base_price_weekday, weekend_premium_pct, available_rooms, data_source_provider, last_updated) 
VALUES
('HTL-MUM-01', 'Taj Mahal Palace', 'Mumbai', 'Suite', 32000.00, 0.20, 3, 'Amadeus Enterprise GDS', '2026-06-29 10:15:00'),
('HTL-MUM-02', 'The Oberoi', 'Mumbai', 'Deluxe', 18500.00, 0.15, 14, 'Booking.com B2B Partner Feed', '2026-06-29 11:30:00'),
('HTL-DEL-01', 'The Leela Palace', 'Delhi', 'Suite', 28000.00, 0.20, 2, 'Expedia Partner Solutions API', '2026-06-29 09:00:00'),
('HTL-BLR-01', 'ITC Gardenia', 'Bengaluru', 'Standard', 9500.00, 0.10, 45, 'Amadeus Enterprise GDS', '2026-06-29 12:00:00'),
('HTL-MUM-03', 'Trident Nariman Point', 'Mumbai', 'Suite', 22000.00, 0.18, 0, 'Sabre Distribution Network', '2026-06-29 13:45:00');


-- Retrieve table structure
SELECT * FROM hotel_inventory 
WHERE available_rooms <  10




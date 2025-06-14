CREATE DATABASE Global_logistics_system;
USE Global_logistics_system;

CREATE TABLE Clients (
    client_id INT PRIMARY KEY,
    name VARCHAR(100),
    address TEXT
);

CREATE TABLE Carriers (
    carrier_id INT PRIMARY KEY,
    name VARCHAR(100),
    type ENUM('air', 'land', 'sea'),
    contact_info VARCHAR(100)
);

CREATE TABLE Warehouses (
    warehouse_id INT PRIMARY KEY,
    location VARCHAR(100),
    capacity INT
);

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    role VARCHAR(50),
    warehouse_id INT,
    carrier_id INT,
    CHECK ((warehouse_id IS NULL OR carrier_id IS NULL) AND NOT (warehouse_id IS NULL AND carrier_id IS NULL)),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id),
    FOREIGN KEY (carrier_id) REFERENCES Carriers(carrier_id)
);

CREATE TABLE Shipments (
    shipment_id INT PRIMARY KEY,
    origin VARCHAR(100),
    destination VARCHAR(100),
    weight DECIMAL(10,2),
    content_description TEXT,
    shipment_date DATE,
    sender_id INT,
    receiver_id INT,
    FOREIGN KEY (sender_id) REFERENCES Clients(client_id),
    FOREIGN KEY (receiver_id) REFERENCES Clients(client_id)
);

CREATE TABLE Shipment_Carriers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    shipment_id INT,
    carrier_id INT,
    leg_order INT,
    FOREIGN KEY (shipment_id) REFERENCES Shipments(shipment_id),
    FOREIGN KEY (carrier_id) REFERENCES Carriers(carrier_id)
);

CREATE TABLE Shipment_Warehouse_History (
    id INT PRIMARY KEY AUTO_INCREMENT,
    shipment_id INT,
    warehouse_id INT,
    stored_from DATETIME,
    stored_to DATETIME,
    FOREIGN KEY (shipment_id) REFERENCES Shipments(shipment_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id)
);

CREATE TABLE Customs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    shipment_id INT,
    country VARCHAR(100),
    clearance_date DATE,
    status VARCHAR(50),
    FOREIGN KEY (shipment_id) REFERENCES Shipments(shipment_id)
);

CREATE TABLE CrossDocking (
    id INT PRIMARY KEY AUTO_INCREMENT,
    shipment_id INT,
    source_warehouse INT,
    destination_warehouse INT,
    transfer_date DATE,
    FOREIGN KEY (shipment_id) REFERENCES Shipments(shipment_id),
    FOREIGN KEY (source_warehouse) REFERENCES Warehouses(warehouse_id),
    FOREIGN KEY (destination_warehouse) REFERENCES Warehouses(warehouse_id)
);

SELECT s.shipment_id, s.origin, s.destination, sc.leg_order
FROM Shipments s
JOIN Shipment_Carriers sc ON s.shipment_id = sc.shipment_id
WHERE sc.carrier_id = 101;

SELECT shipment_id, origin, destination, shipment_date
FROM Shipments
WHERE sender_id = 201 OR receiver_id = 201;

SELECT s.shipment_id, s.content_description, h.stored_from
FROM Shipments s
JOIN Shipment_Warehouse_History h ON s.shipment_id = h.shipment_id
WHERE h.warehouse_id = 301 AND h.stored_to IS NULL;

SELECT w.location, h.stored_from, h.stored_to
FROM Shipment_Warehouse_History h
JOIN Warehouses w ON h.warehouse_id = w.warehouse_id
WHERE h.shipment_id = 401
ORDER BY h.stored_from;






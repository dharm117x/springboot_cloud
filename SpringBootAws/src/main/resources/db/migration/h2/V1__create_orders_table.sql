CREATE TABLE orders (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    product VARCHAR(255) NOT NULL,
    quantity INT,
    total DOUBLE
);

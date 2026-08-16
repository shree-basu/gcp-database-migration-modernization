-- Source OLTP schema for a small e-commerce shop.
-- Deliberately includes FKs, indexes, a CHECK, a view, and a sequence.

CREATE TABLE customers (
    customer_id   BIGSERIAL PRIMARY KEY,
    email         VARCHAR(255) NOT NULL UNIQUE,
    full_name     VARCHAR(200) NOT NULL,
    country       CHAR(2)      NOT NULL,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE products (
    product_id    BIGSERIAL PRIMARY KEY,
    sku           VARCHAR(64)  NOT NULL UNIQUE,
    name          VARCHAR(200) NOT NULL,
    price_cents   INTEGER      NOT NULL CHECK (price_cents >= 0),
    is_active     BOOLEAN      NOT NULL DEFAULT true
);

CREATE TABLE orders (
    order_id      BIGSERIAL PRIMARY KEY,
    customer_id   BIGINT       NOT NULL REFERENCES customers(customer_id),
    status        VARCHAR(20)  NOT NULL DEFAULT 'pending',
    order_ts      TIMESTAMPTZ  NOT NULL DEFAULT now(),
    total_cents   INTEGER      NOT NULL DEFAULT 0
);

CREATE TABLE order_items (
    order_item_id BIGSERIAL PRIMARY KEY,
    order_id      BIGINT  NOT NULL REFERENCES orders(order_id),
    product_id    BIGINT  NOT NULL REFERENCES products(product_id),
    quantity      INTEGER NOT NULL CHECK (quantity > 0),
    unit_cents    INTEGER NOT NULL
);

CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_status   ON orders(status);
CREATE INDEX idx_items_order     ON order_items(order_id);

CREATE VIEW v_customer_order_totals AS
SELECT c.customer_id, c.email,
       COUNT(o.order_id)              AS order_count,
       COALESCE(SUM(o.total_cents),0) AS lifetime_cents
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.email;
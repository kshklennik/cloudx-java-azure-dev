package com.chtrembl.petstore.order.model;

import lombok.Data;

import java.util.List;

@Data
public class OrderItemRq {

    private String sessionId;
    private String orderId;
    private List<ProductRegisterRq> products;
}

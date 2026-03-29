package com.epam.jmp.petstoreorderitems.entity;

import lombok.Data;

import java.util.List;

@Data
public class OrderItemRq {

    private String sessionId;
    private String orderId;
    private List<Product> products;
}

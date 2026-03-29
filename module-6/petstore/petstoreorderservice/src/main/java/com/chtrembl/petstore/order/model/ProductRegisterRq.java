package com.chtrembl.petstore.order.model;

import lombok.Data;

@Data
public class ProductRegisterRq {

    private String productId;
    private String name;
    private int quantity;
}

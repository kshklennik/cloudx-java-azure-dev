package com.epam.jmp.petstoreorderitems.service;

import com.epam.jmp.petstoreorderitems.entity.OrderItemRq;

public interface PetBlobService {
    void reserve(OrderItemRq orderData);
}

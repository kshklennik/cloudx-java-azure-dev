package com.epam.jmp.petstoreorderitems;

import com.epam.jmp.petstoreorderitems.entity.OrderItemRq;
import com.epam.jmp.petstoreorderitems.service.PetBlobService;
import com.epam.jmp.petstoreorderitems.service.PetBlobServiceImpl;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.microsoft.azure.functions.*;
import com.microsoft.azure.functions.annotation.AuthorizationLevel;
import com.microsoft.azure.functions.annotation.FunctionName;
import com.microsoft.azure.functions.annotation.HttpTrigger;
import org.apache.commons.lang3.StringUtils;

import java.util.Optional;

public class Function {

    private final ObjectMapper mapper = new ObjectMapper();

    @FunctionName("register")
    public HttpResponseMessage run(
            @HttpTrigger(
                    name = "req",
                    methods = {HttpMethod.POST},
                    authLevel = AuthorizationLevel.ANONYMOUS
            ) HttpRequestMessage<Optional<String>> request,
            final ExecutionContext context) {

        try {
            String body = request.getBody().orElseThrow(() ->
                    new IllegalArgumentException("Empty request body"));

            OrderItemRq orderData = mapper.readValue(body, OrderItemRq.class);

            if (StringUtils.isBlank(orderData.getSessionId())) {
                return request.createResponseBuilder(HttpStatus.BAD_REQUEST)
                        .body("sessionId is required")
                        .build();
            }

            PetBlobService petBlobService = new PetBlobServiceImpl();
            petBlobService.reserve(orderData);

            return request.createResponseBuilder(HttpStatus.OK)
                    .body("Order saved for session: " + orderData.getSessionId())
                    .build();

        } catch (Exception e) {
            return request.createResponseBuilder(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error processing request: " + e.getMessage())
                    .build();
        }
    }
}
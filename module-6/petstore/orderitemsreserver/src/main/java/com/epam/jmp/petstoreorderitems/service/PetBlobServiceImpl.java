package com.epam.jmp.petstoreorderitems.service;

import com.azure.core.util.BinaryData;
import com.azure.storage.blob.BlobClient;
import com.azure.storage.blob.BlobContainerClient;
import com.azure.storage.blob.BlobServiceClient;
import com.azure.storage.blob.BlobServiceClientBuilder;
import com.epam.jmp.petstoreorderitems.entity.OrderItemRq;
import com.fasterxml.jackson.databind.ObjectMapper;

public class PetBlobServiceImpl implements PetBlobService {

    public static final String AZURE_STORAGE_CONNECTION_STRING = "AZURE_STORAGE_CONNECTION_STRING";
    public static final String FILE_NAME_TEMPLATE = "session-%s.json";
    private static final String CONTAINER_NAME = "products";

    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    public void reserve(OrderItemRq orderData) {
        try {
            String json = mapper.writeValueAsString(orderData);
            String connectionString = System.getenv(AZURE_STORAGE_CONNECTION_STRING);

            BlobServiceClient blobServiceClient =
                    new BlobServiceClientBuilder()
                            .connectionString(connectionString)
                            .buildClient();

            BlobContainerClient containerClient =
                    blobServiceClient.getBlobContainerClient(CONTAINER_NAME);

            if (!containerClient.exists()) {
                containerClient.create();
            }

            String blobName = String.format(FILE_NAME_TEMPLATE, orderData.getSessionId());

            BlobClient blobClient = containerClient.getBlobClient(blobName);

            blobClient.upload(BinaryData.fromString(json), true);
        } catch (Exception e) {
            throw new RuntimeException("Error saving order to blob storage", e);
        }
    }
}

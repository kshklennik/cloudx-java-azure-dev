package com.chtrembl.petstore.product.model;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonValue;
import jakarta.persistence.*;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
public class Product {
    @Id
    private Long id;

    @Valid
    @ManyToOne
    private Category category;

    @NotNull
    private String name;

    @JsonProperty("photoURL")
    @NotNull
    @Column(name = "photo_url")
    private String photoURL;

    @Valid
    @Builder.Default
    @ManyToMany
    private List<Tag> tags = new ArrayList<>();

    @Enumerated(EnumType.STRING)
    private Status status;

    public Product name(String name) {
        this.name = name;
        return this;
    }

    public enum Status {
        AVAILABLE("available"),
        PENDING("pending"),
        SOLD("sold");

        private final String value;

        Status(String value) {
            this.value = value;
        }

        @JsonCreator
        public static Status fromValue(String value) {
            for (Status b : Status.values()) {
                if (b.value.equals(value)) {
                    return b;
                }
            }
            throw new IllegalArgumentException("Unexpected value '" + value + "'");
        }

        @JsonValue
        public String getValue() {
            return value;
        }

        @Override
        public String toString() {
            return String.valueOf(value);
        }
    }
}
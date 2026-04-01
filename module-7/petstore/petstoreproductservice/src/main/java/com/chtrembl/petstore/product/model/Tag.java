package com.chtrembl.petstore.product.model;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
public class Tag {
    @Id
    private Long id;
    private String name;

    public Tag name(String name) {
        this.name = name;
        return this;
    }
}
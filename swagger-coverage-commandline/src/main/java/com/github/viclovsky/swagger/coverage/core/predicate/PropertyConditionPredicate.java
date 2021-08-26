package com.github.viclovsky.swagger.coverage.core.predicate;

import io.swagger.v3.oas.models.Operation;
import io.swagger.v3.oas.models.media.ComposedSchema;
import io.swagger.v3.oas.models.media.Schema;

import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Stream;

public abstract class PropertyConditionPredicate extends ConditionPredicate {
    protected String mediaTypeName;
    protected String propertyName;

    public PropertyConditionPredicate(String mediaTypeName, String propertyName) {
        this.mediaTypeName = mediaTypeName;
        this.propertyName = propertyName;
    }

    @Override
    public boolean check(Operation operation) {
        if (operation.getRequestBody() == null ||
                operation.getRequestBody().getContent() == null ||
                operation.getRequestBody().getContent().isEmpty()) {
            return false;
        }
//        Optional<Schema> schema = operation.getRequestBody().getContent().entrySet()
//                .stream()
//                .filter(o -> mediaTypeName.equals(o.getKey()))
//                .map(o -> o.getValue().getSchema())
//                .filter(Objects::nonNull)
//                .filter(o -> o.getProperties() != null)
//                .flatMap(o -> (Stream<Map.Entry<String, Schema>>) o.getProperties().entrySet().stream())
//                .filter(o -> propertyName.equals(o.getKey()))
//                .map(o -> o.getValue())
//                .findFirst();
//        return check(schema);
        Optional<Schema> schema = operation.getRequestBody().getContent().entrySet()
                .stream()
                .filter(o -> mediaTypeName.equals(o.getKey()))
                .map(o -> o.getValue().getSchema())
                .filter(Objects::nonNull)
                .filter(o -> o.getClass() == ComposedSchema.class)
                .filter(o -> ((ComposedSchema) o).getOneOf() != null)
                .flatMap(o->((ComposedSchema) o).getOneOf().stream())
                .filter(o -> { System.out.println("test123"+ o); return true;})
                .flatMap(o -> (Stream<Map.Entry<String, Schema>>) o.getProperties().entrySet().stream())
                .filter(o -> propertyName.equals(o.getKey()))
                .map(o -> o.getValue())
                .findFirst();
        return check(schema);
    }

    public String getPropertyName() {
        return propertyName;
    }

    public String getMediaTypeName() {
        return mediaTypeName;
    }

    public PropertyConditionPredicate setPropertyName(String propertyName) {
        this.propertyName = propertyName;
        return this;
    }

    public PropertyConditionPredicate setMediaTypeName(String mediaTypeName) {
        this.mediaTypeName = mediaTypeName;
        return this;
    }

    protected abstract boolean check(Optional<Schema> schema);

}

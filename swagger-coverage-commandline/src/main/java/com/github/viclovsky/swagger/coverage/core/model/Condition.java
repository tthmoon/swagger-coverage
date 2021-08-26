package com.github.viclovsky.swagger.coverage.core.model;

import io.swagger.v3.oas.models.Operation;

public abstract class Condition {

    private String name;
    private String description;
    boolean covered = false;

    public Condition(String name, String description) {
        this.name = name;
        this.description = description;
    }

    public abstract void postCheck();

    public abstract boolean isHasPostCheck();

    public abstract boolean isNeedCheck();

    public abstract boolean check(Operation operation);

    public abstract String getReason();

    public abstract String getType();

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isCovered() {
        return covered;
    }

    public void setCovered(boolean covered) {
        this.covered = covered;
    }

    @Override
    public String toString() {
        return "Condition{" +
                "name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", covered=" + covered +
                '}';
    }
}

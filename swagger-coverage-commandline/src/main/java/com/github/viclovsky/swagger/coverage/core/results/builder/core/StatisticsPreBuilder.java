package com.github.viclovsky.swagger.coverage.core.results.builder.core;

public abstract class StatisticsPreBuilder extends StatisticsBuilder {

    @Override
    public boolean isPreBuilder() {
        return true;
    }

    @Override
    public boolean isPostBuilder() {
        return false;
    }
}

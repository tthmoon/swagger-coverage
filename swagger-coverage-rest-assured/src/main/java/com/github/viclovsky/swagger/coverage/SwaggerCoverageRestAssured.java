package com.github.viclovsky.swagger.coverage;

import io.restassured.filter.FilterContext;
import io.restassured.filter.OrderedFilter;
import io.restassured.response.Response;
import io.restassured.specification.FilterableRequestSpecification;
import io.restassured.specification.FilterableResponseSpecification;
import io.swagger.models.Operation;
import io.swagger.models.Swagger;
import io.swagger.models.parameters.BodyParameter;
import io.swagger.models.parameters.FormParameter;
import io.swagger.models.parameters.HeaderParameter;
import io.swagger.models.parameters.PathParameter;
import io.swagger.models.parameters.QueryParameter;

import java.net.URI;
import java.nio.file.Paths;
import java.util.Objects;

import static com.github.viclovsky.swagger.coverage.SwaggerCoverageConstants.BODY_PARAM_NAME;
import static com.github.viclovsky.swagger.coverage.SwaggerCoverageConstants.OUTPUT_DIRECTORY;
import static io.swagger.models.Scheme.forValue;
import static java.lang.String.valueOf;

public class SwaggerCoverageRestAssured implements OrderedFilter {

    private CoverageOutputWriter writer;

    public SwaggerCoverageRestAssured(CoverageOutputWriter writer) {
        this.writer = writer;
    }

    public SwaggerCoverageRestAssured() {
        this.writer = new FileSystemOutputWriter(Paths.get(OUTPUT_DIRECTORY));
    }

    @Override
    public int getOrder() {
        return Integer.MAX_VALUE;
    }

    @Override
    public Response filter(FilterableRequestSpecification requestSpec, FilterableResponseSpecification responseSpec, FilterContext ctx) {
        Operation operation = new Operation();
        requestSpec.getPathParams().forEach((n, v) -> operation.addParameter(new PathParameter().name(n).example(v)));
        //Ignore ClassCastException for https://github.com/rest-assured/rest-assured/issues/1232
        try {
            requestSpec.getQueryParams().forEach((n, v) -> operation.addParameter(new QueryParameter().name(n).example(v)));
        } catch (ClassCastException ex) {
            requestSpec.getQueryParams().keySet().forEach(n -> operation.addParameter(new QueryParameter().name(n)));
        }
        try {
            requestSpec.getFormParams().forEach((n, v) -> operation.addParameter(new FormParameter().name(n).example(v)));
        } catch (ClassCastException ex) {
            requestSpec.getFormParams().keySet().forEach((n -> operation.addParameter(new FormParameter().name(n))));
        }
        //end
        requestSpec.getHeaders().forEach(header -> operation.addParameter(new HeaderParameter().name(header.getName())
                .example(header.getValue())));

        requestSpec.getMultiPartParams().forEach(multiPartSpecification -> operation.addParameter(new FormParameter()
                .name(multiPartSpecification.getControlName())));

        if (Objects.nonNull(requestSpec.getBody())) {
            operation.addParameter(new BodyParameter().name(BODY_PARAM_NAME));
        }

        final Response response = ctx.next(requestSpec, responseSpec);

        operation.addResponse(valueOf(response.statusCode()), new io.swagger.models.Response());

        Swagger swagger = new Swagger()
                .scheme(forValue(URI.create(requestSpec.getURI()).getScheme()))
                .host(URI.create(requestSpec.getURI()).getHost())
                .consumes(requestSpec.getContentType())
                .produces(response.getContentType())
                .path(requestSpec.getUserDefinedPath(), new io.swagger.models.Path().set(requestSpec.getMethod().toLowerCase(), operation));

        writer.write(swagger);
        return response;
    }
}
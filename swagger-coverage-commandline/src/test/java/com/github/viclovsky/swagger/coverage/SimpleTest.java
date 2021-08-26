package com.github.viclovsky.swagger.coverage;

import com.github.viclovsky.swagger.coverage.core.generator.Generator;
import org.hamcrest.io.FileMatchers;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;
import java.util.Collection;

import static com.github.viclovsky.swagger.coverage.SwaggerCoverageConstants.COVERAGE_HTML_REPORT_NAME;
import static com.github.viclovsky.swagger.coverage.SwaggerCoverageConstants.COVERAGE_RESULTS_NAME;
import static java.nio.file.Paths.get;
import static org.hamcrest.MatcherAssert.assertThat;

@RunWith(Parameterized.class)
public class SimpleTest {

    private static final String V2_OUTPUT_SWAGGER_COVERAGE_DIR = "v2/swagger-coverage-output";
    private static final String V3_OUTPUT_SWAGGER_COVERAGE_DIR = "v3/swagger-coverage-output";
    private static final String CONFIGURATION_FILE = "full_configuration.json";
    private final Config config;

    public SimpleTest(Config config) {
        this.config = config;
    }

    @Parameterized.Parameters()
    public static Collection<Object[]> testData() {
        return Arrays.asList(new Object[][]{
                //Swagger v2
                {new Config(CONFIGURATION_FILE, V2_OUTPUT_SWAGGER_COVERAGE_DIR, "v2/petstory.json")},
                {new Config(CONFIGURATION_FILE, V2_OUTPUT_SWAGGER_COVERAGE_DIR, "v2/petstory_no_tags.json")},
                {new Config(CONFIGURATION_FILE, V2_OUTPUT_SWAGGER_COVERAGE_DIR, "v2/petstory_operation_wo_tags.json")},
                {new Config(CONFIGURATION_FILE, V2_OUTPUT_SWAGGER_COVERAGE_DIR, "v2/petstory_with_x_example.json")},
                {new Config(CONFIGURATION_FILE, V2_OUTPUT_SWAGGER_COVERAGE_DIR, "v2/petstory_without_parameters.json")},
                //Swagger v3
                {new Config(CONFIGURATION_FILE, V3_OUTPUT_SWAGGER_COVERAGE_DIR, "v3/petstory.yaml")},
                {new Config(CONFIGURATION_FILE, V3_OUTPUT_SWAGGER_COVERAGE_DIR, "v3/petstory_no_tags.yaml")},
                {new Config(CONFIGURATION_FILE, V3_OUTPUT_SWAGGER_COVERAGE_DIR, "v3/petstory_operation_wo_tags.yaml")},
                {new Config(CONFIGURATION_FILE, V3_OUTPUT_SWAGGER_COVERAGE_DIR, "v3/petstory_with_x_example.yaml")},
                {new Config(CONFIGURATION_FILE, V3_OUTPUT_SWAGGER_COVERAGE_DIR, "v3/petstory_without_parameters.yaml")}
        });
    }

    @Test
    public void simpleTest() {
        new Generator()
                .setInputPath(config.getOutput())
                .setSpecPath(config.getSpec())
                .run();

        assertThat(get(COVERAGE_HTML_REPORT_NAME).toFile(), FileMatchers.anExistingFile());
        assertThat(get(COVERAGE_RESULTS_NAME).toFile(), FileMatchers.anExistingFile());
    }

    @Test
    public void simpleTestWithConfiguration() {
        new Generator()
                .setInputPath(config.getOutput())
                .setSpecPath(config.getSpec())
                .setConfigurationPath(config.getPath())
                .run();

        assertThat(get("custom-report.html").toFile(), FileMatchers.anExistingFile());
        assertThat(get("json-report.json").toFile(), FileMatchers.anExistingFile());
    }
}

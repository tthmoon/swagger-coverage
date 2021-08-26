package com.github.viclovsky.swagger.coverage.utils;

import freemarker.cache.FileTemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import static java.nio.charset.StandardCharsets.UTF_8;

/**
 * @author eroshenkoam (Artem Eroshenko).
 */
public final class FreemarkerUtils {

    private static final Logger log = LoggerFactory.getLogger(FreemarkerUtils.class);

    private final static String TEMPLATES = "templates";

    private FreemarkerUtils() {
    }

    public static String processTemplate(final String path, final Object object) {
        return processTemplate(path,"en",object);
    }

    private static String proccessTemplate(Configuration configuration, String locale, String templateName,
                                           final Object object) {
        Map<String, String> messages = readMessages(locale);

        try {
            final Map<String, Object> data = new HashMap<>();
            data.put("data", object);
            data.put("messages", messages);

            final Writer writer = new StringWriter();
            final Template template = configuration.getTemplate(templateName);
            template.process(data, writer);
            return writer.toString();
        } catch (IOException | TemplateException e) {
            throw new RuntimeException(e);
        }
    }

    public static String processTemplate(final String path, String locale, final Object object) {
        final Configuration configuration = new Configuration(Configuration.VERSION_2_3_28);

        configuration.setClassForTemplateLoading(FreemarkerUtils.class, "/");
        configuration.setDefaultEncoding("UTF-8");

        return proccessTemplate(configuration, locale, path, object);
    }

    public static String processCustomTemplate(final String customTemplatePath, String locale, Object object)
            throws IOException {
        File template = new File(customTemplatePath);
        final Configuration configuration = new Configuration(Configuration.VERSION_2_3_28);

        configuration.setTemplateLoader(new FileTemplateLoader(template.getParentFile()));
        configuration.setDefaultEncoding("UTF-8");
        return proccessTemplate(configuration, locale, template.getName(), object);
    }

    public static Map<String, String> readMessages(String localeCode){
        Properties properties = new Properties();
        HashMap<String, String> mymap= new HashMap<String, String>();

        String resourceName = "message." + localeCode; // could also be a constant
        log.info("read locale from " + resourceName);
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        try(InputStream resourceStream = loader.getResourceAsStream(resourceName)) {
            InputStreamReader isr = new InputStreamReader(resourceStream, UTF_8);
            properties.load(isr);
        } catch (Exception e) {
            log.error("can't read locale resource" + e);
        }

        for (String key : properties.stringPropertyNames()) {
            String value = properties.getProperty(key);
            mymap.put(key, value);
        }

        return mymap;
    }

}

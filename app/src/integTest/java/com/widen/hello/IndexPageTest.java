package com.widen.hello;

import org.junit.Test;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import static org.junit.Assert.assertTrue;

public class IndexPageTest {

    @Test
    public void testNoQuery() throws IOException {
        String txt = getUrlText(new URL("http://app:8080/"));
        assertTrue("No error message", txt.contains("java.lang.NullPointerException: Name cannot be null or empty"));
    }

    @Test
    public void testQuery() throws IOException {
        String txt = getUrlText(new URL("http://app:8080/?name=world"));
        assertTrue("No hello world", txt.contains("Hello, world!"));
    }

    private static String getUrlText(URL url) throws IOException {
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setConnectTimeout(2000);
        connection.setReadTimeout(2000);
        connection.connect();

        try {
            return readStream(connection.getInputStream());
        } catch (IOException e) {
            return readStream(connection.getErrorStream());
        }

    }

    private static String readStream(InputStream is) throws IOException {
        StringBuilder content = new StringBuilder();
        try (BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(is))) {
            String line;
            while ((line = bufferedReader.readLine()) != null) {
                content.append(line).append("\n");
            }
        }
        return content.toString();
    }
}

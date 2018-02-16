package com.widen.hello;

public class MessageGenerator {

    public String hello(String name) {
        if (name == null || name.isEmpty()) {
            throw new NullPointerException("Name cannot be null or empty");
        }
        return String.format("Hello, %s!", name);
    }

}

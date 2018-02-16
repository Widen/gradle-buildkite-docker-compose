package com.widen.hello;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class MessageTest {

    @Test(expected = NullPointerException.class)
    public void testNull() {
        new MessageGenerator().hello(null);
    }

    @Test
    public void testHello() {
        String msg = new MessageGenerator().hello("world");
        assertEquals("Hello, world!", msg);
    }

}

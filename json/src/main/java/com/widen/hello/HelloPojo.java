package com.widen.hello;

public class HelloPojo {

    private String helloArg1;

    private String helloArg2;

    public HelloPojo(String helloArg1, String helloArg2) {
        this.helloArg1 = helloArg1;
        this.helloArg2 = helloArg2;
    }

    public String getHelloArg1() {
        return helloArg1;
    }

    public HelloPojo setHelloArg1(String helloArg1) {
        this.helloArg1 = helloArg1;
        return this;
    }

    public String getHelloArg2() {
        return helloArg2;
    }

    public HelloPojo setHelloArg2(String helloArg2) {
        this.helloArg2 = helloArg2;
        return this;
    }

}

package com.lightstep.tracer.samples.jre;

import com.lightstep.tracer.Tracer;
import com.lightstep.tracer.Span;

public class Simple {
    public static void main(String[] args) {
        System.out.println("Starting Simple example...");

        Tracer tracer = new com.lightstep.tracer.jre.JRETracer(
            new com.lightstep.tracer.shared.Options("{your_access_token}"));

        Span span = tracer.buildSpan("test_span").start();
        span.finish();

        System.out.println("Done!");
    }
}
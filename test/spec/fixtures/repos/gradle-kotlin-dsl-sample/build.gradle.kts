plugins {
    kotlin("jvm")
    application
}

application {
    mainClassName = "samples.HelloWorldKt"
}

dependencies {
    compile(kotlin("stdlib"))
    compile("org.eclipse.jetty:jetty-servlet:9.4.6.v20170531")
    compile("javax.servlet:javax.servlet-api:3.1.0")
}

repositories {
    jcenter()
}

tasks {
    "copyLibs"(Copy::class) {
        into("$buildDir/libs")
        from(configurations.compile)
    }

    "stage" {
        dependsOn("build")
        dependsOn("copyLibs")
    }
}
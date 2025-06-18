plugins {
	java
	id("org.springframework.boot") version "3.5.0"
	id("io.spring.dependency-management") version "1.1.7"
}

group = "com.example"
version = "0.0.1-SNAPSHOT"

java {
	toolchain {
		languageVersion = JavaLanguageVersion.of(17)
	}
}

repositories {
	mavenCentral()
}

dependencies {
	implementation("org.springframework.boot:spring-boot-starter-web")
	testImplementation("org.springframework.boot:spring-boot-starter-test")
	testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

tasks.withType<Test> {
	useJUnitPlatform()
}

tasks.build {
	finalizedBy("duplicate-jars")
}

tasks.register<Copy>("duplicate-jars") {
	into(layout.buildDirectory.dir("libs"))
	with(copySpec {
		from(layout.buildDirectory.dir("libs"))
		include("*.jar")
		rename("\\.jar", "-additional.jar")
	})
}

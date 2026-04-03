allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = JavaVersion.VERSION_17.toString()
        targetCompatibility = JavaVersion.VERSION_17.toString()
        options.compilerArgs.add("-Xlint:-options")
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

fun Project.applyNamespaceFallback() {
    val androidExtension = extensions.findByName("android") ?: return
    val manifestFile = file("src/main/AndroidManifest.xml")
    if (!manifestFile.exists()) return

    val currentNamespace =
        try {
            androidExtension.javaClass
                .getMethod("getNamespace")
                .invoke(androidExtension) as? String
        } catch (_: Exception) {
            null
        }

    if (!currentNamespace.isNullOrBlank()) return

    val manifestContents = manifestFile.readText()
    val manifestNamespace =
        Regex("""package\s*=\s*"([^"]+)"""")
            .find(manifestContents)
            ?.groupValues
            ?.getOrNull(1)
            ?.trim()

    if (manifestNamespace.isNullOrBlank()) return

    try {
        androidExtension.javaClass
            .getMethod("setNamespace", String::class.java)
            .invoke(androidExtension, manifestNamespace)
    } catch (_: Exception) {
        // Ignore projects that don't expose the Android namespace setter.
    }
}

subprojects {
    if (state.executed) {
        applyNamespaceFallback()
    } else {
        afterEvaluate {
            applyNamespaceFallback()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

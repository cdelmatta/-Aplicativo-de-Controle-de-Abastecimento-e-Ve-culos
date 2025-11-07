allprojects {
    repositories {
        google()
        mavenCentral()
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

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.2'
    }
}
plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
    // se você usou a forma moderna:
    id 'com.google.gms.google-services'
}

// ... ou, se estiver usando a forma antiga:
apply plugin: 'com.google.gms.google-services'

android {
    namespace "com.seunome.controleabastecimento" // ou com.example...
    defaultConfig {
        applicationId "com.seunome.controleabastecimento" // idem
        minSdkVersion 23   // recomendo 23 p/ evitar problemas com libs Firebase
        targetSdkVersion 34
        // ...
    }
}

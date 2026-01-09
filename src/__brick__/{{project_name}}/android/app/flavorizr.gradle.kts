import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationId = "{{app_id}}.dev"
            resValue(type = "string", name = "app_name", value = "{{app_name}} [DEV]")
        }
        create("stg") {
            dimension = "flavor-type"
            applicationId = "{{app_id}}.stg"
            resValue(type = "string", name = "app_name", value = "{{app_name}} [STG]")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "{{app_id}}"
            resValue(type = "string", name = "app_name", value = "{{app_name}}")
        }
    }
}
